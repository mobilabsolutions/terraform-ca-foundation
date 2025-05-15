resource "azurerm_resource_group" "rg_dnspr" {
  name     = "rg-private-dns-resolver-${var.location_abbreviation}-${var.environment}-001"
  location = var.location
  tags     = var.tags
}

resource "azurerm_private_dns_resolver" "dnspr" {
  name                = "dnspr-${var.workload}-${var.location_abbreviation}-${var.environment}-001"
  resource_group_name = azurerm_resource_group.rg_dnspr.name
  location            = azurerm_resource_group.rg_dnspr.location
  virtual_network_id  = var.virtual_network_id
  tags                = var.tags
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "inbound" {
  name                    = "in-${var.workload}-${var.location_abbreviation}-${var.environment}-001"
  private_dns_resolver_id = azurerm_private_dns_resolver.dnspr.id
  location                = azurerm_private_dns_resolver.dnspr.location
  ip_configurations {
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = var.dns_inbound_pe_subnet_id
  }
  tags = var.tags
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "outbound" {
  name                    = "out-${var.workload}-${var.location_abbreviation}-${var.environment}-001"
  private_dns_resolver_id = azurerm_private_dns_resolver.dnspr.id
  location                = azurerm_private_dns_resolver.dnspr.location
  subnet_id               = var.dns_outbound_pe_subnet_id
  tags                    = var.tags
}

resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "dnsfrs" {
  name                                       = "dnsfrs-${var.workload}-${var.location_abbreviation}-${var.environment}-001"
  resource_group_name                        = azurerm_resource_group.rg_dnspr.name
  location                                   = azurerm_resource_group.rg_dnspr.location
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.outbound.id]
  tags                                       = var.tags
}

resource "azurerm_private_dns_resolver_forwarding_rule" "dnsfr" {
  for_each = var.dns_forwarding_rules

  name                      = trim(replace(each.key, ".", "_"), "_")
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.dnsfrs.id
  domain_name               = each.key
  enabled                   = true

  dynamic "target_dns_servers" {
    for_each = each.value
    iterator = dns_server
    content {
      ip_address = dns_server.value
      port       = 53
    }
  }
}

resource "azurerm_private_dns_resolver_virtual_network_link" "dnspr_vnl" {
  for_each = var.virtual_network_ids

  name                      = "dnspr-vnl-${each.key}"
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.dnsfrs.id
  virtual_network_id        = each.value
}