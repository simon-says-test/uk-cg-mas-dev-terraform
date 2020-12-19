variable "admin_username" {
  description   = "The username for the VM admin account"
  type          = string
  default       = null
}

variable "admin_password" {
  description   = "The password for the VM admin account"
  type          = string
  default       = null
}

variable "vm_params" {
  type          = map(any)
  description   = "Groups of VM parameters"
  default       = null
}