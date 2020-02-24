resource "azurerm_resource_group" "testing" {
  name     = "api-rg-pro"
  location = "West Europe"
}

resource "azurerm_app_service_plan" "testing" {
  name                = "api-appserviceplan-free"
  location            = azurerm_resource_group.testing.location
  resource_group_name = azurerm_resource_group.testing.name

  sku {
    tier = "Free"
    size = "F1"
  }
}
