module "variables" {
  source = "github.com/montgomeryg1/terraform//variables"
  # source      = "./variables"
  environment = local.environment
  size        = local.size
  region      = var.region
}


resource "azurerm_resource_group" "sandbox" {
  name     = "myResourceGroup"
  location = var.region
}

resource "azurerm_network_security_group" "sandbox" {
  name                = "${local.environment}-networkSecurityGroup1"
  location            = azurerm_resource_group.sandbox.location
  resource_group_name = azurerm_resource_group.sandbox.name
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
