# Create/Update CRDs
resource "kubernetes_manifest" "prometheus_operator_crd" {
  for_each = toset(["alertmanagerconfigs", "alertmanagers", "podmonitors", "probes", "prometheuses", "prometheusrules", "servicemonitors", "thanosrulers"])
  manifest = yamldecode(file("${path.root}/crds/prometheus/${var.prometheus_operator_version}/monitoring.coreos.com_${each.key}.yaml"))

  field_manager {
    force_conflicts = true
  }

  depends_on = [
    module.aks
  ]
}

resource "kubernetes_manifest" "cert_manager_crd" {
  for_each = toset(["certificaterequests", "certificates", "challenges.acme", "clusterissuers", "issuers", "orders.acme"])
  manifest = yamldecode(file("${path.root}/crds/cert-mgr/${var.cert_manager_version}/${each.key}.cert-manager.io.yaml"))

  field_manager {
    force_conflicts = true
  }

  depends_on = [
    module.aks
  ]
}

resource "kubernetes_manifest" "argo_cd_crd" {
  for_each = toset(["application-crd", "applicationset-crd", "appproject-crd"])
  manifest = yamldecode(file("${path.root}/crds/argo-cd/${var.argo_cd_version}/${each.key}.yaml"))

  field_manager {
    force_conflicts = true
  }

  depends_on = [
    module.aks
  ]
}
