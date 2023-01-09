output "subnet1" {
  value = azurerm_subnet.subnet1
}

output "subnet2" {
  value = azurerm_subnet.subnet2

}

output "vnet_id" {
  value = azurerm_virtual_network.vnet.id

}

output "private IP" {
  value = azurerm_linux_virtual_machine.nginx.private_ip_address

}

output "public IP" {
  value = azurerm_linux_virtual_machine.nginx.public_ip_address

}