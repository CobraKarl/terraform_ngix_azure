terraform {
  required_providers {
    azurerm = "->2.91.0"
  }
}

provider "azurerm" {
    subscription_id = var.subscriptionId
    client_id = var.clientId
    client_secret = var.clientSecret
    tenant_id = var.tenantId
    features {
      
    } 
}

# Create RG
resource "azurerm_resource_group" "rg" {
  name     = var.RGName
  location = var.location

}

module "vnet" {
    source = "./modules"
    depends_on = [
      azurerm_resource_group.rg
    ]
  
}

# Create NSG
resource "azurerm_network_security_group" "allowedports" {
    name = "allowedports"
    resource_group_name = var.RGName
    location = var.location

    security_rule = {
        name: "http"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "TCP"
        source_port_range = "*"
        destination_port_range = "80"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    
    security_rule = {
        
        name = "https"
        priority = 200
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "443"
        source_address_prefix = "*"
        destination_address_prefix = "*"
    
    }

    security_rule = {
        name = "ssh"
        priority = 300
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "22"
        source_address_prefix = "*"
        destination_address_prefix = "*"

    }
    
    } 
}

