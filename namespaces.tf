locals {
  namespaces = [
    "argocd",
    "monitoring",
    "ingress-nginx",
    "cert-manager",
    "external-dns",
    "budibase",
  ]
}

resource "kubernetes_namespace" "namespaces" {
  for_each = toset(local.namespaces)
  metadata {
    name = each.key
  }
}
