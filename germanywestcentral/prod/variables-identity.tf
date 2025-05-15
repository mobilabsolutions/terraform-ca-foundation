variable "idty_virtual_network_address_space" {
  description = "(Required) The IP address space for the Virtual Network."

  type = list(string)
}

variable "idty_subnet_prefixes" {
  description = "(Required) The IP address ranges for Subnets of the Virtual Network."

  type = map(string)
}

variable "idty_subnet_delegations" {
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

variable "dns_forwarding_rules" {
  description = "Map of DNS forwarding rules"
  type        = map(list(string))
  default     = {}
}

variable "private_dns_zones" {
  description = "List of private DNS zones to be created."
  type        = list(string)
}