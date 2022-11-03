output "vm_id" {
  value = azurerm_virtual_machine.vm.id
}

output "password" {
  value = random_password.password.result
  sensitive = true
}

output "public_ip" {
  value = azurerm_public_ip.public_ip.ip_address
}

output "private_ip" {
  value = azurerm_network_interface.nic.private_ip_addresses[0]
}