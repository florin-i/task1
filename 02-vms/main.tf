
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.rgName

}

module "vm" {
  for_each = { for vm in var.vms : vm.index => vm}
  source = "./modules/vm"
  location = var.location
  rgName = azurerm_resource_group.rg.name
  vnetName = var.vnetName
  subnetId = azurerm_subnet.sub.id
  vm = each.value
  
  depends_on = [
    azurerm_resource_group.rg
  ]
}