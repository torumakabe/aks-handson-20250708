resource "azurerm_kubernetes_cluster" "aks_wakaran" {
  name                      = var.aks_cluster_name
  resource_group_name       = azurerm_resource_group.aks_wakaran.name
  location                  = azurerm_resource_group.aks_wakaran.location
  dns_prefix                = "aks-wakaran-${local.unique_token}"
  kubernetes_version        = "1.32"
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_data_plane  = "cilium"
  }

  node_resource_group = "${azurerm_resource_group.aks_wakaran.name}-node"

  default_node_pool {
    name           = "default"
    node_count     = 2
    vm_size        = var.aks_node_size
    vnet_subnet_id = azurerm_subnet.aks.id
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].upgrade_settings,
      microsoft_defender
    ]
  }

  tags = local.project_tags
}

resource "azurerm_role_assignment" "aks_to_acr_pull" {
  principal_id                     = azurerm_kubernetes_cluster.aks_wakaran.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.aks_wakaran.id
  skip_service_principal_aad_check = true
}
