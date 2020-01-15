resource "random_string" "example" {
  length = 6
  upper   = false
  lower   = false  
  number  = true
  special = false
}

resource "azurerm_resource_group" "example" {
  name     = "my-resource-group-${random_string.example.result}"
  location = "North Europe"
}

resource "azurerm_sql_server" "example" {
  name                         = "my-sql-server-${random_string.example.result}"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_sql_elasticpool" "example" {
  name                = "elastic-pool-${random_string.example.result}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  server_name         = azurerm_sql_server.example.name
  edition             = "Basic"
  dtu                 = 50
  db_dtu_min          = 0
  db_dtu_max          = 5
  pool_size           = 5000
}

resource "azurerm_sql_database" "example" {
  name                = "mysqldatabase-${random_string.example.result}"
  resource_group_name = azurerm_resource_group.example.name
  location            = "North Europe"
  server_name         = azurerm_sql_server.example.name
  elastic_pool_name   = azurerm_sql_elasticpool.example.name
  tags = {
    environment = "sandbox"
  }
}