# Exercise 2: Secret from File (★☆☆)

Time: 4-5 minutes

## Task

1. Create a file named `ssh-privatekey` with content:
   `-----BEGIN RSA PRIVATE KEY----- fake-key-content -----END RSA PRIVATE KEY-----`
2. Create a file named `ssh-publickey` with content: `ssh-rsa AAAAB3... fake-public-key`
3. Create a secret named `ssh-key-secret` from these files
4. Verify both keys are stored in the secret

## Hint

Use `kubectl create secret generic --from-file` to create secret from files. The filename becomes the key name in the secret.

## Verification

Check that:

- Secret exists: `kubectl get secret ssh-key-secret`
- Contains both keys: `kubectl describe secret ssh-key-secret`
- Private key content: `kubectl get secret ssh-key-secret -o jsonpath='{.data.ssh-privatekey}' | base64 -d`
- Public key content: `kubectl get secret ssh-key-secret -o jsonpath='{.data.ssh-publickey}' | base64 -d`

**Useful commands:** `kubectl create secret generic --from-file`, `kubectl get secret -o yaml`
