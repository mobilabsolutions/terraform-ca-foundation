output "resource_group_name" {
  value = azurerm_resource_group.rg_alerts.name

  description = "The name of the Resource Group for Network."
}

output "location" {
  value = azurerm_resource_group.rg_alerts.location

  description = "The location/region of the Resource Group for Network."
}