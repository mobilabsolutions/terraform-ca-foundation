variable "rsch_virtual_network_address_space" {
  description = "(Required) The IP address space for the Virtual Network."

  type = list(string)
}

variable "rsch_subnet_prefixes" {
  description = "(Required) The IP address ranges for Subnets of the Virtual Network."

  type = map(string)
}

variable "rsch_subnet_delegations" {
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

variable "action_group_email_receivers" {
  description = "(Required) A list of email receivers for the action group."
  type        = map(string)
}

# variable "dns_forwarding_rules" {
#   description = "Map of DNS forwarding rules"
#   type = map(object({
#     domain_name        = string
#     target_dns_servers = list(string)
#   }))
#   default = {}
# }

variable "dns_forwarding_rules" {
  description = "Map of DNS forwarding rules"
  type        = map(list(string))
  default     = {}
}
