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

variable "virtual_network_id" {
  description = "(Required) The ID of the Virtual Network."
}

variable "dns_inbound_pe_subnet_id" {
  description = "(Required) The ID of the DNS Inbound Private Endpoint Subnet."
}

variable "dns_outbound_pe_subnet_id" {
  description = "(Required) The ID of the DNS Outbound Private Endpoint Subnet."

}

variable "dns_forwarding_rules" {
  description = "List of domain names and DNS servers IP addresses for DNS resolver rules"
  type        = map(list(string))
  default     = {}
}

variable "virtual_network_ids" {
  description = "Map of Virtual Network IDs to be used in DNS Resolver Virtual network links"
  type        = map(string)
  default     = {}
}