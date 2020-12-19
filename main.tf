terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "test-rg-ST"
  location = "uksouth"
}

resource "azurerm_resource_group" "example2" {
  name     = "test-rg-WJ"
  location = "uksouth"
}

resource "azurerm_resource_group" "vnet" {
  name     = "Admin-VNet"
  location = "uksouth"
}

resource "azurerm_virtual_network" "primary" {
  name                = "DEV-AZ-VNET"
  address_space       = ["192.168.16.0/23"]
  location            = azurerm_resource_group.vnet.location
  resource_group_name = azurerm_resource_group.vnet.name
}

resource "azurerm_subnet" "primary" {
  name                 = "DEV-AZ-Sub01"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.primary.name
  address_prefixes     = ["192.168.16.0/24"]
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

