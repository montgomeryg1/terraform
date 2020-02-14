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
    environment = "sandbox"
  }
}

resource "azurerm_container_registry" "sandbox" {
  name                = "myContainerRegistry${random_string.sandbox.result}"
  resource_group_name = azurerm_resource_group.sandbox.name
  location            = azurerm_resource_group.sandbox.location
  sku                 = module.variables.container_registry_sku
  admin_enabled       = false

  tags = {
    environment = "sandbox"
  }
}

resource "azurerm_container_group" "sandbox" {
  name                = "${random_string.sandbox.result}-continst"
  location            = "${azurerm_resource_group.sandbox.location}"
  resource_group_name = "${azurerm_resource_group.sandbox.name}"
  ip_address_type     = "public"
  os_type             = "linux"

  container {
    name   = "hw"
    image  = "microsoft/aci-helloworld:latest"
    cpu    = "0.5"
    memory = "1.5"
    port   = "80"
  }

  container {
    name   = "sidecar"
    image  = "microsoft/aci-tutorial-sidecar"
    cpu    = "0.5"
    memory = "1.5"
  }

  tags = {
    environment = "sandbox"
  }
}
