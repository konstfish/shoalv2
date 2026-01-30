helm upgrade --install --create-namespace -f values.yaml -n netbird-operator netbird-operator netbirdio/kubernetes-operator

kubectl -n netbird-operator create secret generic netbird-mgmt-api-key --from-literal=NB_API_KEY=

## purge

kubectl get nbgroups,nbpolicies,nbresources,nbroutingpeers,nbsetupkeys --all-namespaces -o jsonpath='{range .items[*]}{.metadata.namespace}{" "}{.kind}/{.metadata.name}{"\n"}{end}' | xargs -n2 sh -c 'kubectl patch $1 -n $0 --type=merge -p="{\"metadata\":{\"finalizers\":null}}"'
kubectl delete nbgroups --all --all-namespaces
kubectl delete nbpolicies --all --all-namespaces
kubectl delete nbresources --all --all-namespaces
kubectl delete nbroutingpeers --all --all-namespaces
kubectl delete nbsetupkeys --all --all-namespaces