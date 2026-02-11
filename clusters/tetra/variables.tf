variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = "tetra"
}

variable "ssh_key_name" {
  description = "Name of the Hetzner SSH key to use"
  type        = string
  default     = "konstfish"
}

variable "server_type" {
  description = "Hetzner Cloud server type"
  type        = string
  default     = "cax21"
}

variable "hetzner_location" {
  description = "Hetzner Cloud server location"
  type        = string
  default     = "nbg1"
}

variable "hetzner_labels" {
  description = "Hetzner common labels"
  type        = map(string)
  default = {
    "created_by" = "terraform"
  }
}

variable "cluster_network_range" {
  description = "The CIDR for the cluster network"
  type        = string
  default     = "10.24.0.0/24"
}

variable "cluster_network_subnet_range" {
  description = "The CIDR for the cluster subnet"
  type        = string
  default     = "10.24.0.0/24"
}

variable "hetzner_network_zone" {
  description = "The network zone where the resources will be created"
  type        = string
  default     = "eu-central"
}

variable "controller_count" {
  description = "The number of controller nodes in the cluster"
  type        = number
  default     = 3
}

variable "worker_count" {
  description = "The number of worker nodes in the cluster"
  type        = number
  default     = 3
}

variable "talos_image_selector" {
  description = "Selector for the Talos image"
  type        = string
  default     = "os=talos"
}

variable "talos_image_architecture" {
  description = "Architecture for the Talos image"
  type        = string
  default     = "arm"
}

variable "allow_scheduling_on_control_planes" {
  description = "Allow scheduling workloads on control plane nodes"
  type        = bool
  default     = true
}

variable "extra_manifests" {
  description = "Extra manifests to deploy on the cluster"
  type        = list(string)
  default = [
    "https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/main/deploy/standalone-install.yaml",
    "https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
  ]
}
