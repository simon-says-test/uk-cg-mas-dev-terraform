resource "azurerm_resource_group" "vm_rg" {
  name     = local.merged_vm_settings.resource_group_name
  location = local.merged_vm_settings.location
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "${local.merged_vm_settings.name}-nic"
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = local.merged_vm_settings.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
    computer_name           = local.merged_vm_settings.computer_name
    name                    = local.merged_vm_settings.name
    resource_group_name     = local.merged_vm_settings.resource_group_name
    location                = local.merged_vm_settings.location
    size                    = local.merged_vm_settings.size
    admin_username          = local.merged_vm_settings.admin_username
    admin_password          = local.merged_vm_settings.admin_password
    network_interface_ids   = [azurerm_network_interface.vm_nic.id]
    os_disk {
      name                    = "${local.merged_vm_settings.name}-os-disk"
      caching                 = local.merged_vm_settings.os_disk.caching
      storage_account_type    = local.merged_vm_settings.os_disk.storage_account_type
      disk_size_gb            =  local.merged_vm_settings.os_disk.disk_size_gb
    }
    source_image_reference {
      publisher               = local.merged_vm_settings.source_image_reference.publisher
      offer                   = local.merged_vm_settings.source_image_reference.offer
      sku                     = local.merged_vm_settings.source_image_reference.sku
      version                 = local.merged_vm_settings.source_image_reference.version
    }
}

resource "azurerm_managed_disk" "vm_data_disk" {
  name                 = "${local.merged_vm_settings.name}-data-disk"
  location             = azurerm_resource_group.vm_rg.location
  resource_group_name  = azurerm_resource_group.vm_rg.name
  storage_account_type = "StandardSSD_LRS"
  create_option        = "Empty"
  disk_size_gb         = "256"
  os_type              = "Windows"
}

resource "azurerm_virtual_machine_data_disk_attachment" "vm_data_disk_attachment" {
  managed_disk_id    = azurerm_managed_disk.vm_data_disk.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = "10"
  caching            = "ReadWrite"
}