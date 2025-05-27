terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.22.0"
    }
  }
  backend "azurerm" {
    subscription_id = "#{Subscription_Id_Management}#"
  }

  required_version = ">= 1.11.0"
}

provider "azurerm" {
  alias           = "connectivity"
  subscription_id = "#{Subscription_Id_Connectivity}#"
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {}
}

provider "azurerm" {
  alias           = "management"
  subscription_id = "#{Subscription_Id_Management}#"
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {}
}

provider "azurerm" {
  alias           = "identity"
  subscription_id = "#{Subscription_Id_Identity}#"
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {}
}

provider "azurerm" {
  alias           = "connected"
  subscription_id = "#{Subscription_Id_Connected}#"
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  features {}
}

locals {
  tags = {
    OwnerEmail             = "#{Tag_Owner_Email}#"
    Environment            = "#{Environment}#"
    "Data Confidentiality" = "#{Tag_Data_Confidentiality}#"
    "Business Criticality" = "#{Tag_Business_Criticality}#"
    "Application ID"       = "#{Tag_Application_Id}#"
    "Application Name"     = "#{Tag_Application_Name}#"
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