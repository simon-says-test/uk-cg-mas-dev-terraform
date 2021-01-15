# uk-cg-mas-dev-terraform
Terraform configuration for Civica UK Central Government MAS developer environments

Lots to improve:

- Set Git credentials

Import module resources with count like:

 terraform import module.azure_windows_vm_1[0].azurerm_dev_test_global_vm_shutdown_schedule.vm_shutdown /subscriptions/adf5dccc-9634-45e1-8726-5fc2fa4df370/resourceGroups/RG-UKCG-DEV-SIMON-1/providers/Microsoft.DevTestLab/schedules/shutdown-computevm-vm-ukcg-dev-simon