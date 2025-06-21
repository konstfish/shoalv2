data "hcloud_image" "talos" {
  with_selector     = "os=talos"
  with_architecture = "arm"
}

resource "hcloud_placement_group" "placement_group" {
  name   = "${var.cluster_name}-placement-group"
  type   = "spread"
  labels = var.hetzner_labels
}

resource "hcloud_primary_ip" "main" {
  count         = var.cluster_controller_node_count
  name          = "${var.cluster_name}-ctl-${count.index}"
  type          = "ipv4"
  datacenter    = "nbg1-dc3"
  assignee_type = "server"
  auto_delete   = true
  labels        = var.hetzner_labels
}

resource "hcloud_server" "controlplane" {
  count = var.cluster_controller_node_count
  name  = "${var.cluster_name}-ctl-${count.index}"
  image = data.hcloud_image.talos.id
  server_type = var.server_type
  location    = var.hetzner_location
  // ssh_keys           = keys(hcloud_ssh_key.default)
  placement_group_id = hcloud_placement_group.placement_group.id

  user_data = data.talos_machine_configuration.controlplane.machine_configuration

  firewall_ids = [hcloud_firewall.default.id]

  network {
    network_id = hcloud_network.default.id
    ip         = cidrhost(var.cluster_network_subnet_range, count.index + 11)
  }

  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.main[count.index].id
    ipv6_enabled = false
  }

  labels = merge(
    var.hetzner_labels,
    {
      "cluster" = var.cluster_name
      "role"    = "controller"
    }
  )

  depends_on = [
    hcloud_network_subnet.cluster_network
  ]
}
