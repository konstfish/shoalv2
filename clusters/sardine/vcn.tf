
resource "hcloud_network" "default" {
  name     = "vcn-${var.cluster_name}"
  ip_range = var.cluster_network_range
  labels   = var.hetzner_labels
}

resource "hcloud_network_subnet" "cluster_network" {
  type         = "cloud"
  network_id   = hcloud_network.default.id
  network_zone = var.hetzner_network_zone
  ip_range     = var.cluster_network_subnet_range
}

resource "hcloud_firewall" "default" {
  name = "vcn-firewall-${var.cluster_name}"
  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "50000"
    source_ips = [join("/", [data.http.runner_public_ip.response_body, "32"]), "159.69.94.229/32"]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "6443"
    source_ips = [join("/", [data.http.runner_public_ip.response_body, "32"]), "159.69.94.229/32"]
  }
}