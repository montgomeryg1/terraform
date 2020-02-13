module "variables" {
  source = "github.com/montgomeryg1/terraform//variables"
  # source      = "./variables"
  environment = local.environment
  size        = local.size
  region      = var.region
}

resource "random_string" "sandbox" {
  length  = 6
  upper   = false
  lower   = false
  number  = true
  special = false
}

resource "azurerm_resource_group" "sandbox" {
  name     = "my-resource-group-${random_string.sandbox.result}"
  location = "North Europe"
}

resource "azurerm_sql_server" "sandbox" {
  name                         = "my-sql-server-${random_string.sandbox.result}"
  resource_group_name          = azurerm_resource_group.sandbox.name
  location                     = azurerm_resource_group.sandbox.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_sql_elasticpool" "sandbox" {
  name                = "elastic-pool-${random_string.sandbox.result}"
  resource_group_name = azurerm_resource_group.sandbox.name
  location            = azurerm_resource_group.sandbox.location
  server_name         = azurerm_sql_server.sandbox.name
  edition             = "Basic"
  dtu                 = 50
  db_dtu_min          = 0
  db_dtu_max          = 5
  pool_size           = 5000
}

resource "azurerm_sql_database" "sandbox" {
  name                = "mysqldatabase-${random_string.sandbox.result}"
  resource_group_name = azurerm_resource_group.sandbox.name
  location            = "North Europe"
  server_name         = azurerm_sql_server.sandbox.name
  elastic_pool_name   = azurerm_sql_elasticpool.sandbox.name
  tags = {
    environment = "sandbox"
  }
}
