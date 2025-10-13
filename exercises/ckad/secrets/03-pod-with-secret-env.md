# Exercise 3: Pod with Secret as Environment Variables (★★☆)

Time: 5-7 minutes

## Task

1. Create a secret named `api-secret` with:
   - `api-key=ABC123XYZ`
   - `api-secret=SecretToken456`
2. Create a pod named `api-client` with image `busybox:1.35`
   - Command: `sh -c "echo API_KEY=$API_KEY; echo API_SECRET=$API_SECRET; sleep 3600"`
   - Load `api-key` from secret as env var `API_KEY`
   - Load `api-secret` from secret as env var `API_SECRET`
3. Verify the environment variables are set correctly

## Hint

Use `env[].valueFrom.secretKeyRef` to inject secret values as environment variables.
Similar to ConfigMap but uses `secretKeyRef` instead of `configMapKeyRef`.

## Verification

Check that:

- Secret exists: `kubectl get secret api-secret`
- Pod is running: `kubectl get pod api-client`
- Environment variables visible in logs: `kubectl logs api-client`
- Verify env vars: `kubectl exec api-client -- env | grep API`
- Values match secret: `kubectl get secret api-secret -o jsonpath='{.data.api-key}' | base64 -d`

**Useful commands:** `kubectl create secret generic`, `kubectl logs`, `kubectl exec`
