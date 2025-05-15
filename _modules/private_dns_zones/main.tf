resource "azurerm_resource_group" "rg_dns" {
  name     = "rg-private-dns-zones-${var.location_abbreviation}-${var.environment}-001"
  location = var.location
  tags     = var.tags
}

resource "azurerm_private_dns_zone" "pr_dns_zone" {
  for_each = toset(var.private_dns_zones)

  name                = each.value
  resource_group_name = azurerm_resource_group.rg_dns.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_vnet_link" {
  for_each = toset(var.private_dns_zones)

  name                  = "dns-link-to-${var.workload}"
  resource_group_name   = azurerm_resource_group.rg_dns.name
  private_dns_zone_name = azurerm_private_dns_zone.pr_dns_zone[each.value].name
  virtual_network_id    = var.virtual_network_id
}