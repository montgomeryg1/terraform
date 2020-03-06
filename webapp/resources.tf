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
  name                = "appserviceplan"
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
    app_command_line = ""
    linux_fx_version = "DOCKER|appsvcsample/python-helloworld:latest"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL"          = "https://index.docker.io"
  }
}