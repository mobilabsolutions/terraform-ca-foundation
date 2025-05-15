module "cnty_backup" {
  providers = { azurerm = azurerm.connectivity }
  source    = "../../_modules/backup"
  #  source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//backup?ref=0.1.7"

  workload                   = "connectivity-aleksei"
  environment                = var.environment
  location                   = var.location
  location_abbreviation      = var.location_abbreviation
  timezone                   = var.time_zone
  log_analytics_workspace_id = module.mgmt_monitor.log_analytics_workspace_id
  tags                       = local.tags
}

module "cnty_virtual_network" {
  providers = { azurerm = azurerm.connectivity }
  source    = "../../_modules/virtual_network"
  #  source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//virtual_network?ref=0.1.7"

  workload                      = "connectivity-aleksei"
  environment                   = var.environment
  location                      = var.location
  location_abbreviation         = var.location_abbreviation
  virtual_network_address_space = var.cnty_virtual_network_address_space
  subnet_prefixes               = var.cnty_subnet_prefixes
  tags                          = local.tags
}

module "cnty_firewall" {
  providers  = { azurerm = azurerm.connectivity }
  depends_on = [module.mgmt_monitor, module.cnty_virtual_network, module.cnty_bastion]
  source     = "../../_modules/firewall"
  #  source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//firewall?ref=0.1.7"

  workload                   = "connectivity-aleksei"
  environment                = var.environment
  location                   = var.location
  location_abbreviation      = var.location_abbreviation
  resource_group_name        = module.cnty_virtual_network.resource_group_name
  virtual_network_name       = module.cnty_virtual_network.virtual_network_name
  firewall_subnet_id         = module.cnty_virtual_network.subnet_id["AzureFirewallSubnet"]
  log_analytics_workspace_id = module.mgmt_monitor.log_analytics_workspace_id
  tags                       = local.tags
}

module "cnty_bastion" {
  providers = { azurerm = azurerm.connectivity }
  source    = "../../_modules/bastion"
  #  source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//bastion?ref=0.1.7"

  workload                   = "connectivity-aleksei"
  environment                = var.environment
  location                   = var.location
  location_abbreviation      = var.location_abbreviation
  resource_group_name        = module.cnty_virtual_network.resource_group_name
  virtual_network_name       = module.cnty_virtual_network.virtual_network_name
  bastion_subnet_id          = module.cnty_virtual_network.subnet_id["AzureBastionSubnet"]
  log_analytics_workspace_id = module.mgmt_monitor.log_analytics_workspace_id
  tags                       = local.tags
}

module "cnty_virtual_network_gateway" {
  providers = { azurerm = azurerm.connectivity }
  source    = "../../_modules/virtual_network_gateway"
  #  source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//virtual_network_gateway?ref=0.1.7"

  workload                            = "connectivity-aleksei"
  environment                         = var.environment
  location                            = var.location
  location_abbreviation               = var.location_abbreviation
  resource_group_name                 = module.cnty_virtual_network.resource_group_name
  virtual_network_name                = module.cnty_virtual_network.virtual_network_name
  virtual_network_gateway_subnet_id   = module.cnty_virtual_network.subnet_id["GatewaySubnet"]
  log_analytics_workspace_id          = module.mgmt_monitor.log_analytics_workspace_id
  local_network_gateway_ip_address    = var.local_network_gateway_ip_address
  local_network_gateway_address_space = var.local_network_gateway_address_space
  shared_key                          = var.lgw_shared_key
  tags                                = local.tags
}

module "cnty_application_gateway" {
  providers = { azurerm = azurerm.connectivity }
  source    = "../../_modules/application_gateway"
  #  source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//application_gateway?ref=0.1.7"

  workload                      = "connectivity-aleksei"
  environment                   = var.environment
  location                      = var.location
  location_abbreviation         = var.location_abbreviation
  resource_group_name           = module.cnty_virtual_network.resource_group_name
  virtual_network_name          = module.cnty_virtual_network.virtual_network_name
  application_gateway_subnet_id = module.cnty_virtual_network.subnet_id["ApplicationGatewaySubnet"]
  log_analytics_workspace_id    = module.mgmt_monitor.log_analytics_workspace_id
  tags                          = local.tags
}


################################Peerings#########################################

resource "azurerm_virtual_network_peering" "connectivity-to-connected" {
  provider = azurerm.connectivity

  name                         = "connectivity-to-connected"
  resource_group_name          = module.cnty_virtual_network.resource_group_name
  virtual_network_name         = module.cnty_virtual_network.virtual_network_name
  remote_virtual_network_id    = module.conn_virtual_network.virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "connectivity-to-identity" {
  provider = azurerm.connectivity

  name                         = "connectivity-to-identity"
  resource_group_name          = module.cnty_virtual_network.resource_group_name
  virtual_network_name         = module.cnty_virtual_network.virtual_network_name
  remote_virtual_network_id    = module.idty_virtual_network.virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "connectivity-to-management" {
  provider = azurerm.connectivity

  name                         = "connectivity-to-management"
  resource_group_name          = module.cnty_virtual_network.resource_group_name
  virtual_network_name         = module.cnty_virtual_network.virtual_network_name
  remote_virtual_network_id    = module.mgmt_virtual_network.virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  use_remote_gateways          = false
}


#####################Route tables, Routes and RT associations####################
###########################for Application Gateway###############################

resource "azurerm_route_table" "cnty_route_table_appgw" {
  provider = azurerm.connectivity

  name                = "rt-connectivity-appgw-aleksei"
  location            = module.cnty_virtual_network.location
  resource_group_name = module.cnty_virtual_network.resource_group_name
}

resource "azurerm_route" "cnty_appgw_to_connectivity" {
  provider   = azurerm.connectivity
  depends_on = [module.cnty_firewall]

  name                   = "to-connected"
  resource_group_name    = module.cnty_virtual_network.resource_group_name
  route_table_name       = azurerm_route_table.cnty_route_table_appgw.name
  address_prefix         = var.conn_virtual_network_address_space[0]
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.cnty_firewall.firewall_private_ip
}

resource "azurerm_subnet_route_table_association" "cnty_appgw_rt_association" {
  provider = azurerm.connectivity

  subnet_id      = module.cnty_virtual_network.subnet_id["ApplicationGatewaySubnet"]
  route_table_id = azurerm_route_table.cnty_route_table_appgw.id
}

#########################for Virtual Network Gateway#############################

resource "azurerm_route_table" "cnty_route_table_vnetgw" {
  provider = azurerm.connectivity


  name                = "rt-connectivity-gw-aleksei"
  location            = module.cnty_virtual_network.location
  resource_group_name = module.cnty_virtual_network.resource_group_name
}

resource "azurerm_route" "cnty_gw_to_connected" {
  provider   = azurerm.connectivity
  depends_on = [module.cnty_firewall]

  name                   = "to-connected"
  resource_group_name    = module.cnty_virtual_network.resource_group_name
  route_table_name       = azurerm_route_table.cnty_route_table_vnetgw.name
  address_prefix         = var.conn_virtual_network_address_space[0]
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.cnty_firewall.firewall_private_ip
}

resource "azurerm_route" "cnty_gw_to_connectivity" {
  provider   = azurerm.connectivity
  depends_on = [module.cnty_firewall]

  name                   = "to-connectivity"
  resource_group_name    = module.cnty_virtual_network.resource_group_name
  route_table_name       = azurerm_route_table.cnty_route_table_vnetgw.name
  address_prefix         = var.cnty_virtual_network_address_space[0]
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.cnty_firewall.firewall_private_ip
}

resource "azurerm_route" "cnty_gw_to_identity" {
  provider   = azurerm.connectivity
  depends_on = [module.cnty_firewall]

  name                   = "to-identity"
  resource_group_name    = module.cnty_virtual_network.resource_group_name
  route_table_name       = azurerm_route_table.cnty_route_table_vnetgw.name
  address_prefix         = var.idty_virtual_network_address_space[0]
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.cnty_firewall.firewall_private_ip
}

resource "azurerm_route" "cnty_gw_to_management" {
  provider   = azurerm.connectivity
  depends_on = [module.cnty_firewall]

  name                   = "to-identity"
  resource_group_name    = module.cnty_virtual_network.resource_group_name
  route_table_name       = azurerm_route_table.cnty_route_table_vnetgw.name
  address_prefix         = var.mgmt_virtual_network_address_space[0]
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.cnty_firewall.firewall_private_ip
}

resource "azurerm_subnet_route_table_association" "cnty_gw_rt_association" {
  provider = azurerm.connectivity

  subnet_id      = module.cnty_virtual_network.subnet_id["GatewaySubnet"]
  route_table_id = azurerm_route_table.cnty_route_table_vnetgw.id
}