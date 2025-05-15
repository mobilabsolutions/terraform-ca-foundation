resource "azurerm_resource_group" "rg_update_management" {
  name     = "rg-update-${var.location_abbreviation}-${var.environment}-001"
  location = var.location
  tags     = var.tags
}

resource "azurerm_maintenance_configuration" "mc_non_prod" {

  name                = "mc-update-${var.location_abbreviation}-nprod-001"
  resource_group_name = azurerm_resource_group.rg_update_management.name
  location            = azurerm_resource_group.rg_update_management.location
  scope               = "InGuestPatch"
  window {
    duration        = "03:55"
    recur_every     = "1Month Second Tuesday Offset4"
    start_date_time = formatdate("YYYY-MM-DD' ${var.start_time}'", timestamp())
    time_zone       = var.time_zone
  }

  install_patches {
    linux {
      classifications_to_include    = var.linux_classifications_to_include
      package_names_mask_to_exclude = var.linux_package_names_mask_to_exclude
      package_names_mask_to_include = var.linux_package_names_mask_to_include
    }
    windows {
      classifications_to_include = var.windows_classifications_to_include
      kb_numbers_to_exclude      = var.windows_kb_numbers_to_exclude
      kb_numbers_to_include      = var.windows_kb_numbers_to_include
    }
    reboot = "IfRequired"
  }
  in_guest_user_patch_mode = "User"
  tags                     = var.tags
}

resource "azurerm_maintenance_configuration" "mc_prod" {

  name                = "mc-update-${var.location_abbreviation}-prod-001"
  resource_group_name = azurerm_resource_group.rg_update_management.name
  location            = azurerm_resource_group.rg_update_management.location
  scope               = "InGuestPatch"
  window {
    duration        = "03:55"
    recur_every     = "1Month Third Tuesday Offset4"
    start_date_time = formatdate("YYYY-MM-DD' ${var.start_time}'", timestamp())
    time_zone       = var.time_zone
  }

  install_patches {
    linux {
      classifications_to_include    = var.linux_classifications_to_include
      package_names_mask_to_exclude = var.linux_package_names_mask_to_exclude
      package_names_mask_to_include = var.linux_package_names_mask_to_include
    }
    windows {
      classifications_to_include = var.windows_classifications_to_include
      kb_numbers_to_exclude      = var.windows_kb_numbers_to_exclude
      kb_numbers_to_include      = var.windows_kb_numbers_to_include
    }
    reboot = "Never"
  }
  in_guest_user_patch_mode = "User"
  tags                     = var.tags
}
