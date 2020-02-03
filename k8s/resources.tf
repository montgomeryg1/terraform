module "variables" {
  # source      = "github.com/montgomeryg1/terraform//containers/variables?ref=montgomerg1-patch-2"
  source      = "./variables"
  environment = "${local.environment}"
  size        = "${local.size}"
}


resource "azurerm_resource_group" "example" {
  name     = "${var.prefix}-resources"
  location = local.location
}


resource "azurerm_virtual_network" "example" {
  name                = "${local.prefix}-network"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  address_prefix       = "10.1.0.0/24"
  virtual_network_name = azurerm_virtual_network.example.name
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = "${local.prefix}-cluster"
  location            = azurerm_resource_group.example.location
  dns_prefix          = "${local.prefix}-cluster"
  resource_group_name = azurerm_resource_group.example.name

  linux_profile {
    admin_username = "acctestuser1"

    ssh_key {
      // key_data = file(var.public_ssh_key_path)
      key_data = "${var.public_ssh_key_path}"
    }
  }

  default_node_pool {
    name            = "agentpool"
    node_count      = module.variables.node_count
    vm_size         = module.variables.vm_size
    os_disk_size_gb = 30

    # Required for advanced networking
    vnet_subnet_id = azurerm_subnet.example.id
  }

  service_principal {
    client_id     = var.kubernetes_client_id
    client_secret = var.kubernetes_client_secret
  }

  network_profile {
    network_plugin = "azure"
  }
}
