resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = format("aks-cluster-%s", var.postfix)
  location            = var.location
  resource_group_name = var.aks_resource_group_name
  dns_prefix          = format("%saks", var.postfix)

  default_node_pool {
    name       = "default"
    node_count = var.aks_default_node_count
    vm_size    = var.aks_default_vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "none"
  }

  tags = var.tags
}

resource "azurerm_kubernetes_cluster_node_pool" "aks_cluster_node_pool" {
  count = var.aks_additional_node_pools

  name                  = format("additional%s", count.index)
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  vm_size               = var.aks_node_pool_vm_size
  node_count            = var.aks_node_pool_node_count

  tags = var.tags
}

resource "local_sensitive_file" "kube_config" {
  filename        = "./kube/config"
  content         = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  file_permission = "0600"

  depends_on = [azurerm_kubernetes_cluster.aks_cluster]
}
