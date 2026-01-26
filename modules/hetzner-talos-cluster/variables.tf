variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "server_type" {
  description = "Hetzner Cloud server type"
  type        = string
  default     = "cax31"
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
  default     = "10.23.0.0/24"
}

variable "cluster_network_subnet_range" {
  description = "The CIDR for the cluster subnet"
  type        = string
  default     = "10.23.0.0/24"
}

variable "hetzner_network_zone" {
  description = "The network zone where the resources will be created"
  type        = string
  default     = "eu-central"
}

variable "controller_count" {
  description = "The number of controller nodes in the cluster"
  type        = number
  default     = 1
}

variable "worker_count" {
  description = "The number of worker nodes in the cluster"
  type        = number
  default     = 0
}

variable "worker_server_type" {
  description = "Hetzner Cloud server type for worker nodes"
  type        = string
  default     = "cax21"
}

variable "ssh_key_name" {
  description = "Name of the Hetzner SSH key to use"
  type        = string
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

variable "pod_cidr" {
  description = "CIDR for pod network"
  type        = string
  default     = "10.244.0.0/16"
}

variable "service_cidr" {
  description = "CIDR for service network"
  type        = string
  default     = "10.96.0.0/12"
}

variable "extra_firewall_rules" {
  description = "Additional firewall rules to add"
  type = list(object({
    direction   = string
    protocol    = string
    port        = optional(string)
    source_ips  = list(string)
    description = optional(string)
  }))
  default = []
}

variable "extra_manifests" {
  description = "Extra manifests to deploy on the cluster"
  type        = list(string)
  default = [
    "https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/main/deploy/standalone-install.yaml",
    "https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
  ]
}

variable "controlplane_config_patches" {
  description = "Additional Talos config patches for controlplane nodes (list of YAML strings)"
  type        = list(string)
  default     = []
}

variable "worker_config_patches" {
  description = "Additional Talos config patches for worker nodes (list of YAML strings)"
  type        = list(string)
  default     = []
}

variable "cluster_load_balancer_type" {
  description = "The type of load balancer to create."
  type        = string
  default     = "lb11"
}

variable "additional_cert_san" {
  description = "Additional SAN to add to the API server certificate"
  type        = string
  default     = ""
}