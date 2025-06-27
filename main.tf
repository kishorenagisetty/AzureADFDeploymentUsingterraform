resource "random_password" "password" {
  length = 16
  special = true
  min_lower = 4
  min_upper = 3
  numeric = true
  override_special = "!@#$%&*()-=+[]{}<>:?" 
}

resource "azurerm_resource_group" "myRG" {
  name     = var.resource_group_name
  location = var.location
}

module "virtual_network" {
  source = "./Vnet"
  resource_group_name       = azurerm_resource_group.myRG.name
  location                  = azurerm_resource_group.myRG.location
  virtual_network_name      = var.virtual_network_name
  vnet_address_space        = var.vnet_address_space
  subnet_name               = var.subnet_name
  subnet_address_space      = var.subnet_address_space
}

module "synapse_workspace" {
  source = "./synapse"
  resource_group_name                           = azurerm_resource_group.myRG.name
  location                                      = azurerm_resource_group.myRG.location
  synapse_managed_RG_name                       = var.synapse_managed_RG_name
  storage_account_name                          = var.storage_account_name
  storage_data_lake_gen2_filesystem_name        = var.storage_data_lake_gen2_filesystem_name
  synapse_workspace_name                        = var.synapse_workspace_name
  azure_devops_account_name                     = var.azure_devops_account_name
  azure_devops_project_name                     = var.azure_devops_project_name
  azure_devops_branch_name                      = var.azure_devops_branch_name
  azure_devops_repo_name                        = var.azure_devops_repo_name
  sql_username                                  = var.sql_username
  sql_password                                  = random_password.password.result
  synapse_sql_pool_name                         = var.synapse_sql_pool_name
  synapse_endpoint_subnet_id                    = module.virtual_network.subnetID
  # firewall_allow_ip_address                   = var.firewall_allow_ip_address
  start_ip_address_1                            = var.start_ip_address_1
  end_ip_address_1                              = var.end_ip_address_1
  start_ip_address_2                            = var.start_ip_address_2
  end_ip_address_2                              = var.end_ip_address_2
  start_ip_address_3                            = var.start_ip_address_3
  end_ip_address_3                              = var.end_ip_address_3
  start_ip_address_4                            = var.start_ip_address_4
  end_ip_address_4                              = var.end_ip_address_4
  start_ip_address_5                            = var.start_ip_address_5
  end_ip_address_5                              = var.end_ip_address_5
  user_object_id                                = var.user_object_id
}

module "keyvault" {
  source = "./keyvault"
  resource_group_name       = azurerm_resource_group.myRG.name
  location                  = azurerm_resource_group.myRG.location
  vault_Name                = var.vault_Name
  user_object_id            = var.user_object_id
  kv_secret_name            = var.kv_secret_name
  secret_value              = random_password.password.result
}