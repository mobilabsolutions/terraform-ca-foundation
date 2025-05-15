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

variable "virtual_network_gateway_subnet_id" {
  description = "(Required) The ID of the Azure Virtual Network Gateway Subnet."
}

variable "resource_group_name" {
  description = "(Required) The name of the Resource Group for Firewall."
}

variable "log_analytics_workspace_id" {
  description = "(Required) The Log Analytics Workspace ID of Management subscription."
}

variable "local_network_gateway_ip_address" {
  description = "(Required) The IP address of the Local Network Gateway (Public IP address of On-premisses network device)."
}

variable "local_network_gateway_address_space" {
  description = "(Required) The address space of the Local Network Gateway (On-premisses network address space)."

  type = list(string)
}

variable "shared_key" {
  description = "(Required) The shared key for the VPN gateway connection."
}