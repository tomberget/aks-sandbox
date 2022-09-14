variable "environment" {
  type        = string
  description = "The environment type deployed"
  default     = "test"
}

variable "postfix" {
  type        = string
  description = "A postfix only used by terratest"
  default     = ""
}

variable "location" {
  type        = string
  description = "The Azure location where the items will be deployed"
  default     = "West Europe"
}

variable "default_vm_size" {
  type        = string
  description = "What kind of Virtual Machines the cluster will be utilizing."
  default     = "Standard_D2_v2"
}

variable "default_node_count" {
  type        = number
  description = "Number of nodes in the default node pool"
  default     = 1
}

variable "node_pool_vm_size" {
  type        = string
  description = "What kind of Virtual Machines the cluster will be utilizing."
  default     = "Standard_D2_v2"
}

variable "node_pool_node_count" {
  type        = number
  description = "Number of nodes in the default node pool"
  default     = 1
}

variable "additional_node_pools" {
  type        = number
  description = "The number of additional node pools to spin up"
  default     = 3
}
