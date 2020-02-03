variable "subnet_map" {
  description = "A map from environment to a comma-delimited list of the subnets"
  type        = map
  default = {
    dev     = "10.1.1.0/24"
    qa      = "10.1.2.0/24"
    staging = "10.1.3.0/24"
    prod    = "10.1.4.0/24"
  }
}

output "subnet" {
  # value = [“${split(“,”, var.subnet_map[var.environment])}”]
  value = "${var.subnet_map[var.environment]}"
}

variable "node_count_map" {
  description = "A map from environment to the type of EC2 instance"
  type        = map
  default = {
    small  = 1
    medium = 2
    large  = 4
    xlarge = 8
  }
}
output "node_count" {
  value = "${var.node_count_map[var.size]}"
}


variable "vm_size_map" {
  description = "A map from environment to the type of EC2 instance"
  type        = map
  default = {
    small  = "Standard_B2s"
    medium = "Standard_D2s_v3"
    large  = "Standard_F4s_v2"
    xlarge = "Standard_DC4s"
  }
}
output "vm_size" {
  value = "${var.vm_size_map[var.size]}"
}
