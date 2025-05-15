output "grs_vault_001_id" {
  value = azurerm_recovery_services_vault.grs_vault_001.name

  description = "value of the GRS Recovery Services Vault ID"
}

output "lrs_vault_001_id" {
  value = azurerm_recovery_services_vault.lrs_vault_001.name

  description = "value of the LRS Recovery Services Vault ID"
}

output "grs_vault_001_name" {
  value = azurerm_recovery_services_vault.grs_vault_001.name

  description = "value of the GRS Recovery Services Vault Name"
}

output "lrs_vault_001_name" {
  value = azurerm_recovery_services_vault.lrs_vault_001.name

  description = "value of the LRS Recovery Services Vault Name"
}