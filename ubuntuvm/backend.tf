terraform {
    backend "azurerm" {
        resource_group_name = "__storagerg__"
        storage_account_name = "__storageacct__"
        container_name = "tf-statefiles"
        key = "__terraform.name__"
        access_key = "__access_key__"
    }
}