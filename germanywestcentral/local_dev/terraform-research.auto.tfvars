rsch_virtual_network_address_space = [
  "#{Research_Vnet_Address_Space}#"
]

rsch_subnet_prefixes = {
  #{Research_Subnet_Prefixes}#
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
  #{Research_Action_Group_Email_Receivers}#
}

dns_forwarding_rules = {
  #{Research_Dns_Forwarding_Rules}#
}