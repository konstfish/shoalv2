# cni & coredns

k apply -k gitops/infra/management/argocd/base
k rollout restart deployment -n cluster-infra-argocd
k rollout restart statefulset -n cluster-infra-argocd

k apply -f bootstrap/argo-bootstrap-app.yaml

k apply -f bootstrap/etc

# helm install olm oci://ghcr.io/cloudtooling/helm-charts/olm --version 0.31.0 --set namespace=olm --set catalog_namespace=olm --set operator_namespace=operators