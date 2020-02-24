# terraform  {
#  backend "azurerm"{
#   resource_group_name = "MyResourceGroup"
#   storage_account_name = "mystorageaccount07012020"
#   container_name = "mystoragecontainer"
#   key = "elastic_pool.tfstate"
#  }
# }

provider "azurerm" {
  version = "~> 1.5"

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

provider "random" {
  version = "~> 2.2"
}