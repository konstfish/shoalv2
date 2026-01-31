# Ceph Object Store with OAuth Support (Ceph v20+)

This document explains the OAuth/OIDC options available for Ceph Object Store (RGW).

## Overview

Ceph v20+ supports **native STS (Security Token Service)** with OIDC via `AssumeRoleWithWebIdentity`. This allows apps to exchange OIDC tokens for temporary S3 credentials.

However, for simpler use cases, you can also use **oauth2-proxy** in front of RGW.

## Access Options

### Option 1: Internal Access Only (No OAuth)
Access RGW from within the cluster using the service:
```
rook-ceph-rgw-ceph-objectstore.rook-ceph.svc.cluster.local:80
```

### Option 2: External Access with oauth2-proxy
Protect RGW with your existing oauth2-proxy. Add an HTTPRoute that goes through oauth2-proxy before reaching RGW.

### Option 3: Native STS/OIDC (Advanced)
For programmatic S3 SDK access with temporary credentials:

1. Register your OIDC provider (Dex) with RGW
2. Create IAM roles with trust policies
3. Apps call `AssumeRoleWithWebIdentity` with their JWT to get temp S3 creds

See [Ceph STS docs](https://docs.ceph.com/en/latest/radosgw/STS/) for details.

## Getting Admin Credentials

```bash
# Access Key
kubectl get secret -n rook-ceph rook-ceph-object-user-ceph-objectstore-ceph-objectstore-admin \
  -o jsonpath='{.data.AccessKey}' | base64 -d

# Secret Key  
kubectl get secret -n rook-ceph rook-ceph-object-user-ceph-objectstore-ceph-objectstore-admin \
  -o jsonpath='{.data.SecretKey}' | base64 -d
```

## Creating Buckets

Using ObjectBucketClaim (OBC):
```yaml
apiVersion: objectbucket.io/v1alpha1
kind: ObjectBucketClaim
metadata:
  name: my-bucket
spec:
  generateBucketName: my-bucket
  storageClassName: rook-ceph-bucket
```

## References

- [Ceph STS Documentation](https://docs.ceph.com/en/latest/radosgw/STS/)
- [Rook Object Store Docs](https://rook.io/docs/rook/latest/Storage-Configuration/Object-Storage-RGW/object-storage/)
