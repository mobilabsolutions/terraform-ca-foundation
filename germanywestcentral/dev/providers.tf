terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.22.0"
    }
  }
  backend "azurerm" {
    subscription_id = "#{Subscription_Id_Research_And_Development}#"
  }

  required_version = ">= 1.11.0"
}

provider "azurerm" {
  alias           = "research"
  subscription_id = "#{Subscription_Id_Research_And_Development}#"
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {}
}

locals {
  tags = {
    "Application Name"     = "#{Tag_Application_Name}#"
    "Application ID"       = "#{Tag_Application_Id}#"
    "Business Criticality" = "#{Tag_Business_Criticality}#"
    CreationDate           = formatdate("YYYY-MM-DD'T'08:00:00'0000000Z'", timestamp())
    "Data Confidentiality" = "#{Tag_Data_Confidentiality}#"
    DeletionDate           = formatdate("YYYY-MM-DD'T'08:00:00'0000000Z'", timeadd(timestamp(), "168h"))
    Environment            = "#{Environment}#"
    OwnerEmail             = "#{Tag_Owner_Email}#"
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
    research = module.rsch_virtual_network.virtual_network_id
  }
}

# resource "time_sleep" "wait_for_vnet_gateway" {
#   # Need to Wait for the Virtual Network Gateway readiness status to be synchronized to Vnets before creating Vnet peerings in all subscriptions 

#   depends_on      = [module.cnty_virtual_network_gateway]
#   create_duration = "600s"
# }