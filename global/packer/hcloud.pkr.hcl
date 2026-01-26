
packer {
  required_plugins {
    hcloud = {
      source  = "github.com/hetznercloud/hcloud"
      version = "~> 1"
    }
  }
}

variable "talos_version" {
  type    = string
  default = "v1.12.2"
}

variable "arch" {
  type    = string
  default = "arm64"
}

variable "server_type" {
  type    = string
  default = "cax11"
}

variable "server_location" {
  type    = string
  default = "nbg1"
}

locals {
  image = "https://factory.talos.dev/image/ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515/${var.talos_version}/hcloud-${var.arch}.raw.xz"
}

source "hcloud" "talos" {
  rescue       = "linux64"
  image        = "debian-11"
  location     = "${var.server_location}"
  server_type  = "${var.server_type}"
  ssh_username = "root"

  snapshot_name   = "talos system disk - ${var.arch} - ${var.talos_version}"
  snapshot_labels = {
    type    = "infra",
    os      = "talos",
    version = "${var.talos_version}",
    arch    = "${var.arch}",
  }
}

build {
  sources = ["source.hcloud.talos"]

  provisioner "shell" {
    inline = [
      "apt-get install -y wget",
      "wget -O /tmp/talos.raw.xz ${local.image}",
      "xz -d -c /tmp/talos.raw.xz | dd of=/dev/sda && sync",
    ]
  }
}
