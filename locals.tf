locals {
    vm_params = [ 
        { 
          computer_name = "simon"
          username = "simon.thomas@civica.co.uk"
          name = "vm-ukcg-dev-simon"  
          resource_group_name = "rg-ukcg-dev-simon"
        },
        { 
          computer_name = "warren-dev"
          username = "warren.jones@civica.co.uk"
          name = "vm-ukcg-dev-warren"  
          resource_group_name = "rg-ukcg-dev-warren"
        },
        { 
          computer_name = "matt-dev"
          username = "matthew.robinson@civica.co.uk"
          name = "vm-ukcg-dev-matt"  
          resource_group_name = "rg-ukcg-dev-matt"
        }
    ]
}
