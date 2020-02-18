package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	// "github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2018-06-01/compute"
	// "github.com/gruntwork-io/terratest/modules/azure"
	// "github.com/gruntwork-io/terratest/modules/k8s"
	// "github.com/stretchr/testify/assert"
	// "github.com/stretchr/testify/require"
)

func TestVnet(t *testing.T) {
	dir := "../vnet"
	tfOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: dir,
		Vars: map[string]interface{}{
			"region": "westeurope",
		},
	}
	defer terraform.Destroy(t, tfOptions)

	// Terraform init and plan only
	// tfPlanOutput := dir + ".terraform.tfplan"
	terraform.InitAndPlan(t, tfOptions)
	// terraform.RunTerraformCommand(t, tfOptions, terraform.FormatArgs(tfOption, "plan", "-out="+tfPlanOutput)...)
	// terraform.Apply(t, tfOptions)
	// actualResourceGroupName := terraform.Output(t, tfOption, "resource_group")
	// expectedResourceGroupName := "vnet"
	// assert.Equal(t, expectedResourceGroupName, actualResourceGroupName)
}

func TestContainers(t *testing.T) {
	dir := "../containers"
	tfOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: dir,
	}
	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndPlan(t, tfOptions)
	// actualResourceGroupName := terraform.Output(t, tfOptions, "resource_group")
	// expectedResourceGroupName := "containers"
	// assert.Equal(t, expectedResourceGroupName, actualResourceGroupName)
}

func TestElasticPool(t *testing.T) {
	dir := "../elastic_pool"
	tfOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: dir,
	}
	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndPlan(t, tfOptions)
	// actualResourceGroupName := terraform.Output(t, tfOption, "resource_group")
	// expectedResourceGroupName := "elasticpool"
	// assert.Equal(t, expectedResourceGroupName, actualResourceGroupName)
}

func TestK8s(t *testing.T) {
	// expectedClusterName := "dev-cluster"
	// expectedResourceGroupName := "k8s"
	// expectedAgentCount := 1
	dir := "../k8s"
	tfOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: dir,
	}
	defer terraform.Destroy(t, tfOptions)
	terraform.InitAndPlan(t, tfOptions)

	// Look up the cluster node count
	// cluster, err := azure.GetManagedClusterE(t, expectedResourceGroupName, expectedClusterName, "")
	// require.NoError(t, err)
	// actualCount := *(*cluster.ManagedClusterProperties.AgentPoolProfiles)[0].Count

	// Test that the Node count matches the Terraform specification
	// assert.Equal(t, int32(expectedAgentCount), actualCount)
}
