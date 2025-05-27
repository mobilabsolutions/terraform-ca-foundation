idty_virtual_network_address_space = [
  "#{Identity_Vnet_Address_Space}#"
]

idty_subnet_prefixes = {
  #{Identity_Subnet_Prefixes}#
}

idty_subnet_delegations = {
  snet-dnsie-prod-001 = [{
    name = "Microsoft.Network.dnsResolvers"
    service_delegation = {
      name    = "Microsoft.Network/dnsResolvers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }]
  snet-dnsoe-prod-001 = [{
    name = "Microsoft.Network.dnsResolvers"
    service_delegation = {
      name    = "Microsoft.Network/dnsResolvers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }]
}

private_dns_zones = [
  #{Identity_Private_Dns_Zones}#
]

dns_forwarding_rules = {
  #{Identity_Dns_Forwarding_Rules}#
}