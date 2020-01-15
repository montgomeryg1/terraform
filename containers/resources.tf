resource "random_string" "example" {
  length  = 6
  upper   = false
  lower   = false
  number  = true
  special = false
}

resource "azurerm_resource_group" "example" {
  name     = "myResourceGroup"
  location = "North Europe"

  tags = {
    environment = "sandbox"
  }
}

resource "azurerm_container_registry" "example" {
  name                = "myContainerRegistry-${random_string.example.result}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Basic"
  admin_enabled       = false

  tags = {
    environment = "sandbox"
  }
}