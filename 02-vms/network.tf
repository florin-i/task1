resource "azurerm_virtual_network" "vnet" {
  address_space       = ["10.123.0.0/16"]
  location            = var.location
  name                = var.vnetName
  resource_group_name = azurerm_resource_group.rg.name

}

resource "azurerm_subnet" "sub" {
  address_prefixes     = ["10.123.1.0/24"]
  name                 = var.subnetName
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

}
