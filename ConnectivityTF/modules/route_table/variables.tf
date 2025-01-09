variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "location" {
  description = "Location of the resource"
  type        = string
}

variable "route_table_name" {
  description = "The name of the route table"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}

variable "routes" {
  description = "List of routes for the route table"
  type = map(object({
    name           = string
    address_prefix = string
    next_hop_type  = string
    next_hop_ip    = string
  }))
}
