resource "azurerm_resource_group" "aks_wakaran" {
  name     = var.resource_group_name
  location = var.resource_group_location
  tags     = local.project_tags
}
