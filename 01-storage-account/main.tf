
terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.29.1"
    }
  }
}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = "westeurope"
  name     = "tfstate"

}

resource "random_integer" "priority" {
  min = 1
  max = 50000
}

resource "azurerm_storage_account" "sa" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = azurerm_resource_group.rg.location
  name                     = "tfstate${random_integer.priority.result}"
  resource_group_name      = azurerm_resource_group.rg.name

}

resource "azurerm_storage_container" "container" {
  name                 = "tfstate"
  storage_account_name = azurerm_storage_account.sa.name
}
