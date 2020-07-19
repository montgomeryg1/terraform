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

resource "azurerm_resource_group" "owaspzap" {
  name     = "owaspzap-resources"
  location = "North Europe"
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY VIRTUAL NETWORK RESOURCES
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_virtual_network" "vnet" {
  name                = "network"
  location            = azurerm_resource_group.owaspzap.location
  resource_group_name = azurerm_resource_group.owaspzap.name
  address_space       = module.variables.vnet_address_space
}

resource "azurerm_subnet" "internal" {
  for_each             = module.variables.subnets
  name                 = each.key
  address_prefix       = each.value
  resource_group_name  = azurerm_resource_group.owaspzap.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A NETWORK SECURITY GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_network_security_group" "nsg1" {
  name                = "networkSecurityGroup1"
  location            = azurerm_resource_group.owaspzap.location
  resource_group_name = azurerm_resource_group.owaspzap.name
}

resource "azurerm_network_security_rule" "nsr1" {
  name                        = "allow-rdp"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.owaspzap.name
  network_security_group_name = azurerm_network_security_group.nsg1.name
}

resource "azurerm_network_security_rule" "nsr2" {
  name                        = "allow-http"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.owaspzap.name
  network_security_group_name = azurerm_network_security_group.nsg1.name
}


resource "azurerm_network_security_rule" "nsr3" {
  name                        = "allow-https"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.owaspzap.name
  network_security_group_name = azurerm_network_security_group.nsg1.name
}
# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A VIRTUAL MACHINE NETWORK CARD
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_public_ip" "pip" {
  name                = "pip"
  location            = azurerm_resource_group.owaspzap.location
  resource_group_name = azurerm_resource_group.owaspzap.name
  allocation_method   = "Dynamic"

}

resource "azurerm_network_interface" "nic" {
  name                = "nic"
  location            = azurerm_resource_group.owaspzap.location
  resource_group_name = azurerm_resource_group.owaspzap.name

  ip_configuration {
    name                          = "ipconfiguration1"
    subnet_id                     = azurerm_subnet.internal["subnet-1"].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm.id
  }
}

resource "azurerm_subnet_network_security_group_association" "testing" {
  subnet_id                 = azurerm_subnet.internal["subnet-1"].id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}

# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A VIRTUAL MACHINE
# ---------------------------------------------------------------------------------------------------------------------

resource "azurerm_virtual_machine" "vm" {
  name                             = "owaspzap-vm"
  location                         = azurerm_resource_group.owaspzap.location
  resource_group_name              = azurerm_resource_group.owaspzap.name
  network_interface_ids            = [azurerm_network_interface.nic.id]
  vm_size                          = module.variables.vm_size
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter-smalldisk"
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

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
    timezone                  = "GMT Standard Time"
  }

}
