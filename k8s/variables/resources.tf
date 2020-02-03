variable "subnet_map" {
  description = "A map from environment to a comma-delimited list of the subnets"
  type = map
  default = {
    dev     = "subnet-c59403abe,subnet-69483bdb33c"
    qa      = "subnet-e48unjd9a1,subnet-c085uhd93a4"
    staging = "subnet-65489uuhfn9,subnet-448hjdh86b"
    prod    = "subnet-6dfjn2344f,subnet-0f4u3bjbd47"
  }
}
output "subnets" {
  value = ["${split(",", var.subnet_map[var.environment])}"]
}

variable "instance_type_map" {
  description = "A map from environment to the type of EC2 instance"
  type = map
  default = {
    small  = "t2.large"
    medium = "t2.xlarge"
    large  = "m4.large"
    xlarge = "m4.xlarge"
  }
}
output "instance_type" {
  value = "${var.instance_type_map[var.size]}"
}


variable "node_count_map" {
  description = "A map from environment to the type of EC2 instance"
  type = map
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
  type = map
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
