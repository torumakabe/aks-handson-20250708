resource "azurerm_storage_account" "aks_wakaran" {
  name                      = "${var.storage_account_prefix}${local.unique_token}"
  resource_group_name       = azurerm_resource_group.aks_wakaran.name
  location                  = azurerm_resource_group.aks_wakaran.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  shared_access_key_enabled = false

  tags = local.project_tags
}

resource "azurerm_role_assignment" "deployer_to_blob_data_contributor" {
  scope                = azurerm_storage_account.aks_wakaran.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

