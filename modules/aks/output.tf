output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks_cluster.name
}

output "aks_cluster_location" {
  value = azurerm_kubernetes_cluster.aks_cluster.location
}
