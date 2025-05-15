resource "azurerm_resource_group" "rg_vnet" {
  name     = "rg-network-${var.location_abbreviation}-${var.environment}-001"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "vnet" {

  name                = "vnet-${var.workload}-${var.location_abbreviation}-${var.environment}-001"
  resource_group_name = azurerm_resource_group.rg_vnet.name
  location            = azurerm_resource_group.rg_vnet.location
  address_space       = var.virtual_network_address_space
  tags                = var.tags
}

# resource "azurerm_subnet" "snet" {
#   for_each = var.subnets

#   name                 = each.key
#   address_prefixes     = [each.value.address_prefix]
#   resource_group_name  = azurerm_resource_group.rg_vnet.name
#   virtual_network_name = azurerm_virtual_network.vnet.name

#   dynamic "delegation" {
#     for_each = each.value.delegation
#     content {
#       name = delegation.value.name

#       service_delegation {
#         name    = delegation.value.service_delegation.name
#         actions = delegation.value.service_delegation.actions
#       }
#     }
#   }
# }

resource "azurerm_subnet" "snet" {
  for_each = var.subnet_prefixes

  name                 = each.key
  address_prefixes     = [each.value]
  resource_group_name  = azurerm_resource_group.rg_vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  dynamic "delegation" {
    for_each = lookup(var.subnet_delegations, each.key, [])
    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}