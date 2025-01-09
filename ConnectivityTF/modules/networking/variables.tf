# VNet name
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

# Region where the resources will be deployed
variable "location" {
  description = "Region where resources will be deployed"
  type        = string
}

# Resource group name
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

# Address space for the VNet
variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "subnets" {
  description = "List of subnets"
  type = map(object({
    name           = string
    address_prefix = string
  }))
  default = {}
}


variable "tags" {
  description = "Tags to assign to the resources"
  type        = map(string)
  default     = {}
}
