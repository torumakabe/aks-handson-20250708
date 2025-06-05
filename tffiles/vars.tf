variable "resource_group_location" {
  type        = string
  default     = "japaneast"
  description = "Location of the resource group."
}

variable "resource_group_name" {
  type        = string
  default     = "rg-aks-wakaran"
  description = "Name of the resource group."
}

variable "aks_cluster_name" {
  type        = string
  default     = "aks-wakaran"
  description = "Name of the AKS cluster."
}

variable "aks_node_size" {
  type        = string
  default     = "Standard_D2ds_v4"
  description = "Node size of the AKS Cluster"
}

variable "acr_prefix" {
  type        = string
  default     = "akswakaran"
  description = "Name of the Azure Container Registry."
}

variable "storage_account_prefix" {
  type        = string
  default     = "akswakaran"
  description = "Name of the Azure Storage Account."
}

data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}

locals {
  unique_token  = substr(md5("${data.azurerm_subscription.current.subscription_id}${var.resource_group_name}"), 0, 8)
  vnet_name     = "vnet-aks-wakaran"
  snet_aks_name = "snet-aks"
  project_tags = {
    Project = "aks-wakaran"
  }
}
