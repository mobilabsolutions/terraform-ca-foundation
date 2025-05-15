locals {
  backend_address_pool_name      = "beap-agw-${var.location_abbreviation}-${var.environment}-001"
  frontend_port_name             = "feport-agw-${var.location_abbreviation}-${var.environment}-001"
  frontend_ip_configuration_name = "feipc-agw-${var.location_abbreviation}-${var.environment}-001"
  backend_http_setting_name      = "behttpset-agw-${var.location_abbreviation}-${var.environment}-001"
  http_listener_name             = "httplstn-agw-${var.location_abbreviation}-${var.environment}-001"
  request_routing_rule_name      = "rqrt-agw-${var.location_abbreviation}-${var.environment}-001"
  redirect_configuration_name    = "rdrcfg-agw-${var.location_abbreviation}-${var.environment}-001"
}

resource "azurerm_public_ip" "pip_application_gateway_01" {

  name                = "pip-agw-${var.location_abbreviation}-${var.environment}-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"

  tags = var.tags
}

resource "azurerm_application_gateway" "application_gateway" {
  name                = "agw-${var.workload}-${var.location_abbreviation}-${var.environment}-001"
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name = "Standard_v2"
    tier = "Standard_v2"
    # capacity = 2
  }

  autoscale_configuration {
    min_capacity = 0
    # max_capacity = 32
  }

  gateway_ip_configuration {
    name      = "ipc-agw-${var.location_abbreviation}-${var.environment}-001"
    subnet_id = var.application_gateway_subnet_id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.pip_application_gateway_01.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.backend_http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = local.http_listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.backend_http_setting_name
  }
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_application_gateway_001" {
  name                           = "mds-agw-${var.workload}-${var.location_abbreviation}-prd-001"
  target_resource_id             = azurerm_application_gateway.application_gateway.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  enabled_log {
    category_group = "AllLogs"
  }

  metric {
    category = "AllMetrics"
  }
}