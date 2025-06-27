output "storageAccountName" {
  value = azurerm_storage_account.mySA.name
}
output "fileSystemName" {
  value = azurerm_storage_data_lake_gen2_filesystem.myFS.name
}
output "synapseWorkspaceName" {
  value = azurerm_synapse_workspace.myWS.name
}
output "synapseSQLUsername" {
  value     = azurerm_synapse_workspace.myWS.sql_administrator_login
  sensitive = true
}
output "synapseSQLPassword" {
  value     = azurerm_synapse_workspace.myWS.sql_administrator_login_password
  sensitive = true
}
output "synapse_sql_pool_name" {
  value = azurerm_synapse_sql_pool.mySqlPool.name
}