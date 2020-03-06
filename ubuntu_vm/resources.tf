
module "variables" {
  # source = "github.com/montgomeryg1/terraform//variables"
  source      = "../variables"
  environment = local.environment
  size        = local.size
  region      = var.region
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A RESOURCE GROUP
# See test/terraform_azure_example_test.go for how to write automated tests for this code.
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_resource_group" "testing" {
  name     = "testing-resources"
  location = "North Europe"
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY VIRTUAL NETWORK RESOURCES
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_virtual_network" "vnet" {
  name                = "network"
  location            = azurerm_resource_group.testing.location
  resource_group_name = azurerm_resource_group.testing.name
  address_space       = module.variables.vnet_address_space
}

resource "azurerm_subnet" "internal" {
  for_each             = module.variables.subnets
  name                 = each.key
  address_prefix       = each.value
  resource_group_name  = azurerm_resource_group.testing.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_public_ip" "ubuntuvm" {
  name                = "${var.prefix}-pip"
  location            = azurerm_resource_group.testing.location
  resource_group_name = azurerm_resource_group.testing.name
  allocation_method   = "Dynamic"

}

resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.testing.location
  resource_group_name = azurerm_resource_group.testing.name

  ip_configuration {
    name                          = "ipconfiguration1"
    subnet_id                     = azurerm_subnet.internal["subnet-1"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ubuntuvm.id
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A VIRTUAL MACHINE RUNNING UBUNTU
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_virtual_machine" "testing" {
  name                             = "${var.prefix}-vm"
  location                         = azurerm_resource_group.testing.location
  resource_group_name              = azurerm_resource_group.testing.name
  network_interface_ids            = [azurerm_network_interface.nic.id]
  vm_size                          = module.variables.vm_size
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.hostname
    admin_username = var.username
    admin_password = var.password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
