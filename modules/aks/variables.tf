# Kubernetes (AKS)
variable "aks_resource_group_name" {
  type        = string
  description = "Resource Group used to spin up cluster"
}

variable "aks_default_vm_size" {
  type        = string
  description = "What kind of Virtual Machines the cluster will be utilizing."
  default     = "Standard_D2_v2"
}

variable "aks_default_node_count" {
  type        = number
  description = "Number of nodes in the default node pool"
  default     = 1
}

variable "aks_node_pool_vm_size" {
  type        = string
  description = "What kind of Virtual Machines the cluster will be utilizing."
  default     = "Standard_D2_v2"
}

variable "aks_node_pool_node_count" {
  type        = number
  description = "Number of nodes in the default node pool"
  default     = 1
}

variable "aks_additional_node_pools" {
  type        = number
  description = "The number of additional node pools to spin up"
  default     = 0
}

variable "postfix" {
  type        = string
  description = "Postfix for resource names"
}

variable "location" {
  type        = string
  description = "The Azure location where the items will be deployed"
}

variable "tags" {
  type        = map(string)
  description = "Tags used for resources created"
}
