resource "azurerm_public_ip" "pip_firewall_01" {

  name                = "pip-afw-${var.location_abbreviation}-${var.environment}-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"

  tags = var.tags
}

resource "azurerm_firewall" "firewall" {
  depends_on = [azurerm_public_ip.pip_firewall_01]

  name                = "afw-${var.workload}-${var.location_abbreviation}-${var.environment}-001"
  location            = azurerm_public_ip.pip_firewall_01.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = "ipc-afw-${var.location_abbreviation}-${var.environment}-001"
    subnet_id            = var.firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.pip_firewall_01.id
  }
  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_firewall_001" {
  name                           = "mds-agw-${var.workload}-${var.location_abbreviation}-prd-001"
  target_resource_id             = azurerm_firewall.firewall.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  enabled_log {
    category_group = "AllLogs"
  }

  metric {
    category = "AllMetrics"
  }
}