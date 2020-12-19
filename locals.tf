locals {
    vm_params = [ 
        { 
          name = "vm_ST"  
          resource_group_name = "DEV-ST-RG"
        },
        { 
          name = "vm_WJ"  
          resource_group_name = "DEV-WJ-RG"
        }
    ]
}