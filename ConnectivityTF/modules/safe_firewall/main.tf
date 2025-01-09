# Deploy Azure Firewall with optional Public IP
resource "azurerm_firewall" "firewall" {
  name                = var.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = var.sku_tier

  ip_configuration {
    name               = "firewall-ip-config"
    subnet_id          = var.subnet_id
    #public_ip_address_id = var.is_public && length(azurerm_public_ip.firewall_public_ip) > 0 ? azurerm_public_ip.firewall_public_ip[0].id : null
  }

  tags = var.tags
}



# Output the Firewall IDs and IPs
output "firewall_id" {
  value = azurerm_firewall.firewall.id
}

output "firewall_private_ip" {
  value = azurerm_firewall.firewall.ip_configuration[0].private_ip_address
}



output "firewall_ip" {
  value = azurerm_firewall.firewall.ip_configuration[0].private_ip_address
}