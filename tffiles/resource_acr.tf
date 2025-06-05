resource "azurerm_container_registry" "aks_wakaran" {
  name                = "${var.acr_prefix}${local.unique_token}"
  resource_group_name = azurerm_resource_group.aks_wakaran.name
  location            = azurerm_resource_group.aks_wakaran.location
  sku                 = "Basic"

  tags = local.project_tags
}
