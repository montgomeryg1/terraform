package test

import (
	"testing"

	"github.com/Azure/azure-sdk-for-go/profiles/latest/compute/mgmt/compute"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
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
}

func TestTerraformAzureExample(t *testing.T) {
	t.Parallel()

	// website::tag::1:: Configure Terraform setting up a path to Terraform code.
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../terraform-azure-example",
	}

	// t the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the values of output variables
	vmName := terraform.Output(t, terraformOptions, "vm_name")
	resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")

	// Look up the size of the given Virtual Machine and ensure it matches the output.
	actualVMSize := azure.GetSizeOfVirtualMachine(t, vmName, resourceGroupName, "")
	expectedVMSize := compute.VirtualMachineSizeTypes("Standard_B1s")
	assert.Equal(t, expectedVMSize, actualVMSize)
}
