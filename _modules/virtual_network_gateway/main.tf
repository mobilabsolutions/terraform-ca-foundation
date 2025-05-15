resource "azurerm_public_ip" "pip_virtual_network_gateway_01" {

  name                = "pip-vgw-${var.location_abbreviation}-${var.environment}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"

  tags = var.tags
}

resource "azurerm_virtual_network_gateway" "vgw" {
  name                = "vgw-${var.workload}-${var.location_abbreviation}-${var.environment}-001"
  location            = var.location
  resource_group_name = var.resource_group_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active              = false
  enable_bgp                 = false
  sku                        = "VpnGw1"
  private_ip_address_enabled = true



  ip_configuration {
    name                          = "ipc-vgw-${var.location_abbreviation}-${var.environment}-001"
    public_ip_address_id          = azurerm_public_ip.pip_virtual_network_gateway_01.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.virtual_network_gateway_subnet_id
  }

  # tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_vgw_001" {
  name                           = "mds-vgw-${var.workload}-${var.location_abbreviation}-prd-001"
  target_resource_id             = azurerm_virtual_network_gateway.vgw.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  enabled_log {
    category_group = "AllLogs"
  }

  metric {
    category = "AllMetrics"
  }
}

resource "azurerm_local_network_gateway" "lgw" {
  name                = "lgw-${var.workload}-${var.location_abbreviation}-${var.environment}-001"
  location            = var.location
  resource_group_name = var.resource_group_name
  gateway_address     = var.local_network_gateway_ip_address
  address_space       = var.local_network_gateway_address_space
}

resource "azurerm_virtual_network_gateway_connection" "vgw_connection_001" {
  name                = "vgw-connection-${var.workload}-${var.location_abbreviation}-${var.environment}-001"
  location            = var.location
  resource_group_name = var.resource_group_name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vgw.id
  local_network_gateway_id   = azurerm_local_network_gateway.lgw.id

  shared_key = var.shared_key
}