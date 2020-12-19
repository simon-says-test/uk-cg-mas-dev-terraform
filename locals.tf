locals {
    vm_params = [ 
        { 
          name = "vm-civica-ukcg-dev-simon"  
          resource_group_name = "rg-civica-ukcg-dev-simon"
        },
        { 
          name = "vm-civica-cg-dev-warren"  
          resource_group_name = "rg-civica-ukcg-dev-warren"
        }
    ]
}