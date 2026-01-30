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
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24"
    }
  }
}

provider "http" {}

provider "hcloud" {
  token = var.hcloud_token
}

provider "talos" {}

provider "helm" {
  kubernetes {
    host                   = module.cluster.kubernetes_client_configuration.host
    client_certificate     = base64decode(module.cluster.kubernetes_client_configuration.client_certificate)
    client_key             = base64decode(module.cluster.kubernetes_client_configuration.client_key)
    cluster_ca_certificate = base64decode(module.cluster.kubernetes_client_configuration.ca_certificate)
  }
}

provider "kubernetes" {
  host                   = module.cluster.kubernetes_client_configuration.host
  client_certificate     = base64decode(module.cluster.kubernetes_client_configuration.client_certificate)
  client_key             = base64decode(module.cluster.kubernetes_client_configuration.client_key)
  cluster_ca_certificate = base64decode(module.cluster.kubernetes_client_configuration.ca_certificate)
}
