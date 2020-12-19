terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "Civica-UK-CG-MAS-dev"

    workspaces {
      name = "developer-environments"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "DEV-ST-RG"
  location = "uksouth"
}

resource "azurerm_resource_group" "example2" {
  name     = "DEV-WJ-RG"
  location = "uksouth"
}

resource "azurerm_resource_group" "vnet" {
  name     = "Admin-VNet"
  location = "uksouth"
}

resource "azurerm_network_security_group" "primary" {
  name                = "DEV-AZ-NSG"
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name
  security_rule {
    priority = 110
    name = "RDP-VMtest"
    source_port_range = "*"
    destination_port_range = "3389"
    protocol = "any"
    source_address_prefixes = "212.28.31.6,213.143.143.69,213.143.143.68,213.143.146.159"
    access = "Allow"
    direction = "Inbound"
  }
}

resource "azurerm_virtual_network" "primary" {
  name                = "DEV-AZ-VNET"
  address_space       = ["192.168.16.0/23"]
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name

  subnet {
    name           = "DEV-AZ-Sub01"
    address_prefix = "192.168.16.0/24"
    security_group = azurerm_network_security_group.primary.id
  }
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.primary.id
    private_ip_address_allocation = "Dynamic"
  }
}

module "azure_windows_vm_1" {
  count = length(local.vm_params)
  source = "./azure_windows_vm"

  vm_settings = {
    name = local.vm_params[count.index]["name"]
    resource_group_name = local.vm_params[count.index]["resource_group_name"]
    network_interface_ids = [
      azurerm_network_interface.example.id,
    ]
  }
}

