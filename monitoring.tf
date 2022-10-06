# Create/Update CRDs
resource "kubernetes_manifest" "prometheus_operator_crd" {
  for_each = toset(["alertmanagerconfigs", "alertmanagers", "podmonitors", "probes", "prometheuses", "prometheusrules", "servicemonitors", "thanosrulers"])
  manifest = yamldecode(file("${path.module}/apps/monitoring/crds/${var.prometheus_operator_version}/monitoring.coreos.com_${each.key}.yaml"))

  field_manager {
    force_conflicts = true
  }

  depends_on = [
    module.aks
  ]
}

# Implement Kube-Prometheus-Stack
resource "kubernetes_manifest" "kube_prometheus_stack" {
  manifest = yamldecode(file("${path.module}/apps/monitoring/kube_prometheus_stack.yaml"))

  field_manager {
    force_conflicts = true
  }

  depends_on = [
    module.argo_cd,
    kubernetes_manifest.prometheus_operator_crd,
  ]
}
