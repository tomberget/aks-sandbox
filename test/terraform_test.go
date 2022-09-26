package terraform

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TerraformAzureTest(t *testing.T) {
	t.Parallel()

	subscriptionID := "" // subscriptionID is overridden by the environment variable "ARM_SUBSCRIPTION_ID"
	uniquePostfix := random.UniqueId()
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

	// Resource group name, used for testing :: Run `terraform output` to get the values of output variables
	resourceGroupName := terraform.Output(t, terraformOptions, "aks_resource_group_name")

	// define original workspace
	originalWorkspace, err := terraform.RunTerraformCommandAndGetStdoutE(t, terraformOptions, "workspace", "show")
	if err != nil || originalWorkspace == "" {
		originalWorkspace = "sandbox"
	}

	defer func() {
		// website::tag::4:: At the end of the test, run `terraform destroy` to clean up any resources that were created
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

	// Terratest Resource Group Name
	TestTerraformAzureResourceGroup(t, terraformOptions, resourceGroupName, subscriptionID)

	// Terratest AKS cluster creation
	TestTerraformAzureAKS(t, terraformOptions, tfEnvironment, uniquePostfix, resourceGroupName, subscriptionID)
}

func TestTerraformAzureResourceGroup(t *testing.T, o *terraform.Options, resourceGroupName string, subscriptionID string) {
	// Verify the items exists
	existsAksResourceGroup := azure.ResourceGroupExists(t, resourceGroupName, subscriptionID)

	// Verify Resource Group creation
	assert.True(t, existsAksResourceGroup, "Resource group does not exist")
}

func TestTerraformAzureAKS(t *testing.T, o *terraform.Options, tfEnvironment string, uniquePostfix string, resourceGroupName string, subscriptionID string) {
	// Expected output
	expectedClusterName := fmt.Sprintf("aks-cluster-%s-%s", tfEnvironment, uniquePostfix)
	expectedClusterLocation := "westeurope"

	aksClusterName := terraform.Output(t, o, "aks_cluster_name")
	actualAksCluster, _ := azure.GetManagedClusterE(t, resourceGroupName, aksClusterName, subscriptionID)

	// Verify AKS Creation
	assert.Equal(t, expectedClusterName, *(*&actualAksCluster.Name), "AKS cluster names do not match.")
	assert.Equal(t, expectedClusterLocation, *(*&actualAksCluster.Location), "Azure location is not correct.")
}
