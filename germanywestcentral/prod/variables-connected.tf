variable "conn_virtual_network_address_space" {
  description = "(Required) The IP address space for the Virtual Network."

  type = list(string)
}

variable "conn_subnet_prefixes" {
  description = "(Required) The IP address ranges for Subnets of the Virtual Network."

  type = map(string)
}

variable "conn_subnet_delegations" {
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