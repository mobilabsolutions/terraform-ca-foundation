resource "azurerm_resource_group" "rg_monitor" {
  name     = "rg-monitor-${var.location_abbreviation}-${var.environment}-001"
  location = var.location
  tags     = var.tags
}

resource "azurerm_log_analytics_workspace" "log_monitor" {
  name                = "log-${var.workload}-${var.location_abbreviation}-${var.environment}-001"
  location            = azurerm_resource_group.rg_monitor.location
  resource_group_name = azurerm_resource_group.rg_monitor.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "time_sleep" "wait_for_log_analytics_workspace_tables_are_ready" {
  # Need to Wait for the Log Analytics workspace tables to be ready before creating the DCR, because the DCR creation will fail if the tables are not ready yet.  

  depends_on      = [azurerm_log_analytics_workspace.log_monitor]
  create_duration = "90s"
}

resource "azurerm_monitor_data_collection_rule" "dcr_windows" {
  depends_on = [time_sleep.wait_for_log_analytics_workspace_tables_are_ready]

  name                = "dcr-windows-${var.location_abbreviation}-${var.environment}-001"
  resource_group_name = azurerm_resource_group.rg_monitor.name
  location            = azurerm_resource_group.rg_monitor.location
  description         = "Data Collection Rule for Windows Azure Virtual Machines"
  kind                = "Windows"
  tags                = var.tags

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.log_monitor.id
      name                  = azurerm_log_analytics_workspace.log_monitor.name
    }
  }

  data_flow {
    streams      = ["Microsoft-Event", "Microsoft-Perf", "Microsoft-InsightsMetrics"]
    destinations = [azurerm_log_analytics_workspace.log_monitor.name]
  }

  data_sources {
    performance_counter {
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "\\Processor Information(_Total)\\% Processor Time",
        "\\Memory\\% Committed Bytes In Use",
        "\\Memory\\Available Bytes",
        "\\LogicalDisk(*)\\% Free Space",
        "\\LogicalDisk(*)\\Free Megabytes",
        "\\LogicalDisk(*)\\Avg. Disk Queue Length",
        "\\LogicalDisk(*)\\Avg. Disk sec/Transfer"
      ]
      name = "perfCounterDataSource60"
    }

    windows_event_log {
      streams = ["Microsoft-Event"]
      x_path_queries = [
        "Application!*[System[(Level=1 or Level=2 or Level=3)]]",
        "System!*[System[(Level=1 or Level=2 or Level=3)]]"
      ]
      name = "eventLogsDataSource"
    }

    performance_counter {
      streams                       = ["Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "\\VmInsights\\DetailedMetrics"
      ]
      name = "VMInsightsPerfCounters"
    }
  }
}

resource "azurerm_monitor_data_collection_rule" "dcr_linux" {
  depends_on = [time_sleep.wait_for_log_analytics_workspace_tables_are_ready]

  name                = "dcr-linux-${var.location_abbreviation}-${var.environment}-001"
  resource_group_name = azurerm_resource_group.rg_monitor.name
  location            = azurerm_resource_group.rg_monitor.location
  description         = "Data Collection Rule for Linux Azure Virtual Machines"
  kind                = "Linux"
  tags                = var.tags

  destinations {
    log_analytics {
      workspace_resource_id = azurerm_log_analytics_workspace.log_monitor.id
      name                  = azurerm_log_analytics_workspace.log_monitor.name
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog", "Microsoft-Perf", "Microsoft-InsightsMetrics"]
    destinations = [azurerm_log_analytics_workspace.log_monitor.name]
  }

  data_sources {
    performance_counter {
      name                          = "perfCounterDataSource60"
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "Processor(*)\\% Processor Time",
        "Memory(*)\\% Used Memory",
        "Memory(*)\\Used Memory MBytes",
        "Memory(*)\\% Used Swap Space",
        "Memory(*)\\Used MBytes Swap Space",
        "Logical Disk(*)\\% Used Inodes",
        "Logical Disk(*)\\% Used Space",
        "Logical Disk(*)\\Free Megabytes"
      ]
    }

    syslog {
      name    = "sysLogsDataSource"
      streams = ["Microsoft-Syslog"]
      facility_names = [
        "daemon",
        "kern",
        "syslog",
        "user"
      ]
      log_levels = [
        "Warning",
        "Error",
        "Critical",
        "Alert",
        "Emergency"
      ]
    }
    performance_counter {
      streams                       = ["Microsoft-InsightsMetrics"]
      sampling_frequency_in_seconds = 60
      counter_specifiers = [
        "\\VmInsights\\DetailedMetrics"
      ]
      name = "VMInsightsPerfCounters"
    }
  }
}