# Region where resources will be deployed
variable "location" {
    description = "Region where resources will be deployed"
    type        = string
}

# Resource group name
variable "resource_group_name" {
    description = "Name of the resource group"
    type        = string
}

# Subnet ID for Firewall
variable "subnet_id" {
    description = "ID of the subnet where the firewall will be deployed"
    type        = string
}

# Variables
variable "firewall_name" {
  description = "The name of the Azure Firewall."
  type        = string
}


variable "sku_tier" {
  description = "The SKU tier of the Azure Firewall."
  type        = string
  default     = "Standard"
}

variable "is_public" {
  description = "Does the Firewall require a Public IP?"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to associate with the Azure Firewall."
  type        = map(string)
  default     = {}
}
