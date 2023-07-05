variable "resource_group_name" {
  type = string
description = "used for naming resource group"
}

variable "resource_location" {
  type = string
  description = "used for defining location"
  default = "eastus"
}

variable "virtual_network_name" {
    type = string
    description = "used for naming virtual name"
  
}

variable "virtual_network_id" {
    type = string
    description = "used for naming virtual id"
  
}


variable "subnet_name" {
    type = string
    description = "used for naming subnet name"
  
}

variable "subnet_id" {
    type = string
    description = "used for naming subnet id"
  
}

variable "Nic_name" {
    type = string
    description = "used for naming NIC name"
  
}
variable "VM_name" {
    type = string
    description = "used for naming NIC name"
  
}