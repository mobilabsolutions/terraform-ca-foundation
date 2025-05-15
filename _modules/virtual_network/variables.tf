variable "environment" {
  description = "(Required) The environment name for the Azure resources names composition."
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resources exist."
}

variable "location_abbreviation" {
  description = "(Required) The abbreviation for the location of the Azure resources."
}

variable "workload" {
  description = "(Required) The workload or subcription name for the Azure resources names composition."
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources."

  default = {}
}

variable "virtual_network_address_space" {
  description = "(Required) The IP address space for the Virtual Network."

  type = list(string)
}

# variable "subnets" {
#   description = "Map of subnets with their address prefixes and optional delegations."
#   type = map(object({
#     address_prefix = string
#     delegation = list(object({
#       name = string
#       service_delegation = object({
#         name    = string
#         actions = list(string)
#       })
#     }))
#   }))
#   default = {}
# }

variable "subnet_prefixes" {
  description = "(Required) The IP address ranges for Subnets of the Virtual Network."

  type = map(string)
}

variable "subnet_delegations" {
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