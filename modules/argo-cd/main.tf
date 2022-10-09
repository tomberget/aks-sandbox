# Create/Update CRDs
resource "kubernetes_manifest" "argocd_crd" {
  for_each = toset(["application-crd", "applicationset-crd", "appproject-crd"])
  manifest = yamldecode(file("${path.module}/crds/${var.application_version}/${each.key}.yaml"))

  field_manager {
    force_conflicts = true
  }
}

# Ingress Hostname
locals {
  ingress_hostname = format("argocd.%s", var.hostname)
}

resource "helm_release" "argo_cd" {
  name       = var.name
  namespace  = var.namespace
  repository = "https://argoproj.github.io/argo-helm"
  chart      = var.name
  version    = var.chart_version

  values = [
    templatefile("${path.module}/values.yaml", {
      crds_install             = false
      redis_enabled            = var.redis_enabled
      autoscaling_enabled      = var.autoscaling_enabled
      controller_replicas      = var.controller_replicas
      replicas                 = var.autoscaling_enabled ? 2 : 1
      metrics_enabled          = var.metrics_enabled
      prometheus_rules_enabled = var.prometheus_rules_enabled
      ingress_enabled          = true
      ingress_hostname         = local.ingress_hostname
      tls_secret_name          = format("%s-tls",replace(local.ingress_hostname, ".", "-"))
    }),
  ]

  depends_on = [
    kubernetes_manifest.argocd_crd
  ]
}
