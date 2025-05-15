resource "azurerm_management_group_policy_assignment" "main_policy_initiative_assignment" {
  name                 = "main_assigment_001"
  display_name         = "Aleksei Test - Main Management Group policy initiative"
  description          = "Assignment of policy Initiative for Main Management group"
  policy_definition_id = azurerm_policy_set_definition.main_mg_mobilab_initiative.id
  management_group_id  = "/providers/Microsoft.Management/managementGroups/${var.top_mg_id}"
  location             = var.location
  enforce              = false

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_management_group_policy_assignment" "landing_zones_policy_initiative_assignment" {
  name                 = "lz_assigment_001"
  display_name         = "Aleksei Test - Landing Zones Management Group policy initiative"
  description          = "Assignment of policy Initiative for Landing Zones Management group"
  policy_definition_id = azurerm_policy_set_definition.main_mg_mobilab_initiative.id
  management_group_id  = "/providers/Microsoft.Management/managementGroups/${var.landing_zone_mg_id}"
  location             = var.location
  enforce              = false

  identity {
    type = "SystemAssigned"
  }
}