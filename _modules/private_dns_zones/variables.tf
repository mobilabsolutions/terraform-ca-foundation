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

variable "private_dns_zones" {
  description = "List of private DNS zones to be created."
  type        = list(string)
}