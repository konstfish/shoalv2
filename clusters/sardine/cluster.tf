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
        extraManifests = [
          "https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/main/deploy/standalone-install.yaml",
          "https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
        ]
        inlineManifests = [
          {
            name     = "hcloud-secret"
            contents = <<-EOT
              apiVersion: v1
              kind: Secret
              metadata:
                name: hcloud
                namespace: kube-system
              type: Opaque
              data:
                token: ${base64encode(var.hcloud_token)}
                network: ${base64encode(hcloud_network.default.name)}
            EOT
          }
        ]
        externalCloudProvider = {
          enabled = true
          manifests = [
            "https://github.com/hetznercloud/hcloud-cloud-controller-manager/releases/latest/download/ccm-networks.yaml"
          ]
        }
        allowSchedulingOnControlPlanes = true
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
          extraMounts = [
            {
              destination = "/var/mnt/local-storage-provisioner"
              type        = "bind"
              source      = "/var/mnt/local-storage-provisioner"
              options     = ["bind", "rshared", "rw"]
            }
          ]
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

resource "talos_machine_configuration_apply" "this" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  node                        = hcloud_server.controlplane.0.ipv4_address
}

resource "talos_machine_bootstrap" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = hcloud_server.controlplane.0.ipv4_address
  node                 = hcloud_server.controlplane.0.ipv4_address

  depends_on = [hcloud_server.controlplane.0]
}

resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = hcloud_server.controlplane.0.ipv4_address
  node                 = hcloud_server.controlplane.0.ipv4_address

  depends_on = [talos_machine_bootstrap.this]
}