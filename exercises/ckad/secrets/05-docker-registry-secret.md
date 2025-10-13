# Exercise 5: Docker Registry Secret (★★★)

Time: 7-9 minutes

## Task

1. Create a docker-registry secret named `registry-secret` with:
   - Docker server: `https://index.docker.io/v1/`
   - Username: `myuser`
   - Password: `mypassword`
   - Email: `myuser@example.com`
2. Create a pod named `private-app` that:
   - Uses image `nginx:alpine` (for testing, normally this would be a private image)
   - References the docker-registry secret in `imagePullSecrets`
3. Verify the secret is correctly formatted for docker authentication
4. Confirm the pod references the secret

## Hint

Use `kubectl create secret docker-registry` with flags for server, username, password, and email.
Reference it in pod spec with `imagePullSecrets[].name`.

## Verification

Check that:

- Secret exists: `kubectl get secret registry-secret`
- Secret type is docker: `kubectl get secret registry-secret -o jsonpath='{.type}'`
- Contains .dockerconfigjson: `kubectl describe secret registry-secret`
- Pod is created: `kubectl get pod private-app`
- Pod references secret: `kubectl get pod private-app -o jsonpath='{.spec.imagePullSecrets[0].name}'`
- Verify secret format: `kubectl get secret registry-secret -o jsonpath='{.data.\.dockerconfigjson}' | base64 -d`

**Useful commands:** `kubectl create secret docker-registry`, `kubectl describe secret`, `kubectl get pod -o yaml`
