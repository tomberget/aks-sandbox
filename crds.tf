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

resource "kubernetes_manifest" "cert_manager_crd" {
  for_each = toset(["certificaterequests", "certificates", "challenges.acme", "clusterissuers", "issuers", "orders.acme"])
  manifest = yamldecode(file("${path.module}/apps/cert-manager/crds/${var.cert_manager_version}/${each.key}.cert-manager.io.yaml"))

  field_manager {
    force_conflicts = true
  }

  depends_on = [
    module.aks
  ]
}
