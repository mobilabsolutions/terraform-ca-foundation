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

variable "time_zone" {
  description = "(Required) Specifies the timezone."
  type        = string
  default     = "Central European Standard Time"

}

variable "windows_classifications_to_include" {
  description = "(Required) The Windows classifications to include."
  type        = list(string)
  default     = []

}

variable "windows_kb_numbers_to_exclude" {
  description = "(Required) The Windows KB numbers to exclude."
  type        = list(string)
  default     = []
}

variable "windows_kb_numbers_to_include" {
  description = "(Required) The Windows KB numbers to include."
  type        = list(string)
  default     = []
}

variable "linux_classifications_to_include" {
  description = "(Required) The Linux classifications to include."
  type        = list(string)
}

variable "linux_package_names_mask_to_exclude" {
  description = "(Required) The Linux package names mask to exclude."
  type        = list(string)
  default     = []
}

variable "linux_package_names_mask_to_include" {
  description = "(Required) The Linux package names mask to include."
  type        = list(string)
  default     = []
}

variable "start_time" {
  description = "(Required) The start time for the maintenance configuration."
  type        = string
}