output "aks_resource_group_name" {
  value       = azurerm_resource_group.aks.name
  description = "Resource Group used for AKS resource."
}

output "aks_cluster_name" {
  value       = join(",", module.aks[*].aks_cluster_name)
  description = "Name provided to the AKS resource"
}

output "aks_cluster_location" {
  value       = join(",", module.aks[*].aks_cluster_location)
  description = "Azure location for the AKS resource"
}
