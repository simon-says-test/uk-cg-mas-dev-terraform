resource "azurerm_resource_group" "storage" {
  name     = "Admin-Storage"
  location = "uksouth"
}

resource "azurerm_storage_account" "public" {
  name                     = "stukcgdevpublicdata001"
  resource_group_name      = azurerm_resource_group.storage.name
  location                 = azurerm_resource_group.storage.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
}

resource "azurerm_storage_container" "public" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.public.name
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "initialize_vm" {
  name                   = "Initialize-VirtualMachine.ps1"
  storage_account_name   = azurerm_storage_account.public.name
  storage_container_name = azurerm_storage_container.public.name
  type                   = "Block"
  source                 = "resources/Initialize-VirtualMachine.ps1"
}

resource "azurerm_storage_blob" "mount_datadisks" {
  name                   = "Mount-DataDisks.ps1"
  storage_account_name   = azurerm_storage_account.public.name
  storage_container_name = azurerm_storage_container.public.name
  type                   = "Block"
  source                 = "resources/Mount-DataDisks.ps1"
}

# resource "azurerm_storage_account" "private" {
#   name                     = "stukcgdevprivatedata001"
#   resource_group_name      = azurerm_resource_group.storage.name
#   location                 = azurerm_resource_group.storage.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#   allow_blob_public_access = true
# }

# resource "azurerm_storage_account_network_rules" "private" {
#   resource_group_name  = azurerm_resource_group.storage.name
#   storage_account_name = azurerm_storage_account.private.name
#   default_action             = "Deny"
#   ip_rules                   = ["127.0.0.1","212.28.31.6","213.143.143.69","213.143.143.68","213.143.146.159"]
#   virtual_network_subnet_ids = [tolist(azurerm_virtual_network.primary.subnet)[0].id] # TODO: This is dodgy since order not guaranteed
#   bypass                     = ["Metrics"]
# }

# resource "azurerm_storage_container" "private" {
#   name                  = "content"
#   storage_account_name  = azurerm_storage_account.private.name
#   container_access_type = "blob"
# }

# resource "azurerm_storage_blob" "matrix_icon" {
#   name                   = "matrix-icon.ico"
#   storage_account_name   = azurerm_storage_account.private.name
#   storage_container_name = azurerm_storage_container.private.name
#   type                   = "Block"
#   source                 = "resources/matrix_code.ico"
# }

# resource "azurerm_storage_blob" "set_folder_icon" {
#   name                   = "Set-FolderIcon.ps1"
#   storage_account_name   = azurerm_storage_account.private.name
#   storage_container_name = azurerm_storage_container.private.name
#   type                   = "Block"
#   source                 = "resources/Set-FolderIcon.ps1"
# }