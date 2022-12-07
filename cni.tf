# Cilium CNI
resource "helm_release" "cilium" {
  for_each = toset(var.cilium_cni_enabled ? ["cilium"] : [])

  name       = "cilium"
  namespace  = "kube-system"
  repository = "https://helm.cilium.io"
  chart      = "cilium"
  version    = var.cilium_version

  values = [
    templatefile("${path.root}/templates/cilium_cni_values.yaml", {
    })
  ]
}
