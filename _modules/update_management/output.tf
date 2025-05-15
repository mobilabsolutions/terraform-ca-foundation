output "resource_group_name" {
  value = azurerm_resource_group.rg_update_management.name

  description = "The name of the Resource Group for Network."
}

output "location" {
  value = azurerm_resource_group.rg_update_management.location

  description = "The location/region of the Resource Group for Network."
}