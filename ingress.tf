locals {
  ingresses = {
    prometheus = {
      enabled          = true
      namespace        = kubernetes_namespace.namespaces["monitoring"].metadata.0.name
      app_service_name = "release-name-kube-promethe-prometheus"
      app_service_port = 9090
      annotations      = {}
    },
    alertmanager = {
      enabled          = true
      namespace        = kubernetes_namespace.namespaces["monitoring"].metadata.0.name
      app_service_name = "release-name-kube-promethe-alertmanager"
      app_service_port = 9093
      annotations      = {}
    },
    argocd = {
      enabled          = true
      namespace        = kubernetes_namespace.namespaces["argocd"].metadata.0.name
      app_service_name = "argo-cd-argocd-server"
      app_service_port = 443
      annotations = {
        "nginx.ingress.kubernetes.io/ssl-passthrough"  = "true"
        "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
      }
    },
    budibase = {
      enabled          = true
      namespace        = kubernetes_namespace.namespaces["budibase"].metadata.0.name
      app_service_name = "proxy-service"
      app_service_port = 10000
      annotations      = {}
    }
  }
}

module "ingress" {
  source = "./modules/ingress"

  for_each = local.ingresses

  name               = each.key
  namespace          = lookup(each.value, "namespace", "fixit")
  annotations        = lookup(each.value, "annotations", {})
  ingress_class_name = lookup(each.value, "ingress_class_name", "nginx")
  hostname           = var.hostname
  app_service_name   = lookup(each.value, "app_service_name", "")
  app_service_port   = lookup(each.value, "app_service_port", 80)
}
