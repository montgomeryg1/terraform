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



variable "subnets_map" {
  description = "A map from environment to a comma-delimited list of the subnets"
  type        = map
  default = {
    northeurope = {
      dev     = { subnet-1 = "10.1.1.0/24", subnet-2 = "10.1.2.0/24", subnet-3 = "10.1.3.0/24" }
      qa      = { subnet-1 = "10.2.1.0/24", subnet-2 = "10.2.2.0/24", subnet-3 = "10.2.3.0/24" }
      staging = { subnet-1 = "10.3.1.0/24", subnet-2 = "10.3.2.0/24", subnet-3 = "10.3.3.0/24" }
      prod    = { subnet-1 = "10.4.1.0/24", subnet-2 = "10.4.2.0/24", subnet-3 = "10.4.3.0/24" }
    }

    westeurope = {
      dev     = { subnet-1 = "10.5.1.0/24", subnet-2 = "10.5.2.0/24", subnet-3 = "10.5.3.0/24" }
      qa      = { subnet-1 = "10.6.1.0/24", subnet-2 = "10.6.2.0/24", subnet-3 = "10.6.3.0/24" }
      staging = { subnet-1 = "10.7.1.0/24", subnet-2 = "10.7.2.0/24", subnet-3 = "10.7.3.0/24" }
      prod    = { subnet-1 = "10.8.1.0/24", subnet-2 = "10.8.2.0/24", subnet-3 = "10.8.3.0/24" }
    }

  }
}

output "subnets" {
  #value = "${var.subnet_map[var.environment]}"
  value = "${lookup(var.subnets_map[var.region], var.environment)}"
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
      small  = "Standard_B1s"
      medium = "Standard_D2s_v3"
      large  = "Standard_F4s_v2"
      xlarge = "Standard_DC4s"
    }
    westeurope = {
      small  = "Standard_B1s"
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


variable "app_service_plan_tier_map" {
  description = "A map for app service plan sku tier"
  type        = map
  default = {
    northeurope = {
      small  = "Free"
      medium = "Standard"
      large  = "Standard"
      xlarge = "Premium"
    }
    westeurope = {
      small  = "Free"
      medium = "Standard"
      large  = "Standard"
      xlarge = "Premium"
    }
  }
}

output "app_service_plan_tier" {
  value = "${lookup(var.app_service_plan_tier_map[var.region], var.size)}"
}


variable "app_service_plan_size_map" {
  description = "A map for app service plan sku size"
  type        = map
  default = {
    northeurope = {
      small  = "F1"
      medium = "S1"
      large  = "S2"
      xlarge = "P1"
    }
    westeurope = {
      small  = "F1"
      medium = "S1"
      large  = "S2"
      xlarge = "P1"
    }
  }
}

output "app_service_plan_size" {
  value = "${lookup(var.app_service_plan_size_map[var.region], var.size)}"
}