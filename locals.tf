locals {
    vm_params = [ 
        { 
          computer_name = "simon"
          username = "7956891c-a114-4d6a-9565-ae33ad53aacf"
          name = "vm-ukcg-dev-simon"  
          resource_group_name = "RG-UKCG-DEV-SIMON"
        },
        { 
          computer_name = "warren"
          username = "e41bbfca-379a-4159-bd56-4906ce5bf237"
          name = "vm-ukcg-dev-warren"  
          resource_group_name = "RG-UKCG-DEV-WARREN"
        },
        { 
          computer_name = "matt"
          username = "06020d9c-647f-41d7-aa89-868fa651804a"
          name = "vm-ukcg-dev-matt"  
          resource_group_name = "RG-UKCG-DEV-MATT"
        }
    ]
}
