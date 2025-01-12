# Create Public Route Table
resource "azurerm_route_table" "public_route_table" {
  name                = "public-route-table"
  location            = var.location
  resource_group_name = var.public_rg_name
  tags                = var.tags
}

# Create Internal Route Table
resource "azurerm_route_table" "internal_route_table" {
  name                = "internal-route-table"
  location            = var.location
  resource_group_name = var.internal_rg_name
  tags                = var.tags
}

# Add Routes to the Public Route Table
resource "azurerm_route" "public_routes" {
  for_each = { for route in var.public_routes : route.name => route }

  name                   = each.key
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  route_table_name       = azurerm_route_table.public_route_table.name
  resource_group_name    = var.public_rg_name

  # Add next_hop_in_ip_address only if next_hop_type is VirtualAppliance
  next_hop_in_ip_address = each.value.next_hop_type == "VirtualAppliance" ? each.value.next_hop_ip_address : null


}

# Add Routes to the Internal Route Table
resource "azurerm_route" "internal_routes" {
  for_each              = { for route in var.internal_routes : route.name => route }
  name                  = each.key
  address_prefix        = each.value.address_prefix
  next_hop_type         = each.value.next_hop_type
  next_hop_in_ip_address = var.internal_firewall_ip
  route_table_name      = azurerm_route_table.internal_route_table.name
  resource_group_name   = var.internal_rg_name
}

# Outputs for Route Tables
output "public_route_table_id" {
  value = azurerm_route_table.public_route_table.id
}

output "internal_route_table_id" {
  value = azurerm_route_table.internal_route_table.id
}