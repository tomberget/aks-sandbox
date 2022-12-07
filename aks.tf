module "aks" {
  source = "./modules/aks"

  count = var.aks_enabled ? 1 : 0

  aks_resource_group_name   = azurerm_resource_group.aks.name
  postfix                   = local.environment
  location                  = azurerm_resource_group.aks.location
  tags                      = local.tags
  aks_default_node_count    = var.aks_default_node_count
  aks_additional_node_pools = var.aks_additional_node_pools
  aks_default_vm_size       = var.aks_default_vm_size
}
