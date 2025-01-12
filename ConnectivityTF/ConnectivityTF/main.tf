# Create Resource Group for PublicDevHub
resource "azurerm_resource_group" "RG_IL_PublicDevHub_01" {
  name     = "RG_IL_PublicDevHub_01"
  location = var.location
}

resource "azurerm_resource_group" "RG_IL_SafeDevHub_01" {
  name     = "RG_IL_SafeDevHub_01"
  location = var.location
}

# Create Resource Group for PublicDevHub
resource "azurerm_resource_group" "RG-IL-PublicProdHub-01" {
  name     = "RG-IL-PublicDevHub-01"
  location = var.location
}

resource "azurerm_resource_group" "RG-IL-SafeProdHub-01" {
  name     = "RG_IL_SafeDevHub_01"
  location = var.location
}




# Create Public VNet 
#Change Address space!!!
module "safe_network" {
  source              = "./modules/networking"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG_IL_SafeDevHub_01.name 
  vnet_name           = "VNET-IL-SafeDevHub"
  address_space       = ["196.168.0.0/24"]
   tags = {
    environment = "Public"
    owner       = "yourname"
  }

  subnets = {
    AzureFirewallSubnet = {
      name           = "AzureFirewallSubnet"
      address_prefix = "196.168.0.0/26"
    },
    GWsubnet = {
      name           = "GW-subnet"
      address_prefix = "196.168.0.0/24"
    },
    Appssubnet = {
      name           = "Apps-subnet"
      address_prefix = "196.168.0.0/22"
    }
  }
}

   


#Create Internal VNet
#Change Address space!!!
module "public_network" {
  source              = "./modules/networking"
  location            = var.location
  resource_group_name =  azurerm_resource_group.RG_IL_PublicDevHub_01.name
  vnet_name           = "VNET-IL-DevHub"
  address_space       = ["196.168.16.0/24"]
  tags = {
    environment = "Dev Public"
    owner       = "yourname"
  }

  subnets = {
    AzureFirewallSubnet = {
      name           = "AzureFirewallSubnet"
      address_prefix = "196.168.16.0/26" #Change Address space!!!
      private_endpoint_network_policies_enabled     = true
      private_link_service_network_policies_enabled = true
    },
    PrivateEndpointsSubnet = {
      name           = "PrivateEndpointsSubnet"
      address_prefix = "196.168.16.64/26"
      private_endpoint_network_policies_enabled     = true
      private_link_service_network_policies_enabled = true
    },
    IMgmtSubnet = {
      name           = "IMgmtSubnet"
      address_prefix = "196.168.16.128/26"
    }
    }
}

# Create another Internal VNet for Safe ProdHub
module "safe_network_02" {
  source              = "./modules/networking"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG-IL-SafeProdHub-01.name
  vnet_name           = "VNET-IL-SafeProdHub-02"
  address_space       = ["10.250.0.0/16"]
  tags = {
    environment = "Prod_Safe"
    owner       = "yourname"
  }

  subnets = {
    AzureFirewallSubnet = {
      name           = "AzureFirewallSubnet"
      address_prefix = "10.250.1.0/24"
    },
    GWsubnet = {
      name           = "GW-subnet"
      address_prefix = "10.250.2.0/24"
    },
    Appssubnet = {
      name           = "Apps-subnet"
      address_prefix = "10.250.3.0/24"
    }
  }
}


# Create Internal VNet for Public ProdHub
module "public_network_02" {
  source              = "./modules/networking"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG-IL-PublicProdHub-01.name
  vnet_name           = "VNET-IL-PublicDevHub-01"
  address_space       = ["196.168.16.0/24"]
  tags = {
    environment = "Prod Public"
    owner       = "yourname"
  }

  subnets = {
    AzureFirewallSubnet = {
      name           = "AzureFirewallSubnet"
      address_prefix = "196.168.16.0/26"  # Change Address space!!!
      private_endpoint_network_policies_enabled     = true
      private_link_service_network_policies_enabled = true
    },
    PrivateEndpointsSubnet = {
      name           = "PrivateEndpointsSubnet"
      address_prefix = "196.168.16.64/26"
      private_endpoint_network_policies_enabled     = true
      private_link_service_network_policies_enabled = true
    },
    IMgmtSubnet = {
      name           = "IMgmtSubnet"
      address_prefix = "196.168.16.128/26"
    }
  }
}
#internal firewall
module "public_firewall" {
  source              = "./modules/Public_firewall"
  firewall_name       = "AFW-IL-DevPublicFW-PE-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG_IL_PublicDevHub_01.name
  subnet_id           = module.public_network.subnet_ids["AzureFirewallSubnet"]
  is_public           = true
  sku_tier            = "Standard"
  tags = {
    environment = "Internal"
    owner       = "YourName"
  }
}

module "safe_firewall" {
  source              = "./modules/safe_firewall"
  firewall_name       = "AFW-IL-DevFW-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG_IL_SafeDevHub_01.name
  subnet_id           = module.safe_network.subnet_ids["AzureFirewallSubnet"] # <-- Corrected reference
  sku_tier            = "Standard"
  tags = {
    environment = "safe"
    owner       = "YourName"
  }
}

#internal firewall
module "Prod_public_firewall" {
  source              = "./modules/Public_firewall"
  firewall_name       = "AFW-IL-ProdSafe-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG-IL-PublicProdHub-01.name
  subnet_id           = module.public_network_02.subnet_ids["AzureFirewallSubnet"]
  is_public           = true
  sku_tier            = "Standard"
  tags = {
    environment = "Prod_public"
    owner       = "YourName"
  }
}

module "Safe_Prod_firewall" {
  source              = "./modules/safe_firewall"
  firewall_name       = "AFW-IL-ProdSafe-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.RG_IL_SafeDevHub_01.name
  subnet_id           = module.safe_network_02.subnet_ids["AzureFirewallSubnet"] # <-- Corrected reference
  sku_tier            = "Standard"
  tags = {
    environment = "safe"
    owner       = "YourName"
  }
}

module "route_tables_Dev" {
  source              = "./modules/route_table"
  location            = var.location
  public_rg_name      = azurerm_resource_group.RG_IL_PublicDevHub_01.name
  internal_rg_name    = azurerm_resource_group.RG_IL_SafeDevHub_01.name
  public_routes       = var.public_routes
  internal_routes     = var.internal_routes
  public_firewall_ip  = module.public_firewall.firewall_ip
  internal_firewall_ip = module.safe_firewall.firewall_ip
  tags = {
    environment = "Production"
    owner       = "YourName"
  }

}
module "route_tables_Prod" {
  source              = "./modules/route_table"
  location            = var.location
  public_rg_name      = azurerm_resource_group.RG_IL_PublicDevHub_01.name
  internal_rg_name    = azurerm_resource_group.RG_IL_SafeDevHub_01.name
  public_routes       = var.public_routes
  internal_routes     = var.internal_routes
  public_firewall_ip  = module.public_firewall.firewall_ip
  internal_firewall_ip = module.safe_firewall.firewall_ip  # Corrected reference
  tags = {
    environment = "Production"
    owner       = "YourName"
  }
}





module "vnet_peering" {
  source                   = "./modules/vnet_peering"
  peering_names            = ["prod_public-to-prod_internal", "prod_internal-to-prod_public"]
  resource_group_names     = [
    azurerm_resource_group.RG-IL-PublicProdHub-01.name,
    azurerm_resource_group.RG-IL-SafeProdHub-01.name
  ]
  virtual_network_names    = [
    module.public_network.vnet_name,
    module.safe_network.vnet_name
  ]
  remote_virtual_network_ids = [
    module.safe_network.vnet_id,
    module.public_network.vnet_id
  ]
  allow_forwarded_traffic  = false
  allow_gateway_transit    = [false, false]
  use_remote_gateways      = [false, false]
}
module "vnet_peering_01" {
  source                   = "./modules/vnet_peering"
  peering_names            = ["dev_public-to-dev_internal", "dev_internal-to-dev_public"]
  resource_group_names     = [
    azurerm_resource_group.RG-IL-PublicProdHub-01.name,
    azurerm_resource_group.RG-IL-SafeProdHub-01.name
  ]
  virtual_network_names    = [
    module.public_network.vnet_name,
    module.safe_network.vnet_name
  ]
  remote_virtual_network_ids = [
    module.safe_network_02.vnet_id,
    module.public_network_02.vnet_id
  ]
  allow_forwarded_traffic  = false
  allow_gateway_transit    = [false, false]
  use_remote_gateways      = [false, false]
}
