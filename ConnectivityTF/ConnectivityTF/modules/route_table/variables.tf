variable "location" {
  description = "The Azure location for the route tables"
  type        = string
}

variable "public_rg_name" {
  description = "The name of the public resource group"
  type        = string
}

variable "internal_rg_name" {
  description = "The name of the internal resource group"
  type        = string
}

variable "public_routes" {
  description = "List of public routes"
  type = list(object({
    name               = string
    address_prefix     = string
    next_hop_type      = string
    next_hop_ip_address = optional(string) 
  }))
  default = [
    {
      name           = "route-to-internet"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    },
    {
      name               = "route-to-firewall"
      address_prefix     = "10.0.0.0/16"
      next_hop_type      = "VirtualAppliance"
      next_hop_ip_address = "10.250.1.4" # Internal Firewall IP
    }
  ]
}

variable "internal_routes" {
  description = "List of internal routes"
  type = list(object({
    name           = string
    address_prefix = string
    next_hop_type  = string
    next_hop_ip_address = optional(string) 
  }))
  default = []
}

variable "public_firewall_ip" {
  description = "Public IP address of the Public Firewall"
  type        = string
}

variable "internal_firewall_ip" {
  description = "Private IP address of the Internal Firewall"
  type        = string
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
}
variable "safe_routes" {
  type = list(object({
    name            = string
    address_prefix  = string
    next_hop_type   = string
    next_hop_ip     = string
  }))
  default = [
    {
      name           = "route-to-internal"
      address_prefix = "10.0.0.0/16"
      next_hop_type  = "VirtualAppliance"
      next_hop_ip    = "10.1.0.1"
    }
  ]
}
