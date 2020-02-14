module "variables" {
  source = "github.com/montgomeryg1/terraform//variables"
  # source      = "./variables"
  environment = local.environment
  size        = local.size
  region      = var.region
}


resource "azurerm_resource_group" "sandbox" {
  name     = "vnet"
  location = var.region
}

resource "azurerm_network_security_group" "nsg1" {
  name                = "networkSecurityGroup1"
  location            = azurerm_resource_group.sandbox.location
  resource_group_name = azurerm_resource_group.sandbox.name
}

resource "azurerm_network_security_rule" "nsr1" {
  name                        = "allow-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.sandbox.name
  network_security_group_name = azurerm_network_security_group.nsg1.name
}

resource "azurerm_network_security_rule" "nsr2" {
  name                        = "allow-http/s"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80,443"
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.sandbox.name
  network_security_group_name = azurerm_network_security_group.nsg1.name
}

resource "azurerm_virtual_network" "sandbox" {
  name                = "virtualNetwork1"
  location            = azurerm_resource_group.sandbox.location
  resource_group_name = azurerm_resource_group.sandbox.name
  address_space       = module.variables.vnet_address_space
  // dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = {
    environment = "sandbox"
  }
}

resource "azurerm_subnet" "sandbox" {
  // for_each             = var.subnets
  for_each             = module.variables.subnets
  name                 = each.key
  address_prefix       = each.value
  resource_group_name  = azurerm_resource_group.sandbox.name
  virtual_network_name = azurerm_virtual_network.sandbox.name
}


resource "azurerm_subnet_network_security_group_association" "sandbox" {
  for_each                  = module.variables.subnets
  subnet_id                 = azurerm_subnet.sandbox[each.key].id
  network_security_group_id = azurerm_network_security_group.sandbox.id
}


