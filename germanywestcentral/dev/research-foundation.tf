data "azurerm_client_config" "research" {
  provider = azurerm.research
}

# module "rsch_backup" {
#   providers = { azurerm = azurerm.research }
#   # source     = "../../_modules/backup"
#   source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//backup?ref=0.1.7"

#   workload                   = "research-aleksei"
#   environment                = var.environment
#   location                   = var.location
#   location_abbreviation      = var.location_abbreviation
#   timezone                   = var.time_zone
#   log_analytics_workspace_id = module.rsch_monitor.log_analytics_workspace_id
#   tags                       = local.tags
# }

module "rsch_virtual_network" {
  providers = { azurerm = azurerm.research }
  source    = "../../_modules/virtual_network"
  # source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//virtual_network?ref=0.1.7"

  workload                      = "research-aleksei"
  environment                   = var.environment
  location                      = var.location
  location_abbreviation         = var.location_abbreviation
  virtual_network_address_space = var.rsch_virtual_network_address_space
  subnet_prefixes               = var.rsch_subnet_prefixes
  subnet_delegations            = var.rsch_subnet_delegations
  tags                          = local.tags
}

# module "rsch_monitor" {
#   providers = { azurerm = azurerm.research }
#   source    = "../../_modules/monitor"
#   # source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//monitor?ref=0.1.7"

#   workload              = "research-aleksei"
#   environment           = var.environment
#   location              = var.location
#   location_abbreviation = var.location_abbreviation
#   tags                  = local.tags
# }

# module "rsch_private_dns_resolver" {
#   providers = { azurerm = azurerm.research }
#   source    = "../../_modules/private_dns_resolver"
#   #  source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//private_dns_resolver?ref=0.1.7"

#   workload                  = "research-aleksei"
#   environment               = var.environment
#   location                  = var.location
#   location_abbreviation     = var.location_abbreviation
#   virtual_network_id        = module.rsch_virtual_network.virtual_network_id
#   dns_inbound_pe_subnet_id  = module.rsch_virtual_network.subnet_id["snet-dnsie-prod-001"]
#   dns_outbound_pe_subnet_id = module.rsch_virtual_network.subnet_id["snet-dnsoe-prod-001"]
#   dns_forwarding_rules      = var.dns_forwarding_rules
#   virtual_network_ids       = local.virtual_network_ids
#   tags                      = local.tags
# }

# module "rsch_update_research" {
#   providers = { azurerm = azurerm.research }
#   source    = "../../_modules/update_research"
#   # source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//update_research?ref=0.1.7"

#   environment                        = var.environment
#   workload                           = "research-aleksei"
#   location                           = var.location
#   location_abbreviation              = var.location_abbreviation
#   tags                               = local.tags
#   time_zone                          = var.time_zone
#   start_time                         = "23:00"
#   windows_classifications_to_include = ["Critical", "Security"]
#   linux_classifications_to_include   = ["Critical", "Security"]
# }

# module "rsch_alerts" {
#   providers = { azurerm = azurerm.research }

#   source = "../../_modules/alerts"
#   # source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//alerts?ref=0.1.7"

#   workload                   = "research-aleksei"
#   environment                = var.environment
#   location                   = var.location
#   location_abbreviation      = var.location_abbreviation
#   tags                       = local.tags
#   email_receivers            = var.action_group_email_receivers
#   subscription_id            = data.azurerm_client_config.research.subscription_id
#   log_analytics_workspace_id = module.rsch_monitor.log_analytics_workspace_id
# }

# module "rsch_policies" {
#   providers = { azurerm = azurerm.research }
#   source     = "../../_modules/policies"
#   # source = "git::https://dev.azure.com/MobiLab-Solutions-GmbH/Terraform-test/_git/TF-modules//policies?ref=0.1.7"

#   location           = var.location
#   allowed_tags       = local.allowed_tags_list
#   top_mg_id          = "Planum"
#   landing_zone_mg_id = "Planum"
# }

# ################################Peerings#########################################

# resource "azurerm_virtual_network_peering" "research-to-connectivity" {
#   provider   = azurerm.research
#   depends_on = [time_sleep.wait_for_vnet_gateway]

#   name                         = "peering-research-to-connectivity"
#   resource_group_name          = module.rsch_virtual_network.resource_group_name
#   virtual_network_name         = module.rsch_virtual_network.virtual_network_name
#   remote_virtual_network_id    = module.cnty_virtual_network.virtual_network_id
#   allow_virtual_network_access = true
#   allow_forwarded_traffic      = true
#   allow_gateway_transit        = false
#   use_remote_gateways          = true
# }

# #####################Route tables, Routes and RT associations####################

# resource "azurerm_route_table" "rsch_route_table" {
#   provider = azurerm.research

#   name                = "rt-research-aleksei"
#   location            = module.rsch_virtual_network.location
#   resource_group_name = module.rsch_virtual_network.resource_group_name
# }

# resource "azurerm_route" "research_to_connectivity" {
#   provider   = azurerm.research
#   depends_on = [module.cnty_firewall]

#   name                   = "to-connectivity"
#   resource_group_name    = module.rsch_virtual_network.resource_group_name
#   route_table_name       = azurerm_route_table.rsch_route_table.name
#   address_prefix         = "0.0.0.0/0"
#   next_hop_type          = "VirtualAppliance"
#   next_hop_in_ip_address = module.cnty_firewall.firewall_private_ip
# }

# resource "azurerm_subnet_route_table_association" "rsch_rt_association" {
#   provider = azurerm.research
#   for_each = var.rsch_subnets

#   subnet_id      = module.rsch_virtual_network.subnet_id[each.key]
#   route_table_id = azurerm_route_table.rsch_route_table.id
# }