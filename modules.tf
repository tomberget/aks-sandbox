module "argo_cd" {
  source = "./modules/argo-cd"

  chart_version       = "5.5.8"
  application_version = "v2.4.13"
  name                = "argo-cd"
  namespace           = kubernetes_namespace.namespaces["argocd"].metadata.0.name

  redis_enabled            = true
  autoscaling_enabled      = true
  controller_replicas      = 1
  metrics_enabled          = false
  prometheus_rules_enabled = false

  depends_on = [
    azurerm_resource_group.aks
  ]
}

# Implement Ingress-Nginx
resource "kubernetes_manifest" "ingress_nginx" {
  manifest = yamldecode(file("${path.module}/argocd_manifests/ingress-nginx.yaml"))

  field_manager {
    force_conflicts = true
  }

  depends_on = [
    module.argo_cd,
    kubernetes_namespace.namespaces["ingress-nginx"],
  ]
}

# Implement Kube-Prometheus-Stack
resource "kubernetes_manifest" "kube_prometheus_stack" {
  manifest = yamldecode(file("${path.module}/argocd_manifests/kube-prometheus-stack.yaml"))

  field_manager {
    force_conflicts = true
  }

  depends_on = [
    module.argo_cd,
    kubernetes_manifest.prometheus_operator_crd,
    kubernetes_manifest.ingress_nginx,
    kubernetes_namespace.namespaces["monitoring"],
  ]
}

# Implement Cert-Manager
resource "kubernetes_manifest" "cert_manager" {
  manifest = yamldecode(file("${path.module}/argocd_manifests/cert-manager.yaml"))

  field_manager {
    force_conflicts = true
  }

  depends_on = [
    module.argo_cd,
    kubernetes_manifest.prometheus_operator_crd,
    kubernetes_manifest.ingress_nginx,
    kubernetes_namespace.namespaces["cert-manager"],
  ]
}
