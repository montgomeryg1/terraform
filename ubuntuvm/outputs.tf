output "vm_name" {
  value = azurerm_virtual_machine.testing.name
}

output "vm_size" {
  value = azurerm_virtual_machine.testing.vm_size
}

output "resource_group_name" {
  value = azurerm_resource_group.testing.name
}

data "azurerm_public_ip" "ubuntuvm" {
  name                = azurerm_public_ip.ubuntuvm.name
  resource_group_name = azurerm_resource_group.testing.name
}

output "public_ip_address" {
  value = data.azurerm_public_ip.ubuntuvm.ip_address
}

output "public_ip_name" {
  value = azurerm_public_ip.ubuntuvm.name
}
