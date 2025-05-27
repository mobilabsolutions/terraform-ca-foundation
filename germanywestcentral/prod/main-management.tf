data "azurerm_client_config" "management" {
  provider = azurerm.management
}

module "mgmt_backup" {
  providers = { azurerm = azurerm.management }
  source    = "../../_modules/backup"
  #  source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//backup?ref=0.1.7"

  workload                   = "management-aleksei"
  environment                = var.environment
  location                   = var.location
  location_abbreviation      = var.location_abbreviation
  timezone                   = var.time_zone
  log_analytics_workspace_id = module.mgmt_monitor.log_analytics_workspace_id
  tags                       = local.tags
}

module "mgmt_virtual_network" {
  providers = { azurerm = azurerm.management }
  source    = "../../_modules/virtual_network"
  #  source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//virtual_network?ref=0.1.7"

  workload                      = "management-aleksei"
  environment                   = var.environment
  location                      = var.location
  location_abbreviation         = var.location_abbreviation
  virtual_network_address_space = var.mgmt_virtual_network_address_space
  subnet_prefixes               = var.mgmt_subnet_prefixes
  tags                          = local.tags
}

module "mgmt_monitor" {
  providers = { azurerm = azurerm.management }
  source    = "../../_modules/monitor"
  #  source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//monitor?ref=0.1.7"

  workload              = "management-aleksei"
  environment           = var.environment
  location              = var.location
  location_abbreviation = var.location_abbreviation
  tags                  = local.tags
}


module "mgmt_update_management" {
  providers = { azurerm = azurerm.management }
  source    = "../../_modules/update_management"
  #  source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//update_management?ref=0.1.7"

  environment                        = var.environment
  workload                           = "management-aleksei"
  location                           = var.location
  location_abbreviation              = var.location_abbreviation
  tags                               = local.tags
  time_zone                          = var.time_zone
  start_time                         = "23:00"
  windows_classifications_to_include = ["Critical", "Security"]
  linux_classifications_to_include   = ["Critical", "Security"]
}

module "mgmt_alerts" {
  providers = { azurerm = azurerm.management }

  source = "../../_modules/alerts"
  #  source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//alerts?ref=0.1.7"

  environment                = var.environment
  workload                   = "management-aleksei"
  location                   = var.location
  location_abbreviation      = var.location_abbreviation
  tags                       = local.tags
  email_receivers            = var.action_group_email_receivers
  subscription_id            = data.azurerm_client_config.management.subscription_id
  log_analytics_workspace_id = module.mgmt_monitor.log_analytics_workspace_id
}

module "mgmt_policies" {
  providers = { azurerm = azurerm.management }
  source    = "../../_modules/policies"
  # source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//policies?ref=0.1.7"

  location           = var.location
  allowed_tags       = local.allowed_tags_list
  top_mg_id          = "Planum"
  landing_zone_mg_id = "Planum"
}

################################Peerings#########################################

resource "azurerm_virtual_network_peering" "management-to-connectivity" {
  provider   = azurerm.management
  depends_on = [time_sleep.wait_for_vnet_gateway]

  name                         = "peering-management-to-connectivity"
  resource_group_name          = module.mgmt_virtual_network.resource_group_name
  virtual_network_name         = module.mgmt_virtual_network.virtual_network_name
  remote_virtual_network_id    = module.cnty_virtual_network.virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = true
}

#####################Route tables, Routes and RT associations####################

resource "azurerm_route_table" "mgmt_route_table" {
  provider = azurerm.management

  name                = "rt-management-aleksei"
  location            = module.mgmt_virtual_network.location
  resource_group_name = module.mgmt_virtual_network.resource_group_name
}

resource "azurerm_route" "management_to_connectivity" {
  provider   = azurerm.management
  depends_on = [module.cnty_firewall]

  name                   = "to-connectivity"
  resource_group_name    = module.mgmt_virtual_network.resource_group_name
  route_table_name       = azurerm_route_table.mgmt_route_table.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = module.cnty_firewall.firewall_private_ip
}

resource "azurerm_subnet_route_table_association" "mgmt_rt_association" {
  provider = azurerm.management
  for_each = var.mgmt_subnet_prefixes

  subnet_id      = module.mgmt_virtual_network.subnet_id[each.key]
  route_table_id = azurerm_route_table.mgmt_route_table.id
}