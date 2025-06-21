variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  type        = string
  sensitive   = true
}

variable "github_usernames" {
  description = "List of GitHub usernames"
  type        = list(string)
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = "sardine"
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

// network
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
  description = "The network zone where the resources will be created."
  type        = string
  default     = "eu-central"
}

// cluster
variable "cluster_controller_node_count" {
  description = "The number of controller nodes in the cluster"
  type        = number
  default     = 1
}

