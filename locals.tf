locals {
    vm_params = [ 
        { 
          computer_name = "simon"
          name = "vm-civica-ukcg-dev-simon"  
          resource_group_name = "rg-civica-ukcg-dev-simon"
        },
        { 
          computer_name = "warren"
          name = "vm-civica-cg-dev-warren"  
          resource_group_name = "rg-civica-ukcg-dev-warren"
        }
    ]
}