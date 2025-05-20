rsch_virtual_network_address_space = [
  "#{ResearchVnetAddressSpace}#"
]

rsch_subnet_prefixes = {
  #{ResearchSubnetPrefixes}#
}

rsch_subnet_delegations = {
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

action_group_email_receivers = {
  #{ResearchActionGroupEmailReceivers}#
}

dns_forwarding_rules = {
  #{ResearchDnsForwardingRules}#
}