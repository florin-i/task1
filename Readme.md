# Readme

## In 01-storage-acccount folder
Terraform file to create the azure storage account for terraform remote state.

## In 02-vms folder:
Terraform script to create a variable number of VMs in Azure (between 2 and 100) each with a random password) 
and after that execute a ping command in a round-robin fashion between VMs.

State file will be stored in the storage account created by terraform code in 01-storage-account folder.

Backend variables for remote state must be provided on terraform init like:
```
terraform init -backend-config=config.azurerm.tfbackend
```

The following resources will be created also: 
 - a resource group for all resources
 - a VNet and a subnet 

### Variables:
 - location  = Azure location 
 - rgName = name of the resource group that will be created 
 - vnetName = name of the Vnet that will be created
 - subnetName = name of the subnet that will be created
 - vms = a list of VMs, each VM beeing an object with the following atributes:
    - name = the name of VM
    - size = the VM size 
    - sshKey = SSH public key to be added to VMs
    - index = an integer starting from 1 for first VM and for each VM the value is incremented with 1
    - image = an object that describe the image used to create the VM with the attributes:
        - offer
        - publisher
        - sku
        - version

### Example tfvar file:
```bash
location = "westeurope"
rgName = "task-01"
vnetName = "VNet01"
subnetName = "VMs"
vms = [ {
  image = {
    offer = "UbuntuServer"
    publisher = "Canonical"
    sku = "16.04-LTS"
    version = "latest"
  }
  name = "test-vm01"
  size = "Standard_B1s"
},{
  image = {
    offer = "UbuntuServer"
    publisher = "Canonical"
    sku = "16.04-LTS"
    version = "latest"
  }
  name = "test-vm02"
  size = "Standard_B1s"
},{
  image = {
    offer = "UbuntuServer"
    publisher = "Canonical"
    sku = "16.04-LTS"
    version = "latest"
  }
  name = "test-vm03"
  size = "Standard_B1s"
}]
```