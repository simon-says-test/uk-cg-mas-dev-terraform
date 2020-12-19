# variable "name" {
#   type = string
#   description = "The name of the virtual machine"
# }

variable "vm_defaults" {
  type = object({
    location                    = string
    size                        = string
    admin_username              = string
    admin_password              = string
    os_disk                     = object({
      caching                     = string
      storage_account_type        = string
      disk_size_gb                = string
    })
    source_image_reference      = object({
      publisher                   = string
      offer                       = string
      sku                         = string
      version                     = string
    })
  })

  default = {
    location                = "uksouth"
    size                    = "Standard_D4s_v4"
    admin_username          = "admint"
    admin_password          = "testpassword"
    os_disk                 = {
      caching                 = "ReadWrite"
      storage_account_type    = "StandardSSD_LRS"
      disk_size_gb            = "127"
    }
    source_image_reference  = {
      publisher               = "MicrosoftWindowsDesktop"
      offer                   = "Windows-10"
      sku                     = "20h1-pro-g2"
      version                 = "latest"
    }
  }
}

variable "vm_settings" {
  description = "Map of vm settings to be applied which will be merged with the vm_defaults. Allowed keys are the same as for vm_defaults."
}

locals {
  merged_vm_settings = merge(var.vm_defaults, var.vm_settings)
}

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

# resource "azurerm_managed_disk" "vm_os_disk" {
#   name                 = "${local.merged_vm_settings.name}-os-disk"
#   location             = azurerm_resource_group.vm_rg.location
#   resource_group_name  = azurerm_resource_group.vm_rg.name
#   storage_account_type = "StandardSSD_LRS"
#   create_option        = "FromImage"
#   disk_size_gb         = "127"
#   os_type              = "Windows"
#   image_reference_id   = "/Subscriptions/adf5dccc-9634-45e1-8726-5fc2fa4df370/Providers/Microsoft.Compute/Locations/uksouth/Publishers/MicrosoftWindowsDesktop/ArtifactTypes/VMImage/Offers/Windows-10/Skus/20h1-pro-g2/Versions/19041.508.2009070256"
# }

resource "azurerm_windows_virtual_machine" "vm" {
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