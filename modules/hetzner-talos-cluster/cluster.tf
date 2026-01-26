resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  machine_type     = "controlplane"
  cluster_endpoint = "https://${hcloud_primary_ip.main.0.ip_address}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets

  config_patches = concat([
    yamlencode({
      cluster = {
        network = {
          podSubnets     = [var.pod_cidr]
          serviceSubnets = [var.service_cidr]
        }
        apiServer = {
          extraArgs = {
            enable-admission-plugins = "NodeRestriction"
          }
          certSANs = [
            hcloud_primary_ip.main[0].ip_address,
            hcloud_load_balancer_network.lb_network.ip,
            var.additional_cert_san != "" ? var.additional_cert_san : null
          ]
        }
        extraManifests = var.extra_manifests
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
        allowSchedulingOnControlPlanes = var.allow_scheduling_on_control_planes
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
  ], var.controlplane_config_patches)
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = hcloud_server.controlplane[*].ipv4_address
}

resource "talos_machine_configuration_apply" "controlplane" {
  count                       = var.controller_count
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  node                        = hcloud_server.controlplane[count.index].ipv4_address
}

resource "talos_machine_bootstrap" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = hcloud_server.controlplane.0.ipv4_address
  node                 = hcloud_server.controlplane.0.ipv4_address

  depends_on = [talos_machine_configuration_apply.controlplane]
}

resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = hcloud_server.controlplane.0.ipv4_address
  node                 = hcloud_server.controlplane.0.ipv4_address

  depends_on = [talos_machine_bootstrap.this]
}

# worker configuration
data "talos_machine_configuration" "worker" {
  count            = var.worker_count > 0 ? 1 : 0
  cluster_name     = var.cluster_name
  machine_type     = "worker"
  cluster_endpoint = "https://${hcloud_primary_ip.main.0.ip_address}:6443"
  machine_secrets  = talos_machine_secrets.this.machine_secrets

  config_patches = concat([
    yamlencode({
      machine = {
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
  ], var.worker_config_patches)
}

resource "talos_machine_configuration_apply" "worker" {
  count                       = var.worker_count
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker[0].machine_configuration
  node                        = hcloud_server.worker[count.index].ipv4_address

  depends_on = [talos_machine_bootstrap.this]
}
