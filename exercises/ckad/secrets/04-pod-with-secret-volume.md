# Exercise 4: Pod with Secret as Volume (★★☆)

Time: 6-8 minutes

## Task

1. Create a secret named `tls-secret` with:
   - `tls.crt=-----BEGIN CERTIFICATE----- fake-cert -----END CERTIFICATE-----`
   - `tls.key=-----BEGIN PRIVATE KEY----- fake-key -----END PRIVATE KEY-----`
2. Create a pod named `web-server` with image `nginx:alpine`
3. Mount the secret as a volume at `/etc/nginx/ssl/`
4. Verify the certificate files are mounted correctly

## Hint

Mount secrets as volumes similar to ConfigMaps: define volume with `secret` source and mount it in the container.
Each key in the secret becomes a file in the mount directory.

## Verification

Check that:

- Secret exists: `kubectl get secret tls-secret`
- Pod is running: `kubectl get pod web-server`
- Files are mounted: `kubectl exec web-server -- ls /etc/nginx/ssl/`
- Certificate content: `kubectl exec web-server -- cat /etc/nginx/ssl/tls.crt`
- Key content: `kubectl exec web-server -- cat /etc/nginx/ssl/tls.key`
- Verify permissions (should be restrictive): `kubectl exec web-server -- ls -la /etc/nginx/ssl/`

**Useful commands:** `kubectl exec`, `kubectl describe secret`, `kubectl get pod`
