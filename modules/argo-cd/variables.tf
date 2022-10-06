variable "chart_version" {
  description = "The Chart version used for deployment."
  type        = string
}

variable "application_version" {
  description = "The Application version to install CRDs from."
  type        = string
}

variable "name" {
  description = "The name of the Helm chart"
  type        = string
}

variable "namespace" {
  description = "The Kubernetes namespace to install Argo-CD in."
  type        = string
}

variable "controller_replicas" {
  description = "The number of controller replicas"
  type        = number
}

variable "redis_enabled" {
  description = "Killswitch for REDIS"
  type        = bool
  default     = false
}

variable "autoscaling_enabled" {
  description = "Killswitch for autoscaling"
  type        = bool
  default     = false
}

variable "metrics_enabled" {
  description = "Killswitch for enabling metrics and service monitor"
  type        = bool
  default     = false
}

variable "prometheus_rules_enabled" {
  description = "Killswitch for enabling prometheus rule set"
  type        = bool
  default     = false
}
