output "resource_group_name" {
  value = azurerm_resource_group.rg_vnet.name

  description = "The name of the Resource Group for Network."
}

output "resource_group_id" {
  value = azurerm_resource_group.rg_vnet.id

  description = "The name of the Resource Group for Network."
}

output "virtual_network_id" {
  value = azurerm_virtual_network.vnet.id

  description = "The ID of the Azure Virtual Network."
}

output "virtual_network_name" {
  value = azurerm_virtual_network.vnet.name

  description = "The name of the Azure Virtual Network."
}

output "location" {
  value = azurerm_resource_group.rg_vnet.location

  description = "The location/region of the Resource Group for Network."
}

output "subnet_id" {
  value = { for name, subnet in azurerm_subnet.snet : name => subnet.id }

  description = "The IDs of the Azure Subnets."

}