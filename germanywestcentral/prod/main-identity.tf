module "idty_backup" {
  providers = { azurerm = azurerm.identity }
  source    = "../../_modules/backup"
  #  source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//backup?ref=0.1.7"

  workload                   = "identity-aleksei"
  environment                = var.environment
  location                   = var.location
  location_abbreviation      = var.location_abbreviation
  timezone                   = var.time_zone
  log_analytics_workspace_id = module.mgmt_monitor.log_analytics_workspace_id
  tags                       = local.tags
}

module "idty_virtual_network" {
  providers = { azurerm = azurerm.identity }
  source    = "../../_modules/virtual_network"
  #  source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//virtual_network?ref=0.1.7"

  workload                      = "identity-aleksei"
  environment                   = var.environment
  location                      = var.location
  location_abbreviation         = var.location_abbreviation
  virtual_network_address_space = var.idty_virtual_network_address_space
  subnet_prefixes               = var.idty_subnet_prefixes
  subnet_delegations            = var.idty_subnet_delegations
  tags                          = local.tags
}

module "idty_private_dns_resolver" {
  providers = { azurerm = azurerm.identity }
  source    = "../../_modules/private_dns_resolver"
  #  source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//private_dns_resolver?ref=0.1.7"

  workload                  = "identity-aleksei"
  environment               = var.environment
  location                  = var.location
  location_abbreviation     = var.location_abbreviation
  virtual_network_id        = module.idty_virtual_network.virtual_network_id
  dns_inbound_pe_subnet_id  = module.idty_virtual_network.subnet_id["snet-dnsie-prod-001"]
  dns_outbound_pe_subnet_id = module.idty_virtual_network.subnet_id["snet-dnsoe-prod-001"]
  dns_forwarding_rules      = var.dns_forwarding_rules
  virtual_network_ids       = local.virtual_network_ids
  tags                      = local.tags
}

module "idty_private_dns_zones" {
  providers = { azurerm = azurerm.identity }
  source    = "../../_modules/private_dns_zones"
  #  source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//private_dns_zones?ref=0.1.7"

  workload              = "identity-aleksei"
  environment           = var.environment
  location              = var.location
  location_abbreviation = var.location_abbreviation
  virtual_network_id    = module.idty_virtual_network.virtual_network_id
  private_dns_zones     = var.private_dns_zones
  tags                  = local.tags
}

################################Peerings#########################################

resource "azurerm_virtual_network_peering" "identity-to-connectivity" {
  provider   = azurerm.identity
  depends_on = [time_sleep.wait_for_vnet_gateway]

  name                         = "peering-identity-to-connectivity"
  resource_group_name          = module.idty_virtual_network.resource_group_name
  virtual_network_name         = module.idty_virtual_network.virtual_network_name
  remote_virtual_network_id    = module.cnty_virtual_network.virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
}

#####################Route tables, Routes and RT associations####################

resource "azurerm_route_table" "idty_route_table" {
  provider = azurerm.identity

  name                = "rt-identity-aleksei"
  location            = module.idty_virtual_network.location
  resource_group_name = module.idty_virtual_network.resource_group_name
}

resource "azurerm_route" "identity_to_connectivity" {
  provider   = azurerm.identity
  depends_on = [module.cnty_firewall]

  name                   = "to-connectivity"
  resource_group_name    = module.idty_virtual_network.resource_group_name
  route_table_name       = azurerm_route_table.idty_route_table.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.cnty_firewall.firewall_private_ip
}

resource "azurerm_subnet_route_table_association" "idty_rt_association" {
  provider = azurerm.identity
  for_each = var.idty_subnet_prefixes

  subnet_id      = module.idty_virtual_network.subnet_id[each.key]
  route_table_id = azurerm_route_table.idty_route_table.id
}