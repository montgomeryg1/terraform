resource "random_string" "random_dr" {
  length  = 6
  upper   = false
  lower   = false
  number  = true
  special = false
}

resource "azurerm_resource_group" "example_dr" {
  name     = "my-resource-group_dr-${random_string.random_dr.result}"
  location = "West Europe"
}

resource "azurerm_sql_server" "example_dr" {
  name                         = "my-sql-server-${random_string.random_dr.result}"
  resource_group_name          = azurerm_resource_group.example_dr.name
  location                     = azurerm_resource_group.example_dr.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_sql_elasticpool" "example_dr" {
  name                = "elastic-pool-${random_string.random_dr.result}"
  resource_group_name = azurerm_resource_group.example_dr.name
  location            = azurerm_resource_group.example_dr.location
  server_name         = azurerm_sql_server.example_dr.name
  edition             = "Basic"
  dtu                 = 50
  db_dtu_min          = 0
  db_dtu_max          = 5
  pool_size           = 5000
}

resource "azurerm_sql_database" "example_dr" {
  name                = "mysqldatabase-${random_string.random_dr.result}"
  resource_group_name = azurerm_resource_group.example_dr.name
  location            = "West Europe"
  server_name         = azurerm_sql_server.example_dr.name
  elastic_pool_name   = azurerm_sql_elasticpool.example_dr.name
  tags = {
    environment = "sandbox"
  }
}
