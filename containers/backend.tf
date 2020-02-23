terraform {
    backend "msdn" {
        resource_group_name = artifacts
        storage_account_name = artifactsdevelopment
        container_name = tf-statefiles
        key = tfstate 
        access_key = var.access_key
    }
}