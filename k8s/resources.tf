module "variables" {
  source = "github.com/montgomeryg1/terraform//variables"
  # source      = "./variables"
  environment = local.environment
  size        = local.size
  region      = var.region
}


resource "azurerm_resource_group" "testing" {
  name     = "k8s"
  location = var.region
}

resource "azurerm_virtual_network" "testing" {
  name                = "network"
  location            = azurerm_resource_group.testing.location
  resource_group_name = azurerm_resource_group.testing.name
  address_space       = module.variables.vnet_address_space
}

resource "azurerm_subnet" "testing" {
  for_each             = module.variables.subnets
  name                 = each.key
  address_prefix       = each.value
  resource_group_name  = azurerm_resource_group.testing.name
  virtual_network_name = azurerm_virtual_network.testing.name
}

resource "azurerm_kubernetes_cluster" "testing" {
  name                = "cluster"
  location            = azurerm_resource_group.testing.location
  dns_prefix          = "cluster"
  resource_group_name = azurerm_resource_group.testing.name

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
    vnet_subnet_id = azurerm_subnet.testing["subnet-1"].id
  }

  addon_profile {
    kube_dashboard {
      enabled = true
    }
  }

  service_principal {
    client_id     = var.kubernetes_client_id
    client_secret = var.kubernetes_client_secret
  }

  network_profile {
    network_plugin = "azure"
  }
}


resource "local_file" "kubeconfig" {
  content  = azurerm_kubernetes_cluster.testing.kube_config_raw
  filename = "kubeconfig"

  depends_on = [
    azurerm_kubernetes_cluster.testing
  ]
}
