
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.rgName

}

module "vm" {
  for_each = var.vms
  source = "./modules/vm"
  location = var.location
  rgName = azurerm_resource_group.rg.name
  vnetName = var.vnetName
  subnetId = azurerm_subnet.sub.id
  sshKey = var.sshKey
  vm = each.value
  vmName = each.key
  
  depends_on = [
    azurerm_resource_group.rg
  ]
}