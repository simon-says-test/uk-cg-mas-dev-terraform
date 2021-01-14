locals {
    vm_params = [ 
        { 
          computer_name = "simon-dev"
          name = "vm-ukcg-dev-simon"  
          resource_group_name = "rg-ukcg-dev-simon"
        },
        { 
          computer_name = "vm-civica-ukcg-warren"
          name = "vm-ukcg-dev-warren"  
          resource_group_name = "rg-ukcg-dev-warren"
        }
    ]
}
