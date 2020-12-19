# variable "resource_group_name" {
#   description = "Default resource group name that the developer environment will be created in."
#   type        = list
#   default     = ["DEV-ST-RG"]
# }

# variable "vm_name" {
#   description = "Default name of the virtual machine."
#   type        = list
#   default     = ["vm-civica-dms-simon-thomas"]
# }

variable "vm_params" {
    type = map(any)
    description = "Groups of VM parameters"
    default = null
}