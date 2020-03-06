package test

import (
	"os"
	"testing"

	"github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2018-06-01/compute"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestUbuntuVm(t *testing.T) {
	t.Parallel()

	os.Setenv("AZURE_CLIENT_ID", "__applicationID__")
	os.Setenv("AZURE_CLIENT_SECRET", "__applicationSecret__")
	os.Setenv("AZURE_SUBSCRIPTION_ID", "__subscriptionID__")
	os.Setenv("AZURE_TENANT_ID", "__tenantID__")

	// Configure Terraform setting up a path to Terraform code.
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: ".",
		NoColor:      true,
	}

	// Run `terraform apply`. Fail the test if there are any errors.
	// terraform.InitAndApply(t, terraformOptions)

	subscriptionID := os.Getenv("AZURE_SUBSCRIPTION_ID")

	// Run `terraform output` to get the values of output variables
	vmName := terraform.Output(t, terraformOptions, "vm_name")
	resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
	expectedVMSize := compute.VirtualMachineSizeTypes("Standard_B1s")
	actualVMSize := azure.GetSizeOfVirtualMachine(t, vmName, resourceGroupName, subscriptionID)
	assert.Equal(t, expectedVMSize, actualVMSize)

	// description := fmt.Sprintf("Find virtual machine %s", vmName)

	// // Look up the size of the given Virtual Machine and ensure it matches the output.
	// maxRetries := 10
	// timeBetweenRetries := 5 * time.Second
	// retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
	// 	actualVMSize, err := azure.GetSizeOfVirtualMachineE(t, vmName, resourceGroupName, subscriptionID)
	// 	assert.Equal(t, expectedVMSize, actualVMSize)
	// 	return "", err
	// })

	// publicIPName := terraform.Output(t, terraformOptions, "public_ip_name")
	// publicIPClient := network.NewPublicIPAddressesClient(subscriptionID)
	// if err == nil {
	// 	publicIPClient.Authorizer = authorizer
	// }
	// ipAddress, ipErr := publicIPClient.Get(context.Background(), resourceGroupName, publicIPName, "")
	// if ipErr != nil {
	// 	t.Error("IP address error:", ipErr)
	// }
	// ipAddr := *ipAddress.PublicIPAddressPropertiesFormat.IPAddress
	// fmt.Println("Public IP Address = ", ipAddr)

	// // Test port 22 is open on VM
	// timeout := 5 * time.Second
	// port := "22"
	// retry.DoWithRetry(t, "Test open ssh port", maxRetries, timeBetweenRetries, func() (string, error) {
	// 	conn, err := net.DialTimeout("tcp", ipAddr+":"+port, timeout)
	// 	if err != nil {
	// 		t.Error("Connecting error:", err)
	// 	}
	// 	if conn != nil {
	// 		fmt.Println("SSH connection successful")
	// 		defer conn.Close()
	// 	}
	// 	return "", err
	// })

	// at the end of the test, run `terraform destroy` to clean up any resources that were created
	// defer terraform.Destroy(t, terraformOptions)
}

func TestSomething(t *testing.T) {

	var a string = "Hello"
	var b string = "Hello"

	assert.Equal(t, a, b, "The two words should be the same.")

}
