terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "Civica-UK-CG-MAS-dev"

    workspaces {
      name = "developer-environments"
    }
  }
}

provider "azurerm" {
  features {}
}

module "azure_windows_vm_1" {
  count                   = length(local.vm_params)
  source                  = "./azure_windows_vm"
  script_url              = azurerm_storage_blob.setup.url
  script_file             = azurerm_storage_blob.setup.name
  repo_dir                = "uk-cg-mas-dev-terraform"

  vm_settings = {
    name                    = local.vm_params[count.index]["name"]
    computer_name           = local.vm_params[count.index]["computer_name"]
    resource_group_name     = local.vm_params[count.index]["resource_group_name"]
    subnet_id               = tolist(azurerm_virtual_network.primary.subnet)[0].id # TODO: This is dodgy since order not guaranteed
    admin_username          = var.admin_username
    admin_password          = var.admin_password
  }
}

