package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAzureResourceGroupExample(t *testing.T) {
	t.Parallel()

	subscriptionID := "" // subscriptionID is overridden by the environment variable "ARM_SUBSCRIPTION_ID"
	uniquePostfix := random.UniqueId()
	tfVarFiles := "./tfvars/terratest.tfvars"

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
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

	// Expected output
	expectedClusterName := fmt.Sprintf("aks-cluster-%s-%s", tfEnvironment, uniquePostfix)
	expectedClusterLocation := "westeurope"

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

	// website::tag::2:: Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// website::tag::3:: Run `terraform output` to get the values of output variables
	resourceGroupName := terraform.Output(t, terraformOptions, "aks_resource_group_name")
	aksClusterName := terraform.Output(t, terraformOptions, "aks_cluster_name")

	// website::tag::4:: Verify the items exists
	existsAksResourceGroup := azure.ResourceGroupExists(t, resourceGroupName, subscriptionID)
	actualAksCluster, err := azure.GetManagedClusterE(t, resourceGroupName, aksClusterName, subscriptionID)

	// Verify Resource Group creation
	assert.True(t, existsAksResourceGroup, "Resource group does not exist")

	// Verify AKS Creation
	assert.Equal(t, expectedClusterName, *(*&actualAksCluster.Name), "AKS cluster names do not match.")
	assert.Equal(t, expectedClusterLocation, *(*&actualAksCluster.Location), "Azure location is not correct.")

}
