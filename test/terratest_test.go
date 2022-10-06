package terratest

import (
	"fmt"
	"strconv"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/require"
)

func TestTerraformAzure(t *testing.T) {
	t.Parallel()

	subscriptionID := "" // subscriptionID is overridden by the environment variable "ARM_SUBSCRIPTION_ID"
	uniquePostfix := strings.ToLower(random.UniqueId())
	tfVarFiles := "./tfvars/terratest.tfvars"

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located, relative to the Go tests
		TerraformDir: "../",
		Vars: map[string]interface{}{
			"terratest_postfix": uniquePostfix,
		},
		VarFiles:    []string{tfVarFiles},
		Reconfigure: true,
	}

	// Some input
	tfEnvironment := terraform.GetVariableAsStringFromVarFile(t, "../tfvars/terratest.tfvars", "environment")
	temporaryWorkspace := fmt.Sprintf("%s-%s", tfEnvironment, uniquePostfix)

	// define original workspace
	originalWorkspace, err := terraform.RunTerraformCommandAndGetStdoutE(t, terraformOptions, "workspace", "show")
	if err != nil || originalWorkspace == "" {
		originalWorkspace = "sandbox"
	}

	defer func() {
		// At the end of the test, run `terraform destroy` to clean up any resources that were created
		terraform.Destroy(t, terraformOptions)

		// set workspace to the default workspace
		terraform.WorkspaceSelectOrNew(t, terraformOptions, originalWorkspace)

		// delete temporary terratest workspace
		terraform.WorkspaceDelete(t, terraformOptions, temporaryWorkspace)
	}()

	// Create new workspace for the terratest
	terraform.WorkspaceSelectOrNew(t, terraformOptions, temporaryWorkspace)

	// Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Resource group name, used for testing :: Run `terraform output` to get the values of output variables
	resourceGroupName := terraform.Output(t, terraformOptions, "aks_resource_group_name")

	// Terratest Resource Group Name
	TerraTestAzureResourceGroup(t, terraformOptions, resourceGroupName, subscriptionID)

	// Terratest AKS cluster creation
	// Create variable to check if AKS Cluster is enabled in the tfvars file
	aks_enabled, err := strconv.ParseBool(terraform.GetVariableAsStringFromVarFile(t, "../tfvars/terratest.tfvars", "aks_enabled"))
	require.NoError(t, err)

	// Only run AKS test if the variable `aks_enabled` is actually true
	if aks_enabled {
		// Test the managed AKS resource
		TerraTestAzureAKS(t, terraformOptions, tfEnvironment, uniquePostfix, resourceGroupName, subscriptionID)

		// Test Kubernetes
		TerraTestKubernetes(t, tfEnvironment, uniquePostfix)
	}
}
