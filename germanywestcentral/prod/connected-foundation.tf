module "conn_backup" {
  providers = { azurerm = azurerm.connected }
  source    = "../../_modules/backup"
  # source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//backup?ref=0.1.7"

  workload                   = "connected-aleksei"
  environment                = var.environment
  location                   = var.location
  location_abbreviation      = var.location_abbreviation
  timezone                   = var.time_zone
  log_analytics_workspace_id = module.mgmt_monitor.log_analytics_workspace_id
  tags                       = local.tags
}

module "conn_virtual_network" {
  providers = { azurerm = azurerm.connected }
  source    = "../../_modules/virtual_network"
  # source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//virtual_network?ref=0.1.7"

  workload                      = "connected-aleksei"
  environment                   = var.environment
  location                      = var.location
  location_abbreviation         = var.location_abbreviation
  virtual_network_address_space = var.conn_virtual_network_address_space
  subnet_prefixes               = var.conn_subnet_prefixes
  tags                          = local.tags
}

##########################################Peerings##############################################################

resource "azurerm_virtual_network_peering" "connected-to-connectivity" {
  provider   = azurerm.connected
  depends_on = [time_sleep.wait_for_vnet_gateway]

  name                         = "peering-connected-to-connectivity"
  resource_group_name          = module.conn_virtual_network.resource_group_name
  virtual_network_name         = module.conn_virtual_network.virtual_network_name
  remote_virtual_network_id    = module.cnty_virtual_network.virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
}


#####################Route tables, Routes and RT associations####################

resource "azurerm_route_table" "conn_route_table" {
  provider = azurerm.connected

  name                = "rt-connected-aleksei"
  location            = module.conn_virtual_network.location
  resource_group_name = module.conn_virtual_network.resource_group_name
}

resource "azurerm_route" "connected_to_connectivity" {
  provider   = azurerm.connected
  depends_on = [module.cnty_firewall]

  name                   = "to-connectivity"
  resource_group_name    = module.conn_virtual_network.resource_group_name
  route_table_name       = azurerm_route_table.conn_route_table.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.cnty_firewall.firewall_private_ip
}

resource "azurerm_subnet_route_table_association" "conn_rt_association" {
  provider = azurerm.connected
  for_each = var.conn_subnet_prefixes

  subnet_id      = module.conn_virtual_network.subnet_id[each.key]
  route_table_id = azurerm_route_table.conn_route_table.id
}