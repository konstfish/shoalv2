resource "helm_release" "argocd" {
  depends_on = [talos_cluster_kubeconfig.this]

  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"

  create_namespace = true

  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "server.ingress.enabled"
    value = "false"
  }

  set {
    name  = "dex.enabled"
    value = "false"
  }

  set {
    name  = "server.insecure"
    value = "true"
  }

  set {
    name  = "configs.params.server.insecure"
    value = "true"
  }

  timeout = 600
}