package terraform

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TerraTestAzureAKS(t *testing.T, o *terraform.Options, tfEnvironment string, uniquePostfix string, resourceGroupName string, subscriptionID string) {
	// Expected output
	expectedClusterName := fmt.Sprintf("aks-cluster-%s-%s", tfEnvironment, uniquePostfix)
	expectedClusterLocation := "westeurope"

	aksClusterName := terraform.Output(t, o, "aks_cluster_name")
	actualAksCluster, _ := azure.GetManagedClusterE(t, resourceGroupName, aksClusterName, subscriptionID)

	// Verify AKS Creation
	assert.Equal(t, expectedClusterName, *(*&actualAksCluster.Name), "AKS cluster names do not match.")
	assert.Equal(t, expectedClusterLocation, *(*&actualAksCluster.Location), "Azure location is not correct.")
}
