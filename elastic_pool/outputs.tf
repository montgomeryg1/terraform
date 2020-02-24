output "resource_group" {
  value = azurerm_resource_group.testing.name
}

output "sql_server_main_name" {
  value = azurerm_sql_server.testing.name
}

output "sql_server_dr_name" {
  value = azurerm_sql_server.testing_dr.name
}