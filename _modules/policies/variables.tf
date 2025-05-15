variable "location" {
  description = "(Required) Specifies the supported Azure location where the resources exist."
}

variable "allowed_tags" {
  description = <<EOT
  "(Required) List of allowed tags for Custom Policy Definitions of Required Tags on RG for Business Criticality, Data Confidentiality and Environment."
  
  Example structure:
  {
    "Data Confidentiality" = ["Public", "Internal", "Internal-Confidential", "Restricted"],
    "Environment"          = ["prd", "tst", "dev"],
    "Business Criticality" = ["Low", "Medium", "High", "Critical"]
  }
  EOT

  type = map(list(string))
}

variable "top_mg_id" {
  description = "(Required) Top level Management group ID used for the Policy Assigment."
}

variable "landing_zone_mg_id" {
  description = "(Required) Landing Zones Management group ID used for the Policy Assigment."
}