package test

import (
	"os"
	"path"
	"testing"

	// "github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2018-06-01/compute"
	// "github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	terraformCore "github.com/hashicorp/terraform/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformAzure(t *testing.T) {
	t.Parallel()

	// website::tag::1:: Configure Terraform setting up a path to Terraform code.
	tfOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",
	}

	// website::tag::4:: At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, tfOptions)

	// website::tag::2:: Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, tfOptions)

	// Terraform init and plan only
	// tfPlanOutput := "terraform.tfplan"
	// terraform.Init(t, tfOptions)
	// terraform.RunTerraformCommand(t, tfOptions, terraform.FormatArgs(tfOptions, "plan", "-out="+tfPlanOutput)...)

	actualClusterUsername := terraform.Output(t, tfOptions, "cluster_username")
	expectedClusterUsername := "acctestuser1"
	assert.Equal(t, expectedClusterUsername, actualClusterUsername)
	// Validate the test result
	// for _, mod := range plan.Diff.Modules {
	// fmt.Println(mod.Path)
	// }

	// website::tag::3:: Run `terraform output` to get the values of output variables
	// vmName := terraform.Output(t, terraformOptions, "vm_name")
	// resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")

	// website::tag::4:: Look up the size of the given Virtual Machine and ensure it matches the output.
	// actualVMSize := azure.GetSizeOfVirtualMachine(t, vmName, resourceGroupName, "")
	// expectedVMSize := compute.VirtualMachineSizeTypes("Standard_B1s")
	// assert.Equal(t, expectedVMSize, actualVMSize)
}

func TestStorageAccountName(t *testing.T) {
	t.Parallel()

	// Test cases for storage account name conversion logic
	testCases := map[string]string{
		"TestWebsiteName": "testwebsitenamedata001",
		"ALLCAPS":         "allcapsdata001",
		"S_p-e(c)i.a_l":   "specialdata001",
		"A1phaNum321":     "a1phanum321data001",
		"E5e-y7h_ng":      "e5ey7hngdata001",
	}

	for input, expected := range testCases {
		// Specify the test case folder and "-var" options
		tfOptions := &terraform.Options{
			TerraformDir: "../",
			Vars: map[string]interface{}{
				"website_name": input,
			},
		}

		// Terraform init and plan only
		tfPlanOutput := "terraform.tfplan"
		terraform.Init(t, tfOptions)
		terraform.RunTerraformCommand(t, tfOptions, terraform.FormatArgs(tfOptions, "plan", "-out="+tfPlanOutput)...)

		// Read and parse the plan output
		f, err := os.Open(path.Join(tfOptions.TerraformDir, tfPlanOutput))
		if err != nil {
			t.Fatal(err)
		}
		defer f.Close()
		plan, err := terraformCore.ReadPlan(f)
		if err != nil {
			t.Fatal(err)
		}

		// Validate the test result
		for _, mod := range plan.Diff.Modules {
			if len(mod.Path) == 2 && mod.Path[0] == "root" && mod.Path[1] == "staticwebpage" {
				actual := mod.Resources["azurerm_storage_account.main"].Attributes["name"].New
				if actual != expected {
					t.Fatalf("Expect %v, but found %v", expected, actual)
				}
			}
		}
	}
}
