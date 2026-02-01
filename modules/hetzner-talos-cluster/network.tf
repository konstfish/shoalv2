data "http" "runner_public_ip" {
  url = "https://api.ipify.org"
}

data "hcloud_ssh_key" "default" {
  name = var.ssh_key_name
}

resource "hcloud_network" "default" {
  name     = "vcn-${var.cluster_name}"
  ip_range = "10.0.0.0/8" // var.cluster_network_range
  labels   = var.hetzner_labels
}

resource "hcloud_network_subnet" "cluster_network" {
  type         = "cloud"
  network_id   = hcloud_network.default.id
  network_zone = var.hetzner_network_zone
  ip_range     = var.cluster_network_subnet_range
}

// need these two in the network - https://github.com/hetznercloud/hcloud-cloud-controller-manager/blob/8045e966bcab485efe2b37e4b12ec06cb7019dcc/docs/explanation/private-networks.md
// nvm don't need the extra sub networks, enough to just make the main one a /8 
// these conflict with the CCM
/*resource "hcloud_network_subnet" "pod_network" {
  type         = "cloud"
  network_id   = hcloud_network.default.id
  network_zone = var.hetzner_network_zone
  ip_range     = var.pod_cidr
}

resource "hcloud_network_subnet" "service_network" {
  type         = "cloud"
  network_id   = hcloud_network.default.id
  network_zone = var.hetzner_network_zone
  ip_range     = var.service_cidr
}*/

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
    source_ips = [join("/", [data.http.runner_public_ip.response_body, "32"])]
  }

  rule {
    direction  = "in"
    protocol   = "tcp"
    port       = "6443"
    source_ips = [join("/", [data.http.runner_public_ip.response_body, "32"])]
  }

  dynamic "rule" {
    for_each = var.extra_firewall_rules
    content {
      direction   = rule.value.direction
      protocol    = rule.value.protocol
      port        = rule.value.port
      source_ips  = rule.value.source_ips
      description = rule.value.description
    }
  }
}
