resource "random_password" "password" {
  override_special = "{}[]().-_"
  min_lower = 2
  min_upper = 2
  min_numeric = 2
  min_special = 2
  length = 14
}

resource "azurerm_virtual_machine" "vm" {
  name                             = var.vmName
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
    name              = "${var.vmName}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.vmName
    admin_username = var.adminUserName
    admin_password = random_password.password.result
  }
  os_profile_linux_config {
    disable_password_authentication = false
    ssh_keys {
      path = "/home/${var.adminUserName}/.ssh/authorized_keys"
      key_data = var.sshKey
    }
  }

}