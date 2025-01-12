variable "peering_names" {
  description = "Names of the peerings"
  type        = list(string)
}

variable "resource_group_names" {
  description = "Resource group names for the peerings"
  type        = list(string)
}

variable "virtual_network_names" {
  description = "Virtual network names"
  type        = list(string)
}

variable "remote_virtual_network_ids" {
  description = "Remote virtual network IDs"
  type        = list(string)
}

variable "allow_forwarded_traffic" {
  description = "Allow forwarded traffic"
  type        = bool
}

variable "allow_gateway_transit" {
  description = "Allow gateway transit"
  type        = list(bool)
}

variable "use_remote_gateways" {
  description = "Use remote gateways"
  type        = list(bool)
}
variable "enable" {
  description = "Flag to enable or disable resources"
  type        = bool
  default     = false
}

