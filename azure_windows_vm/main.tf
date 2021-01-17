variable "initialize_vm_url" {
  type    = string
}

variable "initialize_vm_file" {
  type    = string
}

variable "mount_disks_url" {
  type    = string
}

variable "mount_disks_file" {
  type    = string
}

variable "userId" {
  type    = string
}

resource "azurerm_resource_group" "vm_rg" {
  name     = local.merged_vm_settings.resource_group_name
  location = local.merged_vm_settings.location
}

resource "azurerm_public_ip" "vm_ip" {
  name                = "${local.merged_vm_settings.name}-public-ip"
  resource_group_name = azurerm_resource_group.vm_rg.name
  location            = azurerm_resource_group.vm_rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = "vm-civica-ukcg-mas-${local.merged_vm_settings.computer_name}"
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "${local.merged_vm_settings.name}-nic"
  location            = azurerm_resource_group.vm_rg.location
  resource_group_name = azurerm_resource_group.vm_rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = local.merged_vm_settings.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_ip.id
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
  name                 = "${local.merged_vm_settings.name}-data-disk-001"
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

# Note that the shutdown doesn't work at present - if you get terraform to create this resource, it 
# doesn't support an email address for notification. If you manually add it afterwards, Terraform recreates every time plan is run.

# resource "azurerm_dev_test_global_vm_shutdown_schedule" "vm_shutdown" {
#   virtual_machine_id = azurerm_windows_virtual_machine.vm.id
#   location           = azurerm_resource_group.vm_rg.location
#   enabled            = true

#   daily_recurrence_time = "1900"
#   timezone              = "GMT Standard Time"

#   notification_settings {
#     enabled         = false
#     time_in_minutes = "60"
#   }
# }

resource "azurerm_role_assignment" "vm_user_role" {
  scope                = azurerm_resource_group.vm_rg.id
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         =  var.userId
}

resource "azurerm_role_assignment" "vm_owner_role" {
  scope                = azurerm_windows_virtual_machine.vm.id
  role_definition_name = "Owner"
  principal_id         =  var.userId
}

# If this is altered, it will not currently update correctly - you will need to delete extension from all VMs in portal/CLI
# If the scripts referenced in fileUris have changed, force resource recreation using e.g.
# terraform taint azurerm_storage_blob.mount_datadisks
resource "azurerm_virtual_machine_extension" "vm_extension" {
  name                 = "initialize"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  depends_on = [
    azurerm_virtual_machine_data_disk_attachment.vm_data_disk_attachment,
  ]
  settings = <<SETTINGS
  {
    "fileUris": ["${var.initialize_vm_url}", "${var.mount_disks_url}"]
  }
  SETTINGS
  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "setx REPO_URL ${var.repository_url} && setx SCRIPT_DIR ${var.script_directory} && powershell.exe -ExecutionPolicy Unrestricted -File ./${var.initialize_vm_file}"
    }
  PROTECTED_SETTINGS
}
