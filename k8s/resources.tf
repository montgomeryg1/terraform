module "variables" {
  source = "github.com/montgomeryg1/terraform//variables"
  # source      = "./variables"
  environment = local.environment
  size        = local.size
  region      = var.region
}


resource "azurerm_resource_group" "sandbox" {
  name     = "${local.environment}-resources"
  location = var.region
}

resource "azurerm_virtual_network" "sandbox" {
  name                = "${local.environment}-network"
  location            = azurerm_resource_group.sandbox.location
  resource_group_name = azurerm_resource_group.sandbox.name
  address_space       = module.variables.vnet_address_space
}

resource "azurerm_subnet" "sandbox" {
  for_each             = module.variables.subnets
  name                 = each.key
  address_prefix       = each.value
  resource_group_name  = azurerm_resource_group.sandbox.name
  virtual_network_name = azurerm_virtual_network.sandbox.name
}

resource "azurerm_kubernetes_cluster" "sandbox" {
  name                = "${local.environment}-cluster"
  location            = azurerm_resource_group.sandbox.location
  dns_prefix          = "${local.environment}-cluster"
  resource_group_name = azurerm_resource_group.sandbox.name

  linux_profile {
    admin_username = "acctestuser1"

    ssh_key {
      // key_data = file(var.public_ssh_key_path)
      key_data = var.public_ssh_key_path
    }
  }

  default_node_pool {
    name            = "agentpool"
    node_count      = module.variables.node_count
    vm_size         = module.variables.vm_size
    os_disk_size_gb = 30

    # Required for advanced networking
    vnet_subnet_id = azurerm_subnet.sandbox["subnet-1"].id
  }

  service_principal {
    client_id     = var.kubernetes_client_id
    client_secret = var.kubernetes_client_secret
  }

  network_profile {
    network_plugin = "azure"
  }
}
