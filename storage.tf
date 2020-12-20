resource "azurerm_resource_group" "storage" {
  name     = "Admin-Storage"
  location = "uksouth"
}

resource "azurerm_storage_account" "primary" {
  name                     = "stukcgdevadmindata001"
  resource_group_name      = azurerm_resource_group.storage.name
  location                 = azurerm_resource_group.storage.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
}

resource "azurerm_storage_account_network_rules" "primary" {
  resource_group_name  = azurerm_resource_group.storage.name
  storage_account_name = azurerm_storage_account.primary.name

  default_action             = "Deny"
  ip_rules                   = ["127.0.0.1"]
  virtual_network_subnet_ids = [tolist(azurerm_virtual_network.primary.subnet)[0].id] # TODO: This is dodgy since order not guaranteed
  bypass                     = ["Metrics"]
}

resource "azurerm_storage_container" "primary" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.primary.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "primary" {
  name                   = "matrix-icon.ico"
  storage_account_name   = azurerm_storage_account.primary.name
  storage_container_name = azurerm_storage_container.primary.name
  type                   = "Block"
  source                 = "resources/matrix_code.ico"
}