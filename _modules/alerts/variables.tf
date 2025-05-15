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

variable "email_receivers" {
  description = "(Required) A list of email receivers for the action group."
  type        = map(string)
}

variable "subscription_id" {
  description = "(Required) The subscription ID for the Azure resources."
  type        = string

}

variable "log_analytics_workspace_id" {
  description = "(Required) The Log Analitycs Workspace ID for the Azure resources."
  type        = string
}
