output "resourceGroupName" {
  value = azurerm_resource_group.myRG.name
}
# output "storageAccountName" {
#   value = module.synapse_workspace.storageAccountName
# }
# output "fileSysytemName" {
#   value = module.synapse_workspace.fileSystemName
# }
output "synapseWorkspaceName" {
  value = module.synapse_workspace.synapseWorkspaceName
}
output "synapseSQLPassword" {
  value     = "Please check the keyvault for password..."
}
output "synapse_sql_pool_name" {
  value = module.synapse_workspace.synapse_sql_pool_name
}
output "VNetName" {
  value = module.virtual_network.VNetName
}
# output "VNetID" {
#   value = module.virtual_network.VNetID
# }
output "subnetName" {
  value = module.virtual_network.subnetName
}
# output "subnetID" {
#   value = module.virtual_network.subnetID
# }
output "KeyVaultName" {
  value = module.keyvault.kv-name
}
output "KVSecretName" {
  value = module.keyvault.key_vault_secret-name
}