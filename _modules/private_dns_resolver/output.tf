output "dns_resource_group" {
  value = azurerm_resource_group.rg_dnspr.name

  description = "The name of the Resource Group."
}