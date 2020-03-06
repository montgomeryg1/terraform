package test

import (
	"context"
	"fmt"
	"net"
	"os"
	"reflect"
	"strings"
	"testing"
	"time"

	"github.com/Azure/go-autorest/autorest"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"

	"github.com/Azure/azure-sdk-for-go/profiles/latest/compute/mgmt/compute"
	"github.com/Azure/azure-sdk-for-go/profiles/latest/containerservice/mgmt/containerservice"
	"github.com/Azure/azure-sdk-for-go/profiles/latest/network/mgmt/network"
	"github.com/Azure/go-autorest/autorest/azure/auth"
	"github.com/gruntwork-io/terratest/modules/retry"
	// "github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2018-06-01/compute"
	// "github.com/gruntwork-io/terratest/modules/azure"
	// "github.com/stretchr/testify/assert"
	// "github.com/stretchr/testify/require"
)

var authorizer autorest.Authorizer

func init() {

	// // create an authorizer from env vars or Azure Managed Service Idenity
	_, ok := os.LookupEnv("AZURE_CLIENT_SECRET")
	if ok {
		authorizer, _ = auth.NewAuthorizerFromEnvironment()
	} else {
		authorizer, _ = auth.NewAuthorizerFromCLI()
	}
}

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
	var err error

	dir := "../k8s"
	tfOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: dir,
	}
	terraform.InitAndApply(t, tfOptions)
	subscriptionID := "60020c84-fca0-4d3b-ab6a-502ba1028851"

	expectedResourceGroupName := terraform.Output(t, tfOptions, "resource_group_name")
	expectedClusterName := "cluster"
	expectedAgentCount := 1

	k8sClient := containerservice.NewManagedClustersClient(subscriptionID)

	if err == nil {
		k8sClient.Authorizer = authorizer
	}
	cluster, err := k8sClient.Get(context.Background(), expectedResourceGroupName, expectedClusterName)
	require.NoError(t, err)

	// Look up the cluster node count
	actualCount := *(*cluster.ManagedClusterProperties.AgentPoolProfiles)[0].Count

	// Test that the Node count matches the Terraform specification
	assert.Equal(t, int32(expectedAgentCount), actualCount)
}

func TestUbuntuVm(t *testing.T) {
	t.Parallel()

	var err error

	// website::tag::1:: Configure Terraform setting up a path to Terraform code.
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: ".",
		NoColor:      true,
	}

	// Run `terraform apply`. Fail the test if there are any errors.
	terraform.InitAndApply(t, terraformOptions)

	// subscriptionID := os.Getenv("TF_VAR_subscription_id")
	subscriptionID := "60020c84-fca0-4d3b-ab6a-502ba1028851"

	// // Run `terraform output` to get the values of output variables
	vmName := terraform.Output(t, terraformOptions, "vm_name")
	resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
	expectedVMSize := compute.VirtualMachineSizeTypes("Standard_B1s")
	description := fmt.Sprintf("Find virtual machine %s", vmName)

	// // Look up the size of the given Virtual Machine and ensure it matches the output.
	maxRetries := 10
	timeBetweenRetries := 5 * time.Second
	retry.DoWithRetry(t, description, maxRetries, timeBetweenRetries, func() (string, error) {
		actualVMSize, err := azure.GetSizeOfVirtualMachineE(t, vmName, resourceGroupName, subscriptionID)
		assert.Equal(t, expectedVMSize, actualVMSize)
		return "", err
	})

	publicIPName := terraform.Output(t, terraformOptions, "public_ip_name")
	publicIPClient := network.NewPublicIPAddressesClient(subscriptionID)
	if err == nil {
		publicIPClient.Authorizer = authorizer
	}
	ipAddress, ipErr := publicIPClient.Get(context.Background(), resourceGroupName, publicIPName, "")
	if ipErr != nil {
		t.Error("IP address error:", ipErr)
	}
	ipAddr := *ipAddress.PublicIPAddressPropertiesFormat.IPAddress
	fmt.Println("Public IP Address = ", ipAddr)

	// Test port 22 is open on VM
	timeout := 5 * time.Second
	port := "22"
	retry.DoWithRetry(t, "Test open ssh port", maxRetries, timeBetweenRetries, func() (string, error) {
		conn, err := net.DialTimeout("tcp", ipAddr+":"+port, timeout)
		if err != nil {
			t.Error("Connecting error:", err)
		}
		if conn != nil {
			fmt.Println("SSH connection successful")
			defer conn.Close()
		}
		return "", err
	})

	// at the end of the test, run `terraform destroy` to clean up any resources that were created
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
