variable "location" {
  description = "(Required) The Azure Region where the Azure resources should exist."
}

variable "location_abbreviation" {
  description = "(Required) The Azure Region Abbreviation."
}

variable "workload" {
  description = "(Required) The name of the Subscription."
}

variable "environment" {
  description = "(Required) The environment of the Azure resources."
}

variable "timezone" {
  description = "(Required) Specifies the timezone."
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resources."
  default     = {}
}

variable "log_analytics_workspace_id" {
  description = "(Required) The Log Analytics Workspace ID of Management subscription to store Diagnostic settings of Recovery Service Vaults."
}