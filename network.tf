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
    destination_address_prefix = "*"
    destination_port_range = "3389"
    protocol = "*"
    source_address_prefixes = ["212.28.31.6","213.143.143.69","213.143.143.68","213.143.146.159"]
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
    name                = "DEV-AZ-Sub01"
    address_prefix      = "192.168.16.0/24"
    security_group      = azurerm_network_security_group.primary.id
  }
}