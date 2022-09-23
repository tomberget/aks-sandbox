resource "azurerm_resource_group" "aks" {
  name     = format("rg-aks-%s", local.environment)
  location = var.location
}
