terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.91.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscriptionId
  client_id       = var.clientId
  client_secret   = var.clientSecret
  tenant_id       = var.tenantId
  features {

  }
}

# Create RG
resource "azurerm_resource_group" "rg" {
  name     = var.RGName
  location = var.location

}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = var.location
  resource_group_name = var.RGName
  address_space       = ["10.0.0.0/16"]
  depends_on = [
    azurerm_resource_group.rg
  ]

}

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = var.RGName
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]

}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = var.RGName
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]

}

# Create NSG
resource "azurerm_network_security_group" "allowedports" {
  name                = "allowedports"
  resource_group_name = var.RGName
  location            = var.location
  depends_on = [
    azurerm_resource_group.rg
  ]

  security_rule {
    name                       = "http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {

    name                       = "https"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ssh"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                = "public_ip"
  resource_group_name = var.RGName
  location            = var.location
  allocation_method   = "Dynamic"
  depends_on = [
    azurerm_resource_group.rg
  ]

}

resource "azurerm_network_interface" "nic" {
  name                = "nic"
  resource_group_name = var.RGName
  location            = var.location
  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.subnet1.id
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
  depends_on = [
    azurerm_resource_group.rg
  ]

}

resource "azurerm_linux_virtual_machine" "nginx" {
  size                  = var.instance_size
  name                  = "nginx_webserver"
  resource_group_name   = var.RGName
  location              = var.location
  custom_data           = base64encode(file("scripts/init.sh"))
  network_interface_ids = ["azurerm_network_interface.RGName.id"]
  os_disk {
    name                 = "nginxdisk01"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    # create_option        = "FromImage"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  computer_name                   = "nginx"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  depends_on = [
    azurerm_resource_group.rg
  ]

}
