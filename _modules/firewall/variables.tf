variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources."

  default = {}
}

variable "location" {
  description = "(Required) Specifies the supported Azure location where the resources exist."
}

variable "location_abbreviation" {
  description = "(Required) The abbreviation for the location of the Azure resources."
}

variable "virtual_network_name" {
  description = "(Required) The Name of the Virtual Network where the Firewall should be created."
}

variable "workload" {
  description = "(Required) The workload or subcription name for the Azure resources names composition."
}

variable "environment" {
  description = "(Required) The environment name for the Azure resources names composition."
}

variable "firewall_enabled" {
  description = "(Required) Specifies if the Azure Firewall should be enabled."

  type    = bool
  default = false
}

variable "firewall_subnet_id" {
  description = "(Required) The ID of the Azure Firewall Subnet."
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group for Firewall."

}

variable "log_analytics_workspace_id" {
  description = "(Required) The Log Analytics Workspace ID of Management subscription."

}