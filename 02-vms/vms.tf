
resource "azurerm_network_interface" "nic" {
  count               = var.numberOfVms
  location            = var.location
  name                = "vm-nic-${count.index}"
  resource_group_name = var.rgName
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sub.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip[count.index].id
  }

}

resource "azurerm_public_ip" "public_ip" {
  count               = var.numberOfVms
  name                = "pubIP-${count.index}"
  resource_group_name = var.rgName
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "random_password" "password" {
  count  = var.numberOfVms
  length = 14
}

resource "azurerm_virtual_machine" "vm" {
  count                            = var.numberOfVms
  name                             = "test-vm${count.index}"
  location                         = var.location
  resource_group_name              = azurerm_resource_group.rg.name
  network_interface_ids            = [azurerm_network_interface.nic[count.index].id]
  vm_size                          = "Standard_B1s"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk-test-vm${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "test-vm"
    admin_username = "adminuser"
    admin_password = random_password.password[count.index].result
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

}


data "azurerm_public_ip" "pubIP" {
  count               = var.numberOfVms
  name                = azurerm_public_ip.public_ip[count.index].name
  resource_group_name = azurerm_resource_group.rg.name
}

resource "null_resource" "ping" {
  count = var.numberOfVms
  triggers = {
    cluster_instance_ids = join(",", azurerm_virtual_machine.vm.*.id)
  }

  connection {
    type     = "ssh"
    user     = "adminuser"
    password = random_password.password[count.index].result
    host     = data.azurerm_public_ip.pubIP[count.index].ip_address
  }
  provisioner "remote-exec" {
    inline = [
      "export source=${azurerm_network_interface.nic[count.index].private_ip_addresses[0]}",
      "export destination=${azurerm_network_interface.nic[count.index < var.numberOfVms - 1 ? count.index + 1 : 0].private_ip_addresses[0]}",
      "echo Start ping from $source to $destination",
      "ping -c 1 $destination; if [ $? -eq 0 ]; then echo \"$source -> $destination = pass\"; else echo \"$source -> $destination = fail\"; fi "
    ]

  }
  depends_on = [
    azurerm_virtual_machine.vm
  ]
}
