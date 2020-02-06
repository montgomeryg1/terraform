variable "vnet_address_space_map" {
  description = "A map from of the vnet address space"
  type        = map
  default = {
    northeurope = {
      dev     = "10.1.0.0/16"
      qa      = "10.2.0.0/16"
      staging = "10.3.0.0/16"
      prod    = "10.4.0.0/16"
    }

    westeurope = {
      dev     = "10.5.0.0/16"
      qa      = "10.6.0.0/16"
      staging = "10.7.0.0/16"
      prod    = "10.8.0.0/16"
    }

  }
}

output "vnet_address_space" {
  # value = ["${split(",", var.vnet_address_space_map[var.environment])}"]
  value = split(",", "${lookup(var.vnet_address_space_map[var.region], var.environment)}")
}

variable "subnet_map" {
  description = "A map from environment to a comma-delimited list of the subnets"
  type        = map
  default = {
    northeurope = {
      dev     = "10.1.1.0/24"
      qa      = "10.2.1.0/24"
      staging = "10.3.1.0/24"
      prod    = "10.4.1.0/24"
    }

    westeurope = {
      dev     = "10.5.1.0/24"
      qa      = "10.6.1.0/24"
      staging = "10.7.1.0/24"
      prod    = "10.8.1.0/24"
    }

  }
}

output "subnet" {
  #value = "${var.subnet_map[var.environment]}"
  value = "${lookup(var.subnet_map[var.region], var.environment)}"
}

variable "node_count_map" {
  description = "A map from environment to the number of kubernetes nodes"
  type        = map
  default = {
    northeurope = {
      small  = 1
      medium = 2
      large  = 4
      xlarge = 8
    }

    westeurope = {
      small  = 1
      medium = 2
      large  = 4
      xlarge = 8
    }
  }
}
output "node_count" {
  # value = "${var.node_count_map[var.size]}"
  value = "${lookup(var.node_count_map[var.region], var.size)}"
}


variable "vm_size_map" {
  description = "A map from environment to the size of vm"
  type        = map
  default = {
    northeurope = {
      small  = "Standard_B2s"
      medium = "Standard_D2s_v3"
      large  = "Standard_F4s_v2"
      xlarge = "Standard_DC4s"
    }
    westeurope = {
      small  = "Standard_B2s"
      medium = "Standard_D2s_v3"
      large  = "Standard_F4s_v2"
      xlarge = "Standard_DC4s"
    }
  }
}
output "vm_size" {
  # value = "${var.vm_size_map[var.size]}"
  value = "${lookup(var.vm_size_map[var.region], var.size)}"
}


variable "container_registry_sku_map" {
  description = "A map from environment to container registry sku"
  type        = map
  default = {
    northeurope = {
      small  = "Basic"
      medium = "Basic"
      large  = "Basic"
      xlarge = "Basic"
    }
    westeurope = {
      small  = "Basic"
      medium = "Basic"
      large  = "Basic"
      xlarge = "Basic"
    }
  }
}
output "container_registry_sku" {
  # value = "${var.vm_size_map[var.size]}"
  value = "${lookup(var.container_registry_sku_map[var.region], var.size)}"
}
