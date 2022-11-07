
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
  type    = string
  default = "adminuser"
}

variable "sshKey" {
  type = string
}

variable "vms" {
  type = map(object({
    size = string
    image = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
  }))
  validation {
    condition     = length(var.vms) > 1 && length(var.vms) <= 100
    error_message = "The number of VMs must be between 2 and 100."
  }
}
