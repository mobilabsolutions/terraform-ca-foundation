output "virtual_network_gateway_public_ip_address" {
  value = azurerm_public_ip.pip_virtual_network_gateway_01.ip_address

  description = "The public IP address of the Azure Virtual Network Gateway."
}

output "virtual_network_gateway_id" {
  value = azurerm_virtual_network_gateway.vgw.id

  description = "The ID of the Azure Virtual Network Gateway."
}

# output "virtual_network_gateway_private_ip_address" {
#   value = azurerm_virtual_network_gateway.virtual_network_gateway.ip_configuration[0].private_ip_address

#   description = "The private IP address of the Azure Virtual Network Gateway."

# }

