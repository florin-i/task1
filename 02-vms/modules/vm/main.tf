resource "random_password" "password" {
  override_special = "{}[]().-_"
  length = 14
}

resource "azurerm_virtual_machine" "vm" {
  name                             = var.vm.name
  location                         = var.location
  resource_group_name              = var.rgName
  network_interface_ids            = [azurerm_network_interface.nic.id]
  vm_size                          = var.vm.size
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.vm.image.publisher
    offer     = var.vm.image.offer
    sku       = var.vm.image.sku
    version   = var.vm.image.version
  }
  storage_os_disk {
    name              = "${var.vm.name}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.vm.name
    admin_username = var.adminUserName
    admin_password = random_password.password.result
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

}