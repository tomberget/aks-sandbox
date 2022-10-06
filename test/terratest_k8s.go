package terratest

import (
	"fmt"
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/stretchr/testify/require"
)

func TerraTestKubernetes(t *testing.T, tfEnvironment string, uniquePostfix string) {
	// Set and verify that the config file has been created
	kubeConfig, err := filepath.Abs("../kube/config")
	require.NoError(t, err)

	kubeNamespace := fmt.Sprintf("%s-%s", tfEnvironment, uniquePostfix)

	// Define the Kube options, using a set default namespace
	kubeOptions := k8s.NewKubectlOptions("", kubeConfig, kubeNamespace)

	// Create the namespace to use
	k8s.CreateNamespace(t, kubeOptions, kubeNamespace)
	// ... and make sure to delete the namespace at the end of the test
	defer k8s.DeleteNamespace(t, kubeOptions, kubeNamespace)
}
