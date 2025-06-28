helm install olm oci://ghcr.io/cloudtooling/helm-charts/olm --version 0.31.0 --set namespace=olm --set catalog_namespace=olm --set operator_namespace=operators

k apply -f gitops/infra/management/argocd/base

k apply -f argo-bootstrap-app.yaml