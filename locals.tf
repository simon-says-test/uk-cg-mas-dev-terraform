locals {
    vm_params = [ 
        { 
          name = "vm-civica-mas-ST-001"  
          resource_group_name = "DEV-ST-RG"
        },
        { 
          name = "vm-civica-mas-WJ-001"  
          resource_group_name = "DEV-WJ-RG"
        }
    ]
}