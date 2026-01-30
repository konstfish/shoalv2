output "talosconfig" {
  description = "Talos client configuration"
  value       = module.cluster.talosconfig
  sensitive   = true
}

output "kubeconfig" {
  description = "Kubernetes configuration"
  value       = module.cluster.kubeconfig
  sensitive   = true
}

output "cluster_endpoint" {
  description = "The Kubernetes API endpoint"
  value       = module.cluster.cluster_endpoint
}

output "controlplane_ips" {
  description = "Public IP addresses of control plane nodes"
  value       = module.cluster.controlplane_ips
}
