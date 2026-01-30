module "cluster" {
  source = "../../modules/hetzner-talos-cluster"

  cluster_name     = var.cluster_name
  hcloud_token     = var.hcloud_token
  ssh_key_name     = var.ssh_key_name
  server_type      = var.server_type
  controller_count = var.cluster_controller_node_count

  hetzner_location             = var.hetzner_location
  hetzner_network_zone         = var.hetzner_network_zone
  hetzner_labels               = var.hetzner_labels
  cluster_network_range        = var.cluster_network_range
  cluster_network_subnet_range = var.cluster_network_subnet_range

  talos_image_selector     = var.talos_image_selector
  talos_image_architecture = var.talos_image_architecture

  allow_scheduling_on_control_planes = var.allow_scheduling_on_control_planes
  extra_manifests                    = var.extra_manifests

  extra_firewall_rules = [
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "80"
      source_ips = ["0.0.0.0/0"]
    },
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "443"
      source_ips = ["0.0.0.0/0"]
    },
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "3478"
      source_ips = ["0.0.0.0/0"]
    },
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "5349"
      source_ips = ["0.0.0.0/0"]
    },
    {
      direction  = "in"
      protocol   = "udp"
      port       = "5349"
      source_ips = ["0.0.0.0/0"]
    },
    {
      direction  = "in"
      protocol   = "udp"
      port       = "3478"
      source_ips = ["0.0.0.0/0"]
    },
    {
      direction  = "in"
      protocol   = "udp"
      port       = "49152-65535"
      source_ips = ["0.0.0.0/0"]
    }
  ]
}
