output "sql_server_main_name" {
  value = azurerm_sql_server.sandbox.name
}

output "sql_server_dr_name" {
  value = azurerm_sql_server.sandbox_dr.name
}