output "application_gateway_public_ip_address" {
  value = azurerm_public_ip.pip_application_gateway_01.ip_address

  description = "The public IP address of the Azure Application Gateway."

}

output "application_gateway_id" {
  value = azurerm_application_gateway.application_gateway.id

  description = "The ID of the Azure Application Gateway."

}
