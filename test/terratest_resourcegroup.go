package terratest

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TerraTestAzureResourceGroup(t *testing.T, o *terraform.Options, resourceGroupName string, subscriptionID string) {
	// Verify the items exists
	existsAksResourceGroup := azure.ResourceGroupExists(t, resourceGroupName, subscriptionID)

	// Verify Resource Group creation
	assert.True(t, existsAksResourceGroup, "Resource group does not exist")
}
