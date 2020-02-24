module "variables" {
  source = "github.com/montgomeryg1/terraform//variables"
  # source      = "./variables"
  environment = local.environment
  size        = local.size
  region      = var.region
}

resource "random_string" "testing" {
  length  = 6
  upper   = false
  lower   = false
  number  = true
  special = false
}

resource "azurerm_resource_group" "testing" {
  name     = "elasticpool"
  location = var.region
}

resource "azurerm_sql_server" "testing" {
  name                         = "my-sql-server-${random_string.testing.result}"
  resource_group_name          = azurerm_resource_group.testing.name
  location                     = azurerm_resource_group.testing.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
}

resource "azurerm_sql_elasticpool" "testing" {
  name                = "elastic-pool-${random_string.testing.result}"
  resource_group_name = azurerm_resource_group.testing.name
  location            = azurerm_resource_group.testing.location
  server_name         = azurerm_sql_server.testing.name
  edition             = "Basic"
  dtu                 = 50
  db_dtu_min          = 0
  db_dtu_max          = 5
  pool_size           = 5000
}

resource "azurerm_sql_database" "testing" {
  name                = "mysqldatabase-${random_string.testing.result}"
  resource_group_name = azurerm_resource_group.testing.name
  location            = "North Europe"
  server_name         = azurerm_sql_server.testing.name
  elastic_pool_name   = azurerm_sql_elasticpool.testing.name
  tags = {
    environment = local.environment
  }
}
