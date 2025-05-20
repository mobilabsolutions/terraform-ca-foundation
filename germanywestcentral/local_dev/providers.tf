terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.22.0"
    }
  }
  # backend "azurerm" {
  #   subscription_id = "#{SubscriptionIdManagement}#"
  # }

  required_version = ">= 1.11.0"
}

provider "azurerm" {
  alias           = "research"
  subscription_id = "#{SubscriptionIdResearchAndDevelopment}#"
  features {}
}

locals {
  tags = {
    "Application Name"     = "#{TagApplicationName}#"
    "Application ID"       = "#{TagApplicationId}#"
    "Business Criticality" = "#{TagBusinessCriticality}#"
    CreationDate           = formatdate("YYYY-MM-DD'T'08:00:00'0000000Z'", timestamp())
    "Data Confidentiality" = "#{TagDataConfidentiality}#"
    DeletionDate           = formatdate("YYYY-MM-DD'T'08:00:00'0000000Z'", timeadd(timestamp(), "168h"))
    Environment            = "#{Environment}#"
    OwnerEmail             = "#{TagOwnerEmail}#"
  }

  allowed_tags_list = {
    "Data Confidentiality" = [
      "Public",
      "Internal",
      "Internal-Confidential",
      "Restricted"
    ],
    "Environment" = [
      "prd",
      "tst",
      "dev"
    ],
    "Business Criticality" = [
      "Low",
      "Medium",
      "High",
      "Critical"
    ]
  }

  virtual_network_ids = {
    # connectivity = module.cnty_virtual_network.virtual_network_id,
    # management   = module.mgmt_virtual_network.virtual_network_id,
    # identity     = module.idty_virtual_network.virtual_network_id,
    # connected    = module.conn_virtual_network.virtual_network_id,
    research = module.rsch_virtual_network.virtual_network_id
  }
}

# resource "time_sleep" "wait_for_vnet_gateway" {
#   # Need to Wait for the Virtual Network Gateway readiness status to be synchronized to Vnets before creating Vnet peerings in all subscriptions 

#   depends_on      = [module.cnty_virtual_network_gateway]
#   create_duration = "600s"
# }