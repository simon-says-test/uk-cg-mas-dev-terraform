variable "vm_defaults" {
  type = object({
    location                    = string
    size                        = string
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

variable "repository_url" {
  description = "The URL of the repository containing the setup scripts to run on VM creation."
  type = string
  default = "https://github.com/CivicaDigital/uk-cg-mas-dev-terraform.git"
}

variable "script_directory" {
  description = "The directory path of the setup scripts to run on VM creation."
  type = string
  default = "resources"
}

locals {
  merged_vm_settings = merge(var.vm_defaults, var.vm_settings)
}