# cni & coredns

# opt cilium
cilium install \
    --set ipam.mode=kubernetes \
    --set kubeProxyReplacement=true \
    --set k8sServiceHost=10.24.0.5 \
    --set k8sServicePort=6443 \
    --set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
    --set securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
    --set cgroup.autoMount.enabled=false \
    --set cgroup.hostRoot=/sys/fs/cgroup

# sealed secrets
k create ns sealed-secrets
pass shoal_etc/sskey | k apply -f -

# gitops
k apply -k gitops/infra/management/argocd/base
k rollout restart deployment -n cluster-infra-argocd
k rollout restart statefulset -n cluster-infra-argocd

k apply -f bootstrap/argo-bootstrap-app.yaml

# etc

k apply -f bootstrap/etc

# helm install olm oci://ghcr.io/cloudtooling/helm-charts/olm --version 0.31.0 --set namespace=olm --set catalog_namespace=olm --set operator_namespace=operators
