module "variables" {
  source = "github.com/montgomeryg1/terraform//variables"
  # source      = "./variables"
  environment = local.environment
  size        = local.size
  region      = var.region
}


resource "azurerm_resource_group" "sandbox" {
  name     = "${local.environment}-resources"
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
  address_space       = ["10.0.0.0/16"]
  // dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = {
    environment = "sandbox"
  }
}

resource "azurerm_subnet" "sandbox" {
  for_each             = toset(var.subnets)
  name                 = each.key
  resource_group_name  = azurerm_resource_group.sandbox.name
  virtual_network_name = azurerm_virtual_network.sandbox.name
  address_prefix       = each.value
}