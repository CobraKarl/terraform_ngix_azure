terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.91.0"
    }
  }
}

resource "azurerm_virtual_network" "vnet" {
    name = "vnet"
    location = var.location
    resource_group_name = var.RGName
    address_space = [ "10.0.0.0/16" ]
  
}

resource "azurerm_subnet" "subnet1" {
    name = "subnet1"
    resource_group_name = var.RGName
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [ "10.0.1.0/24" ]
    
}

resource "azurerm_subnet" "subnet2" {
    name = "subnet2"
    resource_group_name = var.RGName
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = [ "10.0.2.0/24" ]
    
}

output "azurerm_subnet_id" {
  value = azurerm_subnet.subnet.id
}