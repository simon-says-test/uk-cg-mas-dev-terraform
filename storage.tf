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
}

resource "azurerm_storage_container" "primary" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.primary.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "primary" {
  name                   = "matrix-icon.ico"
  storage_account_name   = azurerm_storage_account.primary.name
  storage_container_name = azurerm_storage_container.primary.name
  type                   = "Block"
  source                 = "resources/matrix_code.ico"
}