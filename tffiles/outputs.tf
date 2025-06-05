output "aks_cluster_name" {
  description = "AKS Cluster Name"
  value       = azurerm_kubernetes_cluster.aks_wakaran.name
}

output "aks_cluster_fqdn" {
  description = "AKS Cluster FQDN"
  value       = azurerm_kubernetes_cluster.aks_wakaran.fqdn
}

output "resource_group_name" {
  description = "Resource Group Name"
  value       = azurerm_resource_group.aks_wakaran.name
}

output "acr_name" {
  description = "Azure Container Registry Name"
  value       = azurerm_container_registry.aks_wakaran.name
}

output "storage_account_name" {
  description = "Azure Storage Account Name"
  value       = azurerm_storage_account.aks_wakaran.name
}
