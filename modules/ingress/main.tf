# Define host and tls secret
locals {
  ingress_host = format("%s.%s", var.name, var.hostname)
  tls_secret_name = format("%s-tls", replace(local.ingress_host, ".", "-"))

  default_annotations = {
    "cert-manager.io/cluster-issuer" = "letsencrypt-issuer"
  }

  annotations = merge(local.default_annotations, var.annotations)
}

# Create ingress resource
resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name = var.name
    namespace = var.namespace
    annotations = local.annotations
  }

  spec {
    ingress_class_name = var.ingress_class_name
    rule {
      host = local.ingress_host
      http {
        path {
          path = var.path
          backend {
            service {
              name = var.app_service_name
              port {
                number = var.app_service_port
              }
            }
          }
        }
      }
    }

    tls {
      secret_name = local.tls_secret_name
      hosts = [
        local.ingress_host
      ]
    }
  }
}
