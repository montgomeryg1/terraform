output "resource_group" {
  value = azurerm_resource_group.sandbox.name
}

output "container_registry" {
  value = azurerm_container_registry.sandbox.name
}

output "container_registry_url" {
  value = azurerm_container_registry.sandbox.login_server
}