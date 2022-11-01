terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.29.1"
    }
    random = {
      source = "hashicorp/random"
    }
    null = {
      source = "hashicorp/null"
    }
  }
  required_version = ">=0.13"

  backend "azurerm" {
    container_name       = "tfstate"
    key                  = "vms/terraform.tfstate"
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate25518"
  }
}
