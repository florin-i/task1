resource "azurerm_network_interface" "nic" {
  location            = var.location
  name                = "${var.vm.name}-nic"
  resource_group_name = var.rgName
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnetId
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

}

resource "azurerm_public_ip" "public_ip" {
  name                = "${var.vm.name}-pip"
  resource_group_name = var.rgName
  location            = var.location
  allocation_method   = "Static"
}
