# Ceph Dashboard OAuth 2.0 (Ceph v20+)

Ceph v20 (Tentacle) adds native OAuth 2.0 support for the Ceph Dashboard.

## How it works in Ceph v20

For **cephadm-managed clusters**, Ceph v20 introduces:
- `oauth2-proxy` service - handles OIDC authentication
- `mgmt-gateway` service - nginx reverse proxy that fronts Dashboard, Prometheus, Grafana, Alertmanager

This provides centralized authentication and SSO for all Ceph management interfaces.

## How it works in Rook (this cluster)

Since Rook manages Ceph on Kubernetes, we use the Kubernetes-native approach:

1. **oauth2-proxy** - Already deployed in `oauth2-proxy` namespace
2. **Dex** - OIDC provider at `auth.konst.fish` 
3. **Istio AuthorizationPolicy** - Requires oauth2-proxy authentication for protected hosts

### Protected Services

The following services require OAuth authentication via the `shoal-konst-fish:facultative` GitHub org/team:

- `rook.barracuda.net.konst.fish` - **Ceph Dashboard** 
- `grafana.barracuda.net.konst.fish` - Grafana
- `kiali.barracuda.net.konst.fish` - Kiali (Istio dashboard)
- `zeppelin.barracuda.net.konst.fish` - Zeppelin

### Configuration

OAuth protection is configured in:
- `gitops/infra/ingress/istio-gateway/overlays/barracuda/authorizationpolicy.yaml`

The AuthorizationPolicy uses Istio's external authorization with oauth2-proxy to:
1. Redirect unauthenticated users to Dex for login
2. Verify JWT tokens from authenticated users
3. Check group membership (`shoal-konst-fish:facultative`)

## References

- [Ceph v20 Release Notes - Dashboard OAuth](https://docs.ceph.com/en/latest/releases/tentacle/)
- [Ceph oauth2-proxy Service](https://docs.ceph.com/en/latest/cephadm/services/oauth2-proxy/)
- [Istio External Authorization](https://istio.io/latest/docs/tasks/security/authorization/authz-custom/)
