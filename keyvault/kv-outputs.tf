output "kv-name" {
  value = azurerm_key_vault.myVault.name
}
output "kv-id" {
  value = azurerm_key_vault.myVault.id
}
output "key_vault_secret-name" {
  value = azurerm_key_vault_secret.kvsecret.name
}