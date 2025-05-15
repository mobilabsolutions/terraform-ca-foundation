idty_virtual_network_address_space = [
  "#{IdentityVnetAddressSpace}#"
]

idty_subnet_prefixes = {
  #{IdentitySubnetPrefixes}#
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
  #{IdentityPrivateDnsZones}#
]

dns_forwarding_rules = {
  #{IdentityDnsForwardingRules}#
}