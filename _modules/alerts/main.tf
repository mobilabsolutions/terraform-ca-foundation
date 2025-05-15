resource "azurerm_resource_group" "rg_alerts" {
  name     = "rg-alerts-${var.location_abbreviation}-${var.environment}-001"
  location = var.location
  tags     = var.tags
}

resource "azurerm_monitor_action_group" "ag-operations" {
  name                = "Operations-ActionGroup"
  resource_group_name = azurerm_resource_group.rg_alerts.name
  short_name          = "OperationsAG"

  dynamic "email_receiver" {
    for_each = var.email_receivers
    content {
      name          = email_receiver.key
      email_address = email_receiver.value
    }
  }
}

resource "azurerm_monitor_metric_alert" "metric_alert_vm_cpu_utilization_high" {
  name                = "CPU Utilization is High"
  resource_group_name = azurerm_resource_group.rg_alerts.name
  description         = "Metrics based Alert when the VM CPU utilization is above 80% for the last 15 minutes"

  scopes                   = ["/subscriptions/${var.subscription_id}"]
  target_resource_type     = "Microsoft.Compute/virtualMachines"
  target_resource_location = azurerm_resource_group.rg_alerts.location

  severity    = 2
  frequency   = "PT5M"
  window_size = "PT15M"
  enabled     = true

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.ag-operations.id
  }
}

resource "azurerm_monitor_metric_alert" "metric_alert_vm_cpu_utilization_critical" {
  name                = "CPU Utilization is Critical"
  resource_group_name = azurerm_resource_group.rg_alerts.name
  description         = "Metrics based Alert when the VM CPU utilization is above 90% for the last 15 minutes"

  scopes                   = ["/subscriptions/${var.subscription_id}"]
  target_resource_type     = "Microsoft.Compute/virtualMachines"
  target_resource_location = azurerm_resource_group.rg_alerts.location

  severity    = 1
  frequency   = "PT5M"
  window_size = "PT15M"
  enabled     = true

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 90
  }

  action {
    action_group_id = azurerm_monitor_action_group.ag-operations.id
  }
}

resource "azurerm_monitor_metric_alert" "metric_alert_vm_memory_utilization_high" {
  name                = "Memory Utilization is High"
  resource_group_name = azurerm_resource_group.rg_alerts.name
  description         = "Metrics based Alert when the Free Memory less than 20% for the last 15 minutes"

  scopes                   = ["/subscriptions/${var.subscription_id}"]
  target_resource_type     = "Microsoft.Compute/virtualMachines"
  target_resource_location = azurerm_resource_group.rg_alerts.location

  severity    = 2
  frequency   = "PT5M"
  window_size = "PT15M"
  enabled     = true

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Available Memory Percentage"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 20
  }

  action {
    action_group_id = azurerm_monitor_action_group.ag-operations.id
  }
}

resource "azurerm_monitor_metric_alert" "metric_alert_vm_memory_utilization_critical" {
  name                = "Memory Utilization is Critical"
  resource_group_name = azurerm_resource_group.rg_alerts.name
  description         = "Metrics based Alert when the Free Memory less than 10% for the last 15 minutes"

  scopes                   = ["/subscriptions/${var.subscription_id}"]
  target_resource_type     = "Microsoft.Compute/virtualMachines"
  target_resource_location = azurerm_resource_group.rg_alerts.location

  severity    = 1
  frequency   = "PT5M"
  window_size = "PT15M"
  enabled     = true

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Available Memory Percentage"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 10
  }

  action {
    action_group_id = azurerm_monitor_action_group.ag-operations.id
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "query_alert_vm_disk_space_high" {
  name                = "VM Disk space usage is High"
  description         = "Alert when VM Disk Free Space is less than 20 percent"
  location            = azurerm_resource_group.rg_alerts.location
  resource_group_name = azurerm_resource_group.rg_alerts.name

  scopes                  = [var.log_analytics_workspace_id]
  severity                = 2
  evaluation_frequency    = "PT5M"
  window_duration         = "PT1H"
  enabled                 = true
  auto_mitigation_enabled = true

  criteria {
    query                   = <<-QUERY
      InsightsMetrics
      | where TimeGenerated >= ago(15m)
      | where Namespace == "LogicalDisk" and Name == "FreeSpacePercentage"
      | summarize MinimalValue = min(Val) by Computer, Namespace, Name, Tags
      | where MinimalValue <= 20
      | project TimeGenerated=ago(0h), Computer, Namespace, Name, Tags, MinimalValue
      QUERY
    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    dimension {
      name     = "Computer"
      operator = "Include"
      values   = ["*"]
    }
    dimension {
      name     = "Tags"
      operator = "Include"
      values   = ["*"]
    }

    dimension {
      name     = "MinimalValue"
      operator = "Include"
      values   = ["*"]
    }
    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.ag-operations.id]
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "query_alert_vm_disk_space_critical" {
  name                = "VM Disk space usage is Critical"
  description         = "Alert when VM Disk Free Space is less than 10 percent"
  location            = azurerm_resource_group.rg_alerts.location
  resource_group_name = azurerm_resource_group.rg_alerts.name

  scopes                  = [var.log_analytics_workspace_id]
  severity                = 1
  evaluation_frequency    = "PT5M"
  window_duration         = "PT1H"
  enabled                 = true
  auto_mitigation_enabled = true

  criteria {
    query                   = <<-QUERY
      InsightsMetrics
      | where TimeGenerated >= ago(15m)
      | where Namespace == "LogicalDisk" and Name == "FreeSpacePercentage"
      | summarize MinimalValue = min(Val) by Computer, Namespace, Name, Tags
      | where MinimalValue <= 10
      | project TimeGenerated=ago(0h), Computer, Namespace, Name, Tags, MinimalValue
      QUERY
    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    dimension {
      name     = "Computer"
      operator = "Include"
      values   = ["*"]
    }
    dimension {
      name     = "Tags"
      operator = "Include"
      values   = ["*"]
    }

    dimension {
      name     = "MinimalValue"
      operator = "Include"
      values   = ["*"]
    }
    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.ag-operations.id]
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "query_alert_failed_backup_jobs" {
  name                = "Scheduled Backup Jobs failed"
  description         = "Alert when Scheduled Backup Jobs have failed state"
  location            = azurerm_resource_group.rg_alerts.location
  resource_group_name = azurerm_resource_group.rg_alerts.name

  scopes                  = [var.log_analytics_workspace_id]
  severity                = 2
  evaluation_frequency    = "PT6H"
  window_duration         = "P1D"
  enabled                 = true
  auto_mitigation_enabled = true

  criteria {
    query                   = <<-QUERY
      AddonAzureBackupJobs 
      |where JobFailureCode != "Success" and AdHocOrScheduledJob == "Scheduled"
      |project TimeGenerated, RSV_Name = tostring(split(ResourceId, "/VAULTS/", 1)), JobStartDateTime, Resource=tostring(split(BackupItemUniqueId,";", 4)), JobFailureCode, JobStatus
      QUERY
    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0

    dimension {
      name     = "RSV_Name"
      operator = "Include"
      values   = ["*"]
    }
    dimension {
      name     = "Resource"
      operator = "Include"
      values   = ["*"]
    }

    dimension {
      name     = "JobFailureCode"
      operator = "Include"
      values   = ["*"]
    }
    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }

  action {
    action_groups = [azurerm_monitor_action_group.ag-operations.id]
  }
}

