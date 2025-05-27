variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "location" {
  description = "(Required) The location of the Resource Group."
}

variable "location_abbreviation" {
  description = "(Required) The abbreviation for the location of the Azure resources."
}

variable "environment" {
  description = "(Required) The environment of the Azure resources."
}

variable "time_zone" {
  description = "(Required) Specifies the timezone."
  type        = string
}