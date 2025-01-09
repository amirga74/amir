resource "azurerm_route_table" "main" {
  name                = var.route_table_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  dynamic "route" {
    for_each = var.routes
    content {
      name           = route.value.name
      address_prefix = route.value.address_prefix
      next_hop_type  = route.value.next_hop_type
      next_hop_ip    = route.value.next_hop_ip
    }
  }
}
