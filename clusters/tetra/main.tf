module "cluster" {
  source = "../../modules/hetzner-talos-cluster"

  cluster_name     = var.cluster_name
  hcloud_token     = var.hcloud_token
  ssh_key_name     = var.ssh_key_name
  server_type      = var.server_type
  controller_count = 2 #var.controller_count
  worker_count     = var.worker_count

  hetzner_location             = var.hetzner_location
  hetzner_network_zone         = var.hetzner_network_zone
  hetzner_labels               = var.hetzner_labels
  cluster_network_range        = var.cluster_network_range
  cluster_network_subnet_range = var.cluster_network_subnet_range

  talos_image_selector     = var.talos_image_selector
  talos_image_architecture = var.talos_image_architecture

  allow_scheduling_on_control_planes = var.allow_scheduling_on_control_planes
  extra_manifests                    = var.extra_manifests

  pod_cidr = "10.240.0.0/16"
  service_cidr = "10.94.0.0/16"

  additional_cert_san = "kubernetes.default.svc.tetra.local"

  controlplane_config_patches = [
    yamlencode({
      cluster = {
        network = {
          cni = {
            name = "none"
          }
        }
        proxy = {
          disabled = true
        }
      }
      machine = {
        sysctls = {
          "vm.max_map_count" = "262144"
        }
      }
    })
  ]
}