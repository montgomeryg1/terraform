output "vm_name" {
  value = azurerm_virtual_machine.testing.name
}

output "resource_group_name" {
  value = azurerm_resource_group.testing.name
}

data "azurerm_public_ip" "testing" {
  name                = "${var.prefix}-pip"
  resource_group_name = azurerm_resource_group.testing.name
}

output "public_ip_address" {
  value = data.azurerm_public_ip.testing.ip_address
}