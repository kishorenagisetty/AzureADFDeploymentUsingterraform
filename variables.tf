# ResourceGroup
variable "resource_group_name" {}
variable "location" {}
# Synapse Workspace
variable "synapse_managed_RG_name" {}
variable "storage_account_name" {}
variable "storage_data_lake_gen2_filesystem_name" {}
variable "synapse_workspace_name" {}
variable "azure_devops_account_name" {}
variable "azure_devops_project_name" {}
variable "azure_devops_branch_name" {}
variable "azure_devops_repo_name" {}
variable "synapse_sql_pool_name" {}
# variable "firewall_allow_ip_address" {}
variable "start_ip_address_1" {}
variable "end_ip_address_1" {}
variable "start_ip_address_2" {}
variable "end_ip_address_2" {}
variable "start_ip_address_3" {}
variable "end_ip_address_3" {}
variable "start_ip_address_4" {}
variable "end_ip_address_4"   {}
variable "start_ip_address_5" {}
variable "end_ip_address_5"   {}
variable "sql_username" {}
# Virtual Network
variable "virtual_network_name" {}
variable "vnet_address_space" {}
variable "subnet_name" {}
variable "subnet_address_space" {}
# KeyVault
variable "vault_Name" {}
variable "user_object_id" {}
variable "kv_secret_name" {}