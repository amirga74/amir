resource "azurerm_virtual_network_peering" "this" {
  count                     = var.enable ? 2 : 0
  name                      = var.peering_names[count.index]
  resource_group_name       = var.resource_group_names[count.index]
  virtual_network_name      = var.virtual_network_names[count.index]
  remote_virtual_network_id = var.remote_virtual_network_ids[count.index]
  allow_virtual_network_access = true
  allow_forwarded_traffic      = var.allow_forwarded_traffic
  allow_gateway_transit        = var.allow_gateway_transit[count.index]
  use_remote_gateways          = var.use_remote_gateways[count.index]
}
