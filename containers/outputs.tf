output "resource_group" {
  value = azurerm_resource_group.example.name
}

output "container_registry" {
  value = azurerm_container_registry.example.name
}

output "container_registry_url" {
  value = azurerm_container_registry.example.login_server
}