variable "cnty_virtual_network_address_space" {
  description = "(Required) The IP address space for the Virtual Network."

  type = list(string)
}

variable "cnty_subnet_prefixes" {
  description = "(Required) The IP address ranges for Subnets of the Virtual Network."

  type = map(string)
}

variable "cnty_subnet_delegations" {
  description = "Some subnets require Delegations, for instance, subnets of DNS resolver private endpoints"

  type = map(list(object({
    name = string
    service_delegation = object({
      name    = string
      actions = list(string)
    })
  })))
  default = {}
}

variable "local_network_gateway_ip_address" {
  description = "(Required) The IP address of the Local Network Gateway (Public IP address of On-premisses network device) to establish VPN connection."
}

variable "local_network_gateway_address_space" {
  description = "(Required) The address space of the Local Network Gateway (On-premisses network address space)."

  type = list(string)
}

variable "lgw_shared_key" {
  description = "(Required) The shared key for the VPN gateway connection."
}
