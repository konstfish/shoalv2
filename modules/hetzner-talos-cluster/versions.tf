terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.44"
    }
    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.10.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.5.0"
    }
  }
}
