resource "azurerm_resource_group" "aks" {
  name     = format("rg-aks-%s", local.environment)
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = format("aks-cluster-%s", local.environment)
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = format("%saks", local.environment)

  default_node_pool {
    name       = "default"
    node_count = var.default_node_count
    vm_size    = var.default_vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "aks_cluster_node_pool" {
  count = var.additional_node_pools

  name                  = format("additional%s", count.index)
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  vm_size               = var.node_pool_vm_size
  node_count            = var.node_pool_node_count

  tags = local.tags
}

output "resource_group_name" {
  value = azurerm_resource_group.aks.name
}
