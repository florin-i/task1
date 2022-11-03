
variable "location" {
  type = string
}

variable "rgName" {
  type = string
}

variable "vnetName" {
  type = string
}

variable "subnetName" {
  type = string
}

variable "adminUserName" {
  type = string
  default = "adminuser"
}

variable "vms" {
  type = list(object({
    name = string
    index = number
    size = string
    image = object({
      publisher = string
      offer = string
      sku = string
      version = string
    })
  }))
}