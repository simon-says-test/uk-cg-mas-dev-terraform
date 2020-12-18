variable "name" {
  type = string
  description = "The name of the virtual machine"
}

variable "vm_defaults" {
  type = object({
    location                    = string
    size                        = string
    admin_username              = string
    admin_password              = string
    os_disk                     = object({
      caching                     = string
      storage_account_type        = string
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
      storage_account_type    = "Standard_LRS"
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

resource "azurerm_windows_virtual_machine" "example" {
    name                    = local.merged_vm_settings.name
    resource_group_name     = local.merged_vm_settings.resource_group_name
    location                = local.merged_vm_settings.location
    size                    = local.merged_vm_settings.size
    admin_username          = local.merged_vm_settings.admin_username
    admin_password          = local.merged_vm_settings.admin_password
    network_interface_ids   = local.merged_vm_settings.network_interface_ids
    os_disk {
      caching                 = local.merged_vm_settings.os_disk.caching
      storage_account_type    = local.merged_vm_settings.os_disk.storage_account_type
    }
    source_image_reference {
      publisher               = local.merged_vm_settings.source_image_reference.publisher
      offer                   = local.merged_vm_settings.source_image_reference.offer
      sku                     = local.merged_vm_settings.source_image_reference.sku
      version                 = local.merged_vm_settings.source_image_reference.version
    }
}