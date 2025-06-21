resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  machine_type     = "controlplane"
  cluster_endpoint = "https://${hcloud_primary_ip.main.0.ip_address}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
  
  config_patches = [
    yamlencode({
      cluster = {
        apiServer = {
          extraArgs = {
            enable-admission-plugins = "NodeRestriction"
          }
        }
      }
      machine = {
        features = {
          kubernetesTalosAPIAccess = {
            enabled                     = true
            allowedRoles                = ["os:reader"]
            allowedKubernetesNamespaces = ["kube-system"]
          }
        }
        kubelet = {
          extraConfig = {
            serverTLSBootstrap = true
          }
        }
      }
    })
  ]
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [hcloud_server.controlplane.0.ipv4_address]
}

resource "talos_machine_bootstrap" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = hcloud_server.controlplane.0.ipv4_address
  node                 = hcloud_server.controlplane.0.ipv4_address

  depends_on           = [hcloud_server.controlplane.0]
}

resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = hcloud_server.controlplane.0.ipv4_address
  node                 = hcloud_server.controlplane.0.ipv4_address

  depends_on           = [talos_machine_bootstrap.this]
}