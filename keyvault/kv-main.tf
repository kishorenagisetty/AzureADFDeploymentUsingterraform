resource "random_string" "name" {
  length           = 5
  special          = false
  numeric          = false
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "myVault" {
  name                        = "${var.vault_Name}-${random_string.name.result}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name = "standard"

  tags = {
    env = "test"
  }
}
resource "azurerm_key_vault_access_policy" "user-access-policy" {
  key_vault_id = azurerm_key_vault.myVault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.user_object_id

  key_permissions = [
    "Get", "Create", "List", "Update"
  ]

  secret_permissions = [
    "Get", "List", "Recover", "Set", "Delete", "Purge", "Restore"
  ]

  storage_permissions = [
    "Get", "List", "Update", "Set"
  ]
  depends_on = [ data.azurerm_client_config.current, azurerm_key_vault.myVault ]
}
resource "azurerm_key_vault_access_policy" "SP-access-policy" {
  key_vault_id = azurerm_key_vault.myVault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Get", "Create", "List", "Update"
  ]

  secret_permissions = [
    "Get", "List", "Recover", "Set", "Delete", "Purge", "Restore"
  ]

  storage_permissions = [
    "Get", "List", "Update", "Set"
  ]
  depends_on = [ data.azurerm_client_config.current, azurerm_key_vault.myVault ]
}
resource "azurerm_key_vault_secret" "kvsecret" {
  name         = var.kv_secret_name
  value        = var.secret_value
  key_vault_id = azurerm_key_vault.myVault.id
  depends_on = [ azurerm_key_vault_access_policy.SP-access-policy, azurerm_key_vault_access_policy.user-access-policy, azurerm_key_vault.myVault ]
}