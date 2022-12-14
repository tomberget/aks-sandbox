variable "environment" {
  type        = string
  description = "The environment type deployed"
}

variable "terratest_postfix" {
  type        = string
  description = "A postfix only used by terratest"
  default     = ""
}

variable "location" {
  type        = string
  description = "The Azure location where the items will be deployed"
  default     = "West Europe"
}

variable "extra_tags" {
  type        = map(string)
  description = "Extra tags to add to the Azure Resources"
  default     = {}
}

# Kubernetes (AKS)
variable "aks_enabled" {
  type        = bool
  description = "Killswitch for enabling or disabling spinning up an AKS cluster"
  default     = false
}

variable "aks_default_vm_size" {
  type        = string
  description = "What kind of Virtual Machines the cluster will be utilizing."
  default     = "Standard_D2_v5"
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

variable "prometheus_operator_version" {
  description = "The Prometheus Operator version to use CRDs from."
  type        = string
}

# Cert-Manager
variable "cert_manager_version" {
  description = "The Cert-Manager version"
  type        = string
}

variable "hostname" {
  description = "Hostname to use."
  type        = string
}

variable "dns_sp_id" {
  description = "Service Principal Id for DNS"
  type        = string
}

variable "subscription_id" {
  description = "Subscription Id for Azure"
  type        = string
}

variable "tenant_id" {
  description = "Tenant Id for Azure"
  type        = string
}

variable "email_address" {
  description = "Email address for Cert Manager"
  type        = string
}

# Windows Virtual Machine(s)
variable "wvm_enabled" {
  type        = bool
  description = "Killswitch for enabling or disabling spinning up an AKS cluster"
  default     = false
}

variable "cilium_version" {
  type        = string
  description = "Cilium CNI version"
}

variable "cilium_cni_enabled" {
  type        = bool
  description = "Killswitch for enabling or disabling Cilium CNI"
  default     = false
}

variable "argo_cd_version" {
  type        = string
  description = "Version of ArgoCD"
}
