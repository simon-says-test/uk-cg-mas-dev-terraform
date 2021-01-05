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
}

resource "azurerm_subnet" "primary" {
  name                 = "DEV-AZ-Sub01"
  resource_group_name  = azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.primary.name
  address_prefixes     = ["192.168.16.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

resource "azurerm_subnet_nat_gateway_association" "primary" {
  subnet_id      = azurerm_subnet.primary.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}

resource "azurerm_subnet_network_security_group_association" "primary" {
  subnet_id                 = azurerm_subnet.primary.id
  network_security_group_id = azurerm_network_security_group.primary.id
}