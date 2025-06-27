# ------------------------------------------------------------------------------
# Author    : Kishore Kumar Nagisetty
# GitHub    : https://github.com/kishorenagisetty
# Project   : Azure Synapse ADF Deployment using Terraform
# Created   : 2024-06-25
# License   : MIT
# ------------------------------------------------------------------------------

data "azurerm_subscription" "my_subscription" {
}

resource "azurerm_storage_account" "mySA" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
}

resource "azurerm_storage_data_lake_gen2_filesystem" "myFS" {
  name               = var.storage_data_lake_gen2_filesystem_name
  storage_account_id = azurerm_storage_account.mySA.id
}

resource "azurerm_synapse_workspace" "myWS" {
  name                                 = var.synapse_workspace_name
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.myFS.id
  managed_resource_group_name          = var.synapse_managed_RG_name
  sql_administrator_login              = var.sql_username
  sql_administrator_login_password     = var.sql_password
  azure_devops_repo {
    account_name      = var.azure_devops_account_name
    root_folder       = "/"
    project_name      = var.azure_devops_project_name
    branch_name       = var.azure_devops_branch_name
    repository_name   = var.azure_devops_repo_name
  }
  identity {
    type = "SystemAssigned"
  }
  tags = {
    Env = "demo"
  }

  depends_on = [azurerm_storage_data_lake_gen2_filesystem.myFS, azurerm_storage_account.mySA]
}

resource "azurerm_private_endpoint" "synapse_endpoint" {
  name                = "synapse-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.synapse_endpoint_subnet_id

  private_service_connection {
    name                           = "synapse-service-connection"
    private_connection_resource_id = azurerm_synapse_workspace.myWS.id
    is_manual_connection           = false
    subresource_names              = ["sql"]
  }

  depends_on = [azurerm_synapse_workspace.myWS]
}

resource "azurerm_synapse_sql_pool" "mySqlPool" {
  name                 = var.synapse_sql_pool_name
  synapse_workspace_id = azurerm_synapse_workspace.myWS.id
  sku_name             = "DW100c"
  create_mode          = "Default"
  storage_account_type = "GRS"

  depends_on = [azurerm_synapse_workspace.myWS]
}

/*resource "azurerm_synapse_sql_database" "mySqlDatabase" {
  name               = "myDatabase"  # Specify your desired database name
  synapse_workspace_id = azurerm_synapse_workspace.myWS.id
  synapse_sql_pool_id = azurerm_synapse_sql_pool.mySqlPool.id

  depends_on = [azurerm_synapse_sql_pool.mySqlPool]
}*/

resource "azurerm_synapse_firewall_rule" "my_firewall_rule" {
  name                    = "firewall_allow_ip_address"
  synapse_workspace_id    = azurerm_synapse_workspace.myWS.id
  start_ip_address        = var.start_ip_address_1
  end_ip_address          = var.end_ip_address_1

  depends_on = [azurerm_synapse_workspace.myWS]
}
resource "azurerm_synapse_firewall_rule" "my_firewall_rule_1" {
  name                 = "Azure-vWAN-HUB1-IP1"
  synapse_workspace_id = azurerm_synapse_workspace.myWS.id
  start_ip_address     = var.start_ip_address_2
  end_ip_address       = var.end_ip_address_2
 
  depends_on = [azurerm_synapse_workspace.myWS]
}

resource "azurerm_synapse_firewall_rule" "my_firewall_rule_2" {
  name                 = "Azure-vWAN-HUB-IP2"
  synapse_workspace_id = azurerm_synapse_workspace.myWS.id
  start_ip_address     = var.start_ip_address_3
  end_ip_address       = var.end_ip_address_3
 
  depends_on = [azurerm_synapse_workspace.myWS]
}

resource "azurerm_synapse_firewall_rule" "my_firewall_rule_3" {
  name                 = "Azure-vWAN-HUB-IP3"
  synapse_workspace_id = azurerm_synapse_workspace.myWS.id
  start_ip_address     = var.start_ip_address_4
  end_ip_address       = var.end_ip_address_4
 
  depends_on = [azurerm_synapse_workspace.myWS]
}

resource "azurerm_synapse_firewall_rule" "my_firewall_rule_4" {
  name                 = "Daisy-PublicOutbound"
  synapse_workspace_id = azurerm_synapse_workspace.myWS.id
  start_ip_address     = var.start_ip_address_5
  end_ip_address       = var.end_ip_address_5
 
  depends_on = [azurerm_synapse_workspace.myWS]
}

resource "time_sleep" "wait_for_firewall_rule" {
  depends_on = [azurerm_synapse_firewall_rule.my_firewall_rule]
  // Wait for 1 minute after the firewall rule is created
  create_duration   = "1m"
}

resource "azurerm_role_assignment" "mgd_identity" {
  scope                   = data.azurerm_subscription.my_subscription.id
  role_definition_name    = "SQL DB Contributor"
  principal_id            = azurerm_synapse_workspace.myWS.identity[0].principal_id

  depends_on = [azurerm_synapse_workspace.myWS]
}

resource "azurerm_synapse_role_assignment" "synapse_role_assgnmt" {
  synapse_workspace_id = azurerm_synapse_workspace.myWS.id
  role_name            = "Synapse Administrator"
  principal_id         = var.user_object_id

  depends_on = [time_sleep.wait_for_firewall_rule]
}
