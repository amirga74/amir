# Output for Public Firewall ID
output "public_firewall_id" {
  value = module.public_firewall.firewall_id
}

# Output for Safe Firewall ID
output "safe_firewall_id" {
  value = module.safe_firewall.firewall_id
}

# Output for Public VNet ID
output "vnet_id_public" {
  value = module.public_network.vnet_id
}

# Output for Safe VNet ID
output "vnet_id_safe" {
  value = module.safe_network.vnet_id
}




