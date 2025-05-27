resource "azurerm_resource_group" "rg_backup_001" {
  name     = "rg-backup-${var.location_abbreviation}-${var.environment}-001"
  location = var.location
  tags     = var.tags
}

# resource "azurerm_resource_group" "rg_backup_snapshots_001" {
#   name     = "AzureBackupRG_${var.location}_1"
#   location = var.location
#   tags     = var.tags
# }

resource "azurerm_recovery_services_vault" "grs_vault_001" {
  name                = "rsv-grs-${var.workload}-${var.location_abbreviation}-${var.environment}-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_backup_001.name
  sku                 = "RS0"
  storage_mode_type   = "GeoRedundant"
  soft_delete_enabled = true

  # immutability                  = "Unlocked"
  # public_network_access_enabled = true
  # tags                          = var.tags
}

resource "azurerm_recovery_services_vault" "lrs_vault_001" {
  name                = "rsv-lrs-${var.workload}-${var.location_abbreviation}-${var.environment}-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_backup_001.name
  sku                 = "RS0"
  storage_mode_type   = "LocallyRedundant"
  soft_delete_enabled = true

  # immutability                  = "Unlocked"
  # public_network_access_enabled = true
  # tags                          = var.tags
}


resource "azurerm_backup_policy_vm" "backup_policy_vm_high_001" {
  name                = "bkpol-${var.workload}-vm-high-${var.location_abbreviation}-${var.environment}-001"
  resource_group_name = azurerm_resource_group.rg_backup_001.name
  recovery_vault_name = azurerm_recovery_services_vault.grs_vault_001.name
  timezone            = var.timezone

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 14
  }

  retention_weekly {
    count    = 2
    weekdays = ["Sunday"]
  }

  retention_monthly {
    count    = 12
    weekdays = ["Sunday"]
    weeks    = ["First"]
  }

  retention_yearly {
    count  = 2
    days   = [1]
    months = ["January"]
  }
}

resource "azurerm_backup_policy_vm" "backup_policy_vm_medium_001" {
  name                = "bkpol-${var.workload}-vm-medium-${var.location_abbreviation}-${var.environment}-001"
  resource_group_name = azurerm_resource_group.rg_backup_001.name
  recovery_vault_name = azurerm_recovery_services_vault.lrs_vault_001.name
  timezone            = var.timezone

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 14
  }

  retention_weekly {
    count    = 2
    weekdays = ["Sunday"]
  }

  retention_monthly {
    count    = 12
    weekdays = ["Sunday"]
    weeks    = ["First"]
  }

  retention_yearly {
    count  = 2
    days   = [1]
    months = ["January"]
  }
}

resource "azurerm_backup_policy_vm" "backup_policy_vm_low_001" {
  name                = "bkpol-${var.workload}-vm-low-${var.location_abbreviation}-${var.environment}-001"
  resource_group_name = azurerm_resource_group.rg_backup_001.name
  recovery_vault_name = azurerm_recovery_services_vault.lrs_vault_001.name
  timezone            = var.timezone

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 14
  }

  retention_weekly {
    count    = 2
    weekdays = ["Sunday"]
  }

  retention_monthly {
    count    = 12
    weekdays = ["Sunday"]
    weeks    = ["First"]
  }

  retention_yearly {
    count  = 2
    days   = [1]
    months = ["January"]
  }
}

resource "azurerm_backup_policy_vm_workload" "backup_policy_sql_high_001" {
  name                = "bkpol-${var.workload}-sql-high-${var.location_abbreviation}-${var.environment}-001"
  resource_group_name = azurerm_resource_group.rg_backup_001.name
  recovery_vault_name = azurerm_recovery_services_vault.grs_vault_001.name

  workload_type = "SQLDataBase"

  settings {
    time_zone           = var.timezone
    compression_enabled = false
  }

  protection_policy {
    policy_type = "Full"

    backup {
      frequency = "Weekly"
      time      = "23:00"
      weekdays  = ["Sunday"]
    }

    retention_weekly {
      count    = 12
      weekdays = ["Sunday"]
    }

    retention_monthly {
      count       = 6
      format_type = "Weekly"
      weeks       = ["First"]
      weekdays    = ["Sunday"]
    }

    retention_yearly {
      count       = 2
      format_type = "Weekly"
      months      = ["January"]
      weeks       = ["First"]
      weekdays    = ["Sunday"]
    }
  }

  protection_policy {
    policy_type = "Log"

    backup {
      frequency_in_minutes = 60
    }

    simple_retention {
      count = 30
    }
  }

  protection_policy {
    policy_type = "Differential"

    backup {
      frequency = "Weekly"
      time      = "23:00"
      weekdays  = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    }

    simple_retention {
      count = 30
    }
  }
}

resource "azurerm_backup_policy_vm_workload" "backup_policy_sql_medium_001" {
  name                = "bkpol-${var.workload}-sql-medium-${var.location_abbreviation}-${var.environment}-001"
  resource_group_name = azurerm_resource_group.rg_backup_001.name
  recovery_vault_name = azurerm_recovery_services_vault.lrs_vault_001.name

  workload_type = "SQLDataBase"

  settings {
    time_zone           = var.timezone
    compression_enabled = false
  }

  protection_policy {
    policy_type = "Full"

    backup {
      frequency = "Weekly"
      time      = "23:00"
      weekdays  = ["Sunday"]
    }

    retention_weekly {
      count    = 4
      weekdays = ["Sunday"]
    }

    retention_monthly {
      count       = 2
      format_type = "Weekly"
      weeks       = ["First"]
      weekdays    = ["Sunday"]
    }

    retention_yearly {
      count       = 1
      format_type = "Weekly"
      months      = ["January"]
      weekdays    = ["Sunday"]
      weeks       = ["First"]
    }
  }

  protection_policy {
    policy_type = "Log"

    backup {
      frequency_in_minutes = 60
    }

    simple_retention {
      count = 28
    }
  }

  protection_policy {
    policy_type = "Differential"

    backup {
      frequency = "Weekly"
      time      = "23:00"
      weekdays  = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    }

    simple_retention {
      count = 28
    }
  }
}

resource "azurerm_backup_policy_vm_workload" "backup_policy_sql_low_001" {
  name                = "bkpol-${var.workload}-sql-low-${var.location_abbreviation}-${var.environment}-001"
  resource_group_name = azurerm_resource_group.rg_backup_001.name
  recovery_vault_name = azurerm_recovery_services_vault.lrs_vault_001.name

  workload_type = "SQLDataBase"

  settings {
    time_zone           = var.timezone
    compression_enabled = false
  }

  protection_policy {
    policy_type = "Full"

    backup {
      frequency = "Weekly"
      time      = "23:00"
      weekdays  = ["Sunday"]
    }

    retention_weekly {
      count    = 4
      weekdays = ["Sunday"]
    }

    retention_monthly {
      count       = 2
      format_type = "Weekly"
      weeks       = ["First"]
      weekdays    = ["Sunday"]
    }

    retention_yearly {
      count       = 1
      format_type = "Weekly"
      months      = ["January"]
      weekdays    = ["Sunday"]
      weeks       = ["First"]
    }
  }

  protection_policy {
    policy_type = "Log"

    backup {
      frequency_in_minutes = 60
    }

    simple_retention {
      count = 28
    }
  }

  protection_policy {
    policy_type = "Differential"

    backup {
      frequency = "Weekly"
      time      = "23:00"
      weekdays  = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    }

    simple_retention {
      count = 28
    }
  }
}

resource "azurerm_backup_policy_file_share" "backup_policy_file_share_high_001" {
  name                = "bkpol-${var.workload}-file-high-${var.location_abbreviation}-${var.environment}-001"
  resource_group_name = azurerm_resource_group.rg_backup_001.name
  recovery_vault_name = azurerm_recovery_services_vault.grs_vault_001.name

  timezone = var.timezone

  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 30
  }

  retention_weekly {
    count    = 12
    weekdays = ["Sunday"]
  }

  retention_monthly {
    count    = 6
    weekdays = ["Sunday"]
    weeks    = ["First"]
  }

  retention_yearly {
    count    = 1
    weekdays = ["Sunday"]
    weeks    = ["First"]
    months   = ["January"]
  }
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_grs_001" {

  name                           = "mds-rsv-${var.workload}-grs-${var.location_abbreviation}-prd-001"
  target_resource_id             = azurerm_recovery_services_vault.grs_vault_001.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  enabled_log {
    category_group = "AllLogs"
  }

  metric {
    category = "Health"
  }
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting_lrs_001" {

  name                           = "mds-rsv-${var.workload}-lrs-${var.location_abbreviation}-prd-001"
  target_resource_id             = azurerm_recovery_services_vault.lrs_vault_001.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  enabled_log {
    category_group = "AllLogs"
  }

  metric {
    category = "AllMetrics"
  }
}
