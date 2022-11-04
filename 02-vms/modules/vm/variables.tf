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

variable "sshKey" {
  type = string
  description = "ssh public key"
}

variable "vm" {
  type = object({
      size = string
      image = object({
        publisher = string
        offer = string
        sku = string
        version = string
      })
  })
}

variable "vmName" {
  type = string
}