variable "rgName" {
  type = string
  description = "name of the resource group"
}
variable "location" {
  type = string
  description = "location where resources will be created" 
}
variable "vnetName" {
  type = string
  description = "name of the virtual network"
}

variable "subnetId" {
  type = string
  description = "ID of the subnet to be used"
}

variable "adminUserName" {
  type = string
  description = "admin username"
  default = "adminuser"
}

variable "vm" {
  type = object({
    name = string
    index = number
    size = string
    image = object({
      publisher = string
      offer = string
      sku = string
      version = string
    })
  })
}