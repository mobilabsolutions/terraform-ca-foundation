output "resource_group_name" {
  value = azurerm_resource_group.rg_monitor.name

  description = "The name of the Resource Group for Network."
}

output "location" {
  value = azurerm_resource_group.rg_monitor.location

  description = "The location/region of the Resource Group for Network."
}

output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.log_monitor.id

  description = "The ID of the Log Analytics Workspace."
}