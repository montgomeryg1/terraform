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
