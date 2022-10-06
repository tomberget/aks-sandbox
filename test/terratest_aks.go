package terratest

import (
	"fmt"
	"strconv"
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TerraTestAzureAKS(t *testing.T, o *terraform.Options, tfEnvironment string, uniquePostfix string, resourceGroupName string, subscriptionID string) {
	// Expected output
	expectedClusterName := fmt.Sprintf("aks-cluster-%s-%s", tfEnvironment, uniquePostfix)
	expectedClusterLocation := "westeurope"
	expectedNodeCount, _ := strconv.ParseInt(terraform.GetVariableAsStringFromVarFile(t, "../tfvars/terratest.tfvars", "aks_default_node_count"), 10, 32)

	// Actual output
	aksClusterName := terraform.Output(t, o, "aks_cluster_name")
	actualAksCluster, err := azure.GetManagedClusterE(t, resourceGroupName, aksClusterName, subscriptionID)
	require.NoError(t, err)
	actualNodeCount := *(*actualAksCluster.ManagedClusterProperties.AgentPoolProfiles)[0].Count

	// Verify AKS Creation
	assert.Equal(t, expectedClusterName, *(*&actualAksCluster.Name), "AKS cluster names do not match.")
	assert.Equal(t, expectedClusterLocation, *(*&actualAksCluster.Location), "Azure location is not correct.")

	// Test that the Node count matches the Terraform specification
	assert.Equal(t, int32(expectedNodeCount), actualNodeCount)
}
