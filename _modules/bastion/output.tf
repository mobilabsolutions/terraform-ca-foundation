output "bastion_public_ip_address" {
  value = azurerm_public_ip.pip_bastion_01.ip_address

  description = "The public IP address of the Azure Bastion."

}

output "bastion_id" {
  value = azurerm_bastion_host.bastion.id

  description = "The ID of the Azure Bastion."
}