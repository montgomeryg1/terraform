output "resource_group" {
  value = azurerm_resource_group.testing.name
}

output "container_registry" {
  value = azurerm_container_registry.testing.name
}

output "container_registry_url" {
  value = azurerm_container_registry.testing.login_server
}