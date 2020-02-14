package test

import (
	"testing"

	// "github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2018-06-01/compute"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestVnet(t *testing.T) {
	dir := "../vnet"
	tfOption := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: dir,
	}
	defer terraform.Destroy(t, tfOption)

	// Terraform init and plan only
	// tfPlanOutput := dir + ".terraform.tfplan"
	terraform.RunTerraformCommand(t, tfOption, terraform.FormatArgs(tfOption, "fmt")...)
	terraform.InitAndPlan(t, tfOption)
	// terraform.RunTerraformCommand(t, tfOption, terraform.FormatArgs(tfOption, "plan", "-out="+tfPlanOutput)...)
	// terraform.Apply(t, tfOption)
	// actualResourceGroupName := terraform.Output(t, tfOption, "resource_group")
	// expectedResourceGroupName := "vnet"
	// assert.Equal(t, expectedResourceGroupName, actualResourceGroupName)
}

func TestContainers(t *testing.T) {
	dir := "../containers"
	tfOption := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: dir,
	}
	defer terraform.Destroy(t, tfOption)
	terraform.RunTerraformCommand(t, tfOption, terraform.FormatArgs(tfOption, "fmt")...)
	terraform.InitAndPlan(t, tfOption)
	// actualResourceGroupName := terraform.Output(t, tfOption, "resource_group")
	// expectedResourceGroupName := "containers"
	// assert.Equal(t, expectedResourceGroupName, actualResourceGroupName)
}

func TestElasticPool(t *testing.T) {
	dir := "../elastic_pool"
	tfOption := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: dir,
	}
	defer terraform.Destroy(t, tfOption)
	terraform.RunTerraformCommand(t, tfOption, terraform.FormatArgs(tfOption, "fmt")...)
	terraform.InitAndPlan(t, tfOption)
	// actualResourceGroupName := terraform.Output(t, tfOption, "resource_group")
	// expectedResourceGroupName := "elasticpool"
	// assert.Equal(t, expectedResourceGroupName, actualResourceGroupName)
}

func TestK8s(t *testing.T) {
	expectedClusterName := "dev-cluster"
	expectedResourceGroupName := "k8s"
	expectedAgentCount := 1
	dir := "../k8s"
	tfOption := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: dir,
	}
	defer terraform.Destroy(t, tfOption)
	terraform.RunTerraformCommand(t, tfOption, terraform.FormatArgs(tfOption, "fmt")...)
	terraform.InitAndApply(t, tfOption)
	
	// Look up the cluster node count
	cluster, err := azure.GetManagedClusterE(t, expectedResourceGroupName, expectedClusterName, "")
	require.NoError(t, err)
	actualCount := *(*cluster.ManagedClusterProperties.AgentPoolProfiles)[0].Count

	// Test that the Node count matches the Terraform specification
	assert.Equal(t, int32(expectedAgentCount), actualCount)
}

// func TestStorageAccountName(t *testing.T) {
// 	t.Parallel()

// 	// Test cases for storage account name conversion logic
// 	testCases := map[string]string{
// 		"TestWebsiteName": "testwebsitenamedata001",
// 		"ALLCAPS":         "allcapsdata001",
// 		"S_p-e(c)i.a_l":   "specialdata001",
// 		"A1phaNum321":     "a1phanum321data001",
// 		"E5e-y7h_ng":      "e5ey7hngdata001",
// 	}

// 	for input, expected := range testCases {
// 		// Specify the test case folder and "-var" options
// 		tfOptions := &terraform.Options{
// 			TerraformDir: "../",
// 			Vars: map[string]interface{}{
// 				"website_name": input,
// 			},
// 		}

// 		// Terraform init and plan only
// 		tfPlanOutput := "terraform.tfplan"
// 		terraform.Init(t, tfOptions)
// 		terraform.RunTerraformCommand(t, tfOptions, terraform.FormatArgs(tfOptions, "plan", "-out="+tfPlanOutput)...)

// 		// Read and parse the plan output
// 		f, err := os.Open(path.Join(tfOptions.TerraformDir, tfPlanOutput))
// 		if err != nil {
// 			t.Fatal(err)
// 		}
// 		defer f.Close()
// 		plan, err := terraformCore.ReadPlan(f)
// 		if err != nil {
// 			t.Fatal(err)
// 		}

// 		// Validate the test result
// 		for _, mod := range plan.Diff.Modules {
// 			if len(mod.Path) == 2 && mod.Path[0] == "root" && mod.Path[1] == "staticwebpage" {
// 				actual := mod.Resources["azurerm_storage_account.main"].Attributes["name"].New
// 				if actual != expected {
// 					t.Fatalf("Expect %v, but found %v", expected, actual)
// 				}
// 			}
// 		}
// 	}
// }
