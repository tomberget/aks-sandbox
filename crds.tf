# Create/Update CRDs
resource "kubernetes_manifest" "prometheus_operator_crd" {
  for_each = toset(["alertmanagerconfigs", "alertmanagers", "podmonitors", "probes", "prometheuses", "prometheusrules", "servicemonitors", "thanosrulers"])
  manifest = yamldecode(file("${path.module}/apps/kube-prometheus-stack/crds/${var.prometheus_operator_version}/monitoring.coreos.com_${each.key}.yaml"))

  field_manager {
    force_conflicts = true
  }

  depends_on = [
    module.aks
  ]
}
