resource "kubernetes_manifest" "issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"

    metadata = {
      name = "letsencrypt-issuer"
    }

    spec = {
      acme = {
        email  = var.email_address
        server = "https://acme-v02.api.letsencrypt.org/directory"
        privateKeySecretRef = {
          name = "acme-issuer-account-key"
        }
        solvers = [
          {
            dns01 = {
              azureDNS = {
                clientID = var.dns_sp_id
                clientSecretSecretRef = {
                  name = "azuredns-config"
                  key  = "client-secret"
                }
                # The following is the secret we created in Kubernetes. Issuer will use this to present challenge to Azure DNS.
                subscriptionID    = var.subscription_id
                tenantID          = var.tenant_id
                resourceGroupName = "default"
                hostedZoneName    = var.hostname
                # Azure Cloud Environment, default to AzurePublicCloud
                environment = "AzurePublicCloud"
              }
            }
          },
        ]
      }
    }
  }

  depends_on = [
    kubernetes_manifest.cert_manager_crd["clusterissuer"],
  ]
}
