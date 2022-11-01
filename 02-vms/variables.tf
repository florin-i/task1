variable "numberOfVms" {
  type = number
  validation {
    condition = (
      var.numberOfVms >= 2 &&
      var.numberOfVms <= 100
    )
    error_message = "Number of VMs can be between 2 and 100."
  }
}
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
