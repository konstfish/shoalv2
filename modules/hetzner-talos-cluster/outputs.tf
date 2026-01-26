output "talosconfig" {
  description = "Talos client configuration"
  value       = data.talos_client_configuration.this.talos_config
  sensitive   = true
}

output "kubeconfig" {
  description = "Kubernetes configuration"
  value       = talos_cluster_kubeconfig.this.kubeconfig_raw
  sensitive   = true
}

output "kubernetes_client_configuration" {
  description = "Kubernetes client configuration for provider setup"
  value       = talos_cluster_kubeconfig.this.kubernetes_client_configuration
  sensitive   = true
}

output "cluster_endpoint" {
  description = "The Kubernetes API endpoint"
  value       = "https://${hcloud_primary_ip.main.0.ip_address}:6443"
}

output "controlplane_ips" {
  description = "Public IP addresses of control plane nodes"
  value       = hcloud_server.controlplane[*].ipv4_address
}

output "worker_ips" {
  description = "Public IP addresses of worker nodes"
  value       = hcloud_server.worker[*].ipv4_address
}

output "network_id" {
  description = "The Hetzner network ID"
  value       = hcloud_network.default.id
}

output "network_name" {
  description = "The Hetzner network name"
  value       = hcloud_network.default.name
}
