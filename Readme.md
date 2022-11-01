# Readme

## In 01-storage-acccount folder
Terraform file to create the azure storage account for terraform remote state.

## In 02-vms folder:
Terraform script to create a variable number of VMs in Azure (between 2 and 100) each with a random password) 
and after that execute a ping command in a round-robin fashion between VMs.

State file will be stored in the storage account created by terraform code in 01-storage-account folder.

The following resources will be created also: 
 - a resource group for all resources
 - a VNet and a subnet 

### Variables:
 - numberOfVms = number of VM that will be created
 - location  = Azure location 
 - rgName = name of the resource group that will be created 
 - vnetName = name of the Vnet that will be created
 - subnetName = name of the subnet that will be created

### Example tfvar file:
```bash
numberOfVms = 2
location = "westeurope"
rgName = "task-01"
vnetName = "VNet01"
subnetName = "VMs"
```