package test

import (
	"context"
	"fmt"
	"os"
	"reflect"
	"strings"
	"testing"

	"github.com/Azure/azure-sdk-for-go/profiles/latest/network/mgmt/network"
	"github.com/Azure/go-autorest/autorest/azure/auth"
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
	terraform.InitAndPlan(t, tfOptions)
}

func TestUbuntuVm(t *testing.T) {
	t.Parallel()

	// website::tag::1:: Configure Terraform setting up a path to Terraform code.
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../ubuntu_vm",
	}

	// Run `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// // Run `terraform output` to get the values of output variables
	// vmName := terraform.Output(t, terraformOptions, "vm_name")
	resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
	// expectedVMSize := compute.VirtualMachineSizeTypes("Standard_B1s")
	// description := fmt.Sprintf("Find virtual machine %s", vmName)

	// // Look up the size of the given Virtual Machine and ensure it matches the output.
	// maxRetries := 30
	// timeBetweenRetries := 5 * time.Second
	// retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
	// 	actualVMSize, err := azure.GetSizeOfVirtualMachineE(t, vmName, resourceGroupName, "")
	// 	assert.Equal(t, expectedVMSize, actualVMSize)
	// 	return "", err
	// })

	subscriptionID := os.Getenv("AZURE_SUBSCRIPTION_ID")
	fmt.Println("The subscription ID is", subscriptionID)

	publicIPName := terraform.Output(t, terraformOptions, "public_ip_name")
	publicIPClient := network.NewPublicIPAddressesClient(subscriptionID)

	// // create an authorizer from env vars or Azure Managed Service Idenity
	authorizer, err := auth.NewAuthorizerFromEnvironment()
	if err == nil {
		publicIPClient.Authorizer = authorizer
	}
	ipAddress, err := publicIPClient.Get(context.Background(), resourceGroupName, publicIPName, "")
	if err != nil {
		t.Error("IP address error:", err)
	}
	ipAddr := *ipAddress.PublicIPAddressPropertiesFormat.IPAddress
	fmt.Println("Public IP Address = ", ipAddr)

	// timeout := 5 * time.Second
	// port := "22"
	// conn, err := net.DialTimeout("tcp", ipAddr+":"+port, timeout)
	// if err != nil {
	// 	t.Error("Connecting error:", err)
	// }

	// if conn != nil {
	// 	defer conn.Close()
	// }

	// t the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)
}

func examiner(t reflect.Type, depth int) {
	fmt.Println(strings.Repeat("\t", depth), "Type is", t.Name(), "and kind is", t.Kind())
	switch t.Kind() {
	case reflect.Array, reflect.Chan, reflect.Map, reflect.Ptr, reflect.Slice:
		fmt.Println(strings.Repeat("\t", depth+1), "Contained type:")
		examiner(t.Elem(), depth+1)
	case reflect.Struct:
		for i := 0; i < t.NumField(); i++ {
			f := t.Field(i)
			fmt.Println(strings.Repeat("\t", depth+1), "Field", i+1, "name is", f.Name, "type is", f.Type.Name(), "and kind is", f.Type.Kind())
			if f.Tag != "" {
				fmt.Println(strings.Repeat("\t", depth+2), "Tag is", f.Tag)
				fmt.Println(strings.Repeat("\t", depth+2), "tag1 is", f.Tag.Get("tag1"), "tag2 is", f.Tag.Get("tag2"))
			}
		}
	}
}
