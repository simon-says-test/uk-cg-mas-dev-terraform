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