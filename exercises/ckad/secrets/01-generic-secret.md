# Exercise 1: Create Generic Secret (★☆☆)

Time: 3-4 minutes

## Task

1. Create a generic secret named `db-secret` with the following data:
   - `username=admin`
   - `password=MySecurePass123`
2. Verify the secret is created
3. View the secret and note that values are base64 encoded
4. Decode the password to verify it's correct

## Hint

Use `kubectl create secret generic` with `--from-literal` flags. Secrets are automatically base64 encoded.
Use `kubectl get secret <name> -o jsonpath='{.data.password}' | base64 -d` to decode.

## Verification

Check that:

- Secret exists: `kubectl get secret db-secret`
- Secret type is Opaque: `kubectl get secret db-secret -o jsonpath='{.type}'`
- Has both keys: `kubectl describe secret db-secret`
- Decode password: `kubectl get secret db-secret -o jsonpath='{.data.password}' | base64 -d`
- Values are base64 encoded in YAML: `kubectl get secret db-secret -o yaml`

**Useful commands:** `kubectl create secret generic`, `kubectl get secret`, `base64 -d`
