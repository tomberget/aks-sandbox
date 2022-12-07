# Environment and State settings
environment = "sandbox"

# AKS
aks_enabled               = true
aks_default_node_count    = 3
aks_additional_node_pools = 0
aks_default_vm_size       = "Standard_D2_v2" # "Standard_D2ds_v5"

# CNI
cilium_cni_enabled = true
cilium_version     = "1.12.3"

# Monitoring
prometheus_operator_version = "v0.60.1"

# Cert-Manager
cert_manager_version = "v1.10.1"

# Argo-CD
argo_cd_version = "v2.5.4"

# Windows Virtual Machines
wvm_enabled = false
