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
}

provider "random" {
  version = "~> 2.2"
}