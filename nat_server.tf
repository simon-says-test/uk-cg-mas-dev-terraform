resource "azurerm_resource_group" "nat" {
  name     = "Admin-Nat"
  location = "uksouth"
}

resource "azurerm_public_ip" "nat" {
  name                = "pip-nat-uksouth-001"
  resource_group_name = azurerm_resource_group.nat.name
  location            = azurerm_resource_group.nat.location
  allocation_method   = "Static"
}

resource "azurerm_nat_gateway" "nat" {
  name                    = "nat-gateway-uksouth-001"
  location                = azurerm_resource_group.nat.location
  resource_group_name     = azurerm_resource_group.nat.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
}

resource "azurerm_nat_gateway_public_ip_association" "nat" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat.id
}
