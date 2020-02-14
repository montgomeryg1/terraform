module "variables" {
  source = "github.com/montgomeryg1/terraform//variables"
  # source      = "./variables"
  environment = local.environment
  size        = local.size
  region      = var.region
}

resource "random_string" "sandbox" {
  length  = 4
  upper   = false
  lower   = false
  number  = true
  special = false
}

resource "azurerm_resource_group" "sandbox" {
  name     = "containers"
  location = var.region

  tags = {
    environment = sandbox
  }
}

resource "azurerm_container_registry" "sandbox" {
  name                = "myContainerRegistry${random_string.sandbox.result}"
  resource_group_name = azurerm_resource_group.sandbox.name
  location            = azurerm_resource_group.sandbox.location
  sku                 = module.variables.container_registry_sku
  admin_enabled       = false

  tags = {
    environment = sandbox
  }
}
