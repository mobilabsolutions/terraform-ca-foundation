terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.22.0"
    }
  }
  backend "azurerm" {
    subscription_id = "#{SubscriptionIdManagement}#"
  }

  required_version = ">= 1.11.0"
}

provider "azurerm" {
  alias           = "connectivity"
  subscription_id = "#{SubscriptionIdConnectivity}#"
  features {}
}

provider "azurerm" {
  alias           = "management"
  subscription_id = "#{SubscriptionIdManagement}#"
  features {}
}

provider "azurerm" {
  alias           = "identity"
  subscription_id = "#{SubscriptionIdIdentity}#"
  features {}
}

provider "azurerm" {
  alias           = "connected"
  subscription_id = "#{SubscriptionIdConnected}#"
  features {}
}

locals {
  tags = {
    OwnerEmail             = "#{TagOwnerEmail}#"
    Environment            = "#{Environment}#"
    "Data Confidentiality" = "#{TagDataConfidentiality}#"
    "Business Criticality" = "#{TagBusinessCriticality}#"
    "Application ID"       = "#{TagApplicationId}#"
    "Application Name"     = "#{TagApplicationName}#"
    CreationDate           = formatdate("YYYY-MM-DD'T'08:00:00'0000000Z'", timestamp())
    DeletionDate           = formatdate("YYYY-MM-DD'T'08:00:00'0000000Z'", timeadd(timestamp(), "168h"))
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
    "connectivity" = module.cnty_virtual_network.virtual_network_id,
    "management"   = module.mgmt_virtual_network.virtual_network_id,
    "identity"     = module.idty_virtual_network.virtual_network_id,
    "connected"    = module.conn_virtual_network.virtual_network_id
  }
}

resource "time_sleep" "wait_for_vnet_gateway" {
  # Need to Wait for the Virtual Network Gateway readiness status to be synchronized to Vnets before creating Vnet peerings in all subscriptions 

  depends_on      = [module.cnty_virtual_network_gateway]
  create_duration = "600s"
}