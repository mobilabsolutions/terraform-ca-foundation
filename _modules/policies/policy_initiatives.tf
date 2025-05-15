resource "azurerm_policy_set_definition" "main_mg_mobilab_initiative" {
  name                = "Aleksei Test - Main management group policy initiative"
  policy_type         = "Custom"
  display_name        = "Aleksei Test - Main management group policy initiative"
  description         = "Recommended policy set for Azure resources"
  management_group_id = "/providers/Microsoft.Management/managementGroups/${var.top_mg_id}"

  metadata = <<METADATA
    {
    "category": "Security"
    }
  METADATA

  policy_definition_group {
    name         = "tagging"
    display_name = "Tagging Policies"
    category     = "Tags"
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"
    reference_id         = "Require a tag Application Name​"
    policy_group_names   = ["tagging"]

    parameter_values = <<VALUE
    {
      "tagName": {"value": "Application Name"}
    }
    VALUE
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/96670d01-0a4d-4649-9c89-2d3abc0a5025"
    reference_id         = "Require a tag Application ID"
    policy_group_names   = ["tagging"]

    parameter_values = <<VALUE
    {
      "tagName": {"value": "Application ID"}
    }
    VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.require_tag_on_resource_groups["Business Criticality"].id
    reference_id         = "Require a tag Environment"
    policy_group_names   = ["tagging"]
  }
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.require_tag_on_resource_groups["Data Confidentiality"].id
    reference_id         = "Require a tag Business Criticality"
    policy_group_names   = ["tagging"]
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.require_tag_on_resource_groups["Environment"].id
    reference_id         = "Require a tag Data Confidentiality"
    policy_group_names   = ["tagging"]
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ea3f2387-9b95-492a-a190-fcdc54f7b070"
    reference_id         = "Inherit a tag Application Name"
    parameter_values     = <<VALUE
    {
      "tagName": {"value": "Application Name"}
    }
    VALUE
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ea3f2387-9b95-492a-a190-fcdc54f7b070"
    reference_id         = "Inherit a tag Application ID"
    parameter_values     = <<VALUE
    {
      "tagName": {"value": "Application ID"}
    }
    VALUE
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ea3f2387-9b95-492a-a190-fcdc54f7b070"
    reference_id         = "Inherit a tag Business Criticality"
    parameter_values     = <<VALUE
    {
      "tagName": {"value": "Business Criticality"}
    }
    VALUE
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ea3f2387-9b95-492a-a190-fcdc54f7b070"
    reference_id         = "Inherit a tag Data Confidentiality"
    parameter_values     = <<VALUE
    {
      "tagName": {"value": "Data Confidentiality"}
    }
    VALUE
  }

  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ea3f2387-9b95-492a-a190-fcdc54f7b070"
    reference_id         = "Inherit a tag Environment"
    parameter_values     = <<VALUE
    {
      "tagName": {"value": "Environment"}
    }
    VALUE
  }

  policy_definition_reference {
    #Key vaults should have deletion protection enabled​
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0b60c0b2-2dc2-4e1c-b5c9-abbed971de53"
    reference_id         = "Key vaults - protection enabled​"
  }

  policy_definition_reference {
    #Azure Backup should be enabled for Virtual Machines
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/013e242c-8828-4970-87b3-ab247555486d"
    reference_id         = "Azure Backup for VMs"
  }

  policy_definition_reference {
    # [Preview]: Soft delete must be enabled for Recovery Services Vaults.
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/31b8092a-36b8-434b-9af7-5ec844364148"
    reference_id         = "Soft delete for Recovery Services Vaults"
  }

  policy_definition_reference {
    # Key vaults should have soft delete enabled
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1e66c121-a66a-4b1f-9b83-0fd99bf0fc2d"
    reference_id         = "Key vaults - soft delete enabled"
  }

  policy_definition_reference {
    #Audit diagnostic setting for selected resource types
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/7f89b1eb-583c-429a-8828-af049802c1d9"
    reference_id         = "Audit diagnostic settings"
    parameter_values     = <<VALUE
    {
        "listOfResourceTypes": {
            "value": [
              "Microsoft.ApiManagement/service",
              "Microsoft.Network/applicationGateways",
              "Microsoft.Automation/automationAccounts",
              "Microsoft.ContainerInstance/containerGroups",
              "Microsoft.ContainerRegistry/registries",
              "Microsoft.ContainerService/managedClusters",
              "Microsoft.Batch/batchAccounts",
              "Microsoft.Cdn/profiles/endpoints",
              "Microsoft.CognitiveServices/accounts",
              "Microsoft.DocumentDB/databaseAccounts",
              "Microsoft.DataFactory/factories",
              "Microsoft.DataLakeAnalytics/accounts",
              "Microsoft.DataLakeStore/accounts",
              "Microsoft.EventGrid/eventSubscriptions",
              "Microsoft.EventGrid/topics",
              "Microsoft.EventHub/namespaces",
              "Microsoft.Network/expressRouteCircuits",
              "Microsoft.Network/azureFirewalls",
              "Microsoft.HDInsight/clusters",
              "Microsoft.Devices/IotHubs",
              "Microsoft.KeyVault/vaults",
              "Microsoft.Network/loadBalancers",
              "Microsoft.Logic/integrationAccounts",
              "Microsoft.Logic/workflows",
              "Microsoft.DBforMySQL/servers",
              "Microsoft.Network/networkInterfaces",
              "Microsoft.Network/networkSecurityGroups",
              "Microsoft.DBforPostgreSQL/servers",
              "Microsoft.PowerBIDedicated/capacities",
              "Microsoft.Network/publicIPAddresses",
              "Microsoft.RecoveryServices/vaults",
              "Microsoft.Cache/redis",
              "Microsoft.Relay/namespaces",
              "Microsoft.Search/searchServices",
              "Microsoft.ServiceBus/namespaces",
              "Microsoft.SignalRService/SignalR",
              "Microsoft.Sql/servers/databases",
              "Microsoft.Sql/servers/elasticPools",
              "Microsoft.StreamAnalytics/streamingjobs",
              "Microsoft.TimeSeriesInsights/environments",
              "Microsoft.Network/trafficManagerProfiles",
              "Microsoft.Compute/virtualMachines",
              "Microsoft.Compute/virtualMachineScaleSets",
              "Microsoft.Network/virtualNetworks",
              "Microsoft.Network/virtualNetworkGateways"
            ]
        }
    }
    VALUE
  }

  policy_definition_reference {
    #Windows virtual machines should have Azure Monitor Agent installed
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/c02729e5-e5e7-4458-97fa-2b5ad0661f28"
    reference_id         = "Azure Monitor Agent installed"
  }

  policy_definition_reference {
    #Transparent Data Encryption on SQL databases should be enabled
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/17k78e20-9358-41c9-923c-fb736d382a12"
    reference_id         = "Transparent Data Encryption on SQL databases"
  }

  policy_definition_reference {
    #SQL Managed Instance should have the minimal TLS version of 1.2
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a8793640-60f7-487c-b5c3-1d37215905c4"
    reference_id         = "SQL Managed Instance TLS version"
  }

  policy_definition_reference {
    #Storage accounts should have the specified minimum TLS version
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/fe83a0eb-a853-422d-aac2-1bffd182c5d0"
    reference_id         = "Storage accounts min TLS version"
  }

  policy_definition_reference {
    #Web Application Firewall (WAF) should be enabled for Application Gateway
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/564feb30-bf6a-4854-b4bb-0d2d2d1e6c66"
    reference_id         = "Web Application Firewall (WAF) enabled"
  }

  policy_definition_reference {
    #Configure periodic checking for missing system updates on Azure virtual machines
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/59efceea-0c96-497e-a4a1-4eb2290dac15"
    reference_id         = "Periodic checking for missing system updates"
  }

  policy_definition_reference {
    #Gateway subnets should not be configured with a network security group
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/35f9c03a-cc27-418e-9c0c-539ff999d010"
    reference_id         = "Gateway subnets without NSG"
  }

  policy_definition_reference {
    #Network Watcher should be enabled​
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b6e2945c-0b7b-40f5-9233-7a5323b5cdc6"
    reference_id         = "Network Watcher enabled"
  }

  policy_definition_reference {
    #Microsoft Defender CSPM should be enabled
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1f90fc71-a595-4066-8974-d4d0802e8ef0"
    reference_id         = "Microsoft Defender CSPM enabled"
  }

}


resource "azurerm_policy_set_definition" "connected_mg_initiative" {
  name                = "Aleksei Test - Connected policy initiative"
  policy_type         = "Custom"
  display_name        = "Aleksei Test - Connected policy initiative"
  description         = "Policy set for Azure resources for Connected subscription"
  management_group_id = "/providers/Microsoft.Management/managementGroups/${var.top_mg_id}"

  metadata = <<METADATA
    {
    "category": "Security"
    }
  METADATA

  policy_definition_reference {
    # Public network access on Azure SQL Database should be disabled
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1b8ca024-1d5c-4dec-8995-b1a932b41780"
    reference_id         = "Disable Public network access on Azure SQL Database"
  }

  policy_definition_reference {
    # Storage account public access should be disallowed
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/4fa4b6c0-31ca-4c0d-b10d-24b96f62a751"
    reference_id         = "Storage account public access disallowed"
  }

  policy_definition_reference {
    # Network interfaces should not have public IPs
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114"
    reference_id         = "Network interfaces without public IPs"
  }

}