resource "azurerm_public_ip" "pip_bastion_01" {

  name                = "pip-bas-${var.location_abbreviation}-${var.environment}-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"

  tags = var.tags
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bas-${var.workload}-${var.location_abbreviation}-${var.environment}-001"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "ipc-bas-${var.location_abbreviation}-${var.environment}-001"
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.pip_bastion_01.id
  }
  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_bastion_001" {
  name                           = "mds-bas-${var.workload}-${var.location_abbreviation}-prd-001"
  target_resource_id             = azurerm_bastion_host.bastion.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  enabled_log {
    category_group = "AllLogs"
  }

  metric {
    category = "AllMetrics"
  }
}