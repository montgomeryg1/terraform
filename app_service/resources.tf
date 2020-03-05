module "variables" {
  # source = "github.com/montgomeryg1/terraform//variables"
  source      = "../variables"
  environment = local.environment
  size        = local.size
  region      = var.region
}

resource "azurerm_resource_group" "testing" {
  name     = "testing-resources"
  location = var.region
}

resource "azurerm_app_service_plan" "testing" {
  name                = "api-appserviceplan-free"
  location            = azurerm_resource_group.testing.location
  resource_group_name = azurerm_resource_group.testing.name

  sku {
    tier = module.variables.app_service_plan_tier
    size = module.variables.app_service_plan_size
  }
}

resource "azurerm_app_service" "testing" {
  name                = "testing-app-service"
  location            = azurerm_resource_group.testing.location
  resource_group_name = azurerm_resource_group.testing.name
  app_service_plan_id = azurerm_app_service_plan.testing.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "SOME_KEY" = "some-value"
  }

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=some-server.mydomain.com;Integrated Security=SSPI"
  }
}