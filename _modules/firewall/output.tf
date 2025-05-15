output "firewall_public_ip_address" {
  value = azurerm_public_ip.pip_firewall_01.ip_address

  description = "The public IP address of the Azure Firewall."
}

output "firewall_id" {
  value = azurerm_firewall.firewall.id

  description = "The ID of the Azure Firewall."
}

output "firewall_private_ip" {
  value = azurerm_firewall.firewall.ip_configuration[0].private_ip_address

  description = "The private IP address of the Azure Firewall."

}