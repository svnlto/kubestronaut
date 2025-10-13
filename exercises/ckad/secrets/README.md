# Secret Exercises for CKAD

Secrets are used to store and manage sensitive information like passwords, tokens, and keys. While similar to ConfigMaps,
Secrets are specifically designed for confidential data and offer additional security features.
Understanding Secret types and usage is crucial for CKAD.

## Exercises

1. [Create Generic Secret](01-generic-secret.md) (★☆☆) - 3-4 minutes
2. [Secret from File](02-secret-from-file.md) (★☆☆) - 4-5 minutes
3. [Pod with Secret as Environment Variables](03-pod-with-secret-env.md) (★★☆) - 5-7 minutes
4. [Pod with Secret as Volume](04-pod-with-secret-volume.md) (★★☆) - 6-8 minutes
5. [Docker Registry Secret](05-docker-registry-secret.md) (★★★) - 7-9 minutes

## Quick Reference

**Essential Commands:**

```bash
# Create generic secret from literals
kubectl create secret generic db-secret \
  --from-literal=username=admin \
  --from-literal=password=MyPassword123

# Create secret from file
kubectl create secret generic ssh-secret \
  --from-file=ssh-privatekey=~/.ssh/id_rsa \
  --from-file=ssh-publickey=~/.ssh/id_rsa.pub

# Create docker-registry secret
kubectl create secret docker-registry registry-secret \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=myuser \
  --docker-password=mypass \
  --docker-email=myuser@example.com

# Create TLS secret
kubectl create secret tls tls-secret \
  --cert=path/to/cert.crt \
  --key=path/to/cert.key

# Get secrets
kubectl get secrets
kubectl get secret db-secret
kubectl describe secret db-secret
kubectl get secret db-secret -o yaml

# Decode secret value
kubectl get secret db-secret -o jsonpath='{.data.password}' | base64 -d

# Edit secret
kubectl edit secret db-secret

# Delete secret
kubectl delete secret db-secret
```

**Secret Types:**

```bash
# Opaque (default) - arbitrary user data
kubectl create secret generic my-secret --from-literal=key=value

# docker-registry - Docker credentials
kubectl create secret docker-registry ...

# tls - TLS certificate and key
kubectl create secret tls ...

# service-account-token - Service account token
# (automatically created)

# bootstrap.kubernetes.io/token - Bootstrap token
# (for cluster bootstrapping)
```

**Generic Secret YAML:**

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
data:
  # Values must be base64 encoded
  username: YWRtaW4=        # admin
  password: cGFzc3dvcmQ=    # password

# Alternative: use stringData (auto-encoded)
stringData:
  username: admin           # Automatically base64 encoded
  password: password
```

**Docker Registry Secret:**

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: registry-secret
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: <base64-encoded-docker-config>
```

**TLS Secret:**

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: tls-secret
type: kubernetes.io/tls
data:
  tls.crt: <base64-encoded-cert>
  tls.key: <base64-encoded-key>
```

**Using Secret as Environment Variables:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-env-pod
spec:
  containers:
  - name: app
    image: nginx
    env:
    # Single value
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: password
    # All values
    envFrom:
    - secretRef:
        name: db-secret
```

**Using Secret as Volume:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: secret-volume-pod
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: secret-volume
      mountPath: /etc/secrets
      readOnly: true
  volumes:
  - name: secret-volume
    secret:
      secretName: db-secret
      # Optional: select specific keys
      items:
      - key: username
        path: my-username
      # Optional: set permissions
      defaultMode: 0400
```

**Using imagePullSecrets:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: private-image-pod
spec:
  containers:
  - name: app
    image: private-registry.com/app:v1
  imagePullSecrets:
  - name: registry-secret
```

## Secret Types

| Type | Purpose | Created With | Keys |
|------|---------|--------------|------|
| `Opaque` | Generic arbitrary data | `create secret generic` | User-defined |
| `kubernetes.io/dockerconfigjson` | Docker registry auth | `create secret docker-registry` | `.dockerconfigjson` |
| `kubernetes.io/tls` | TLS cert and key | `create secret tls` | `tls.crt`, `tls.key` |
| `kubernetes.io/service-account-token` | Service account token | Auto-generated | `token`, `ca.crt`, `namespace` |
| `kubernetes.io/basic-auth` | Basic authentication | Manual YAML | `username`, `password` |
| `kubernetes.io/ssh-auth` | SSH authentication | Manual YAML | `ssh-privatekey` |
| `bootstrap.kubernetes.io/token` | Bootstrap tokens | Manual YAML | Various |

## Secret vs ConfigMap

| Feature | Secret | ConfigMap |
|---------|--------|-----------|
| **Purpose** | Sensitive data | Configuration data |
| **Encoding** | Base64 encoded | Plain text |
| **Size limit** | 1MB | 1MB |
| **Security** | Can be encrypted at rest | Not encrypted |
| **Usage** | Passwords, keys, tokens | Config files, env vars |
| **Best for** | Credentials | Application config |

**Important:** Base64 is encoding, NOT encryption. Secrets are not secure by default - enable encryption at rest in production.

## Consuming Secrets

### Environment Variables

**Pros:**

- Simple and direct
- Works with any application
- Standard approach for credentials

**Cons:**

- Static (no updates without restart)
- Visible in pod spec
- Can appear in logs if not careful

**When to use:** API keys, database passwords, simple credentials

### Volume Mounts

**Pros:**

- Updates automatically (with delay)
- Better for certificates and keys
- More secure (file permissions)
- Hidden from pod spec

**Cons:**

- More complex setup
- Application must read from filesystem
- Sync delay

**When to use:** TLS certificates, SSH keys, large credential files

## Common Exam Scenarios

1. **Create secret from literal values**
   - Use `kubectl create secret generic --from-literal`
   - Multiple `--from-literal` flags for multiple values

2. **Create secret from files**
   - Use `kubectl create secret generic --from-file`
   - File name becomes the key

3. **Create docker-registry secret**
   - Use `kubectl create secret docker-registry`
   - Provide server, username, password, email

4. **Create TLS secret**
   - Use `kubectl create secret tls`
   - Provide cert and key files

5. **Inject secret as environment variables**
   - Use `env[].valueFrom.secretKeyRef`
   - Or `envFrom.secretRef` for all keys

6. **Mount secret as volume**
   - Define volume with `secret` source
   - Mount in container at specified path

7. **Use secret for private registry**
   - Create docker-registry secret
   - Reference in `imagePullSecrets`

## Tips for CKAD Exam

✅ **DO:**

- Use imperative commands for quick secret creation
- Use `--from-literal` for simple key-value pairs
- Use `--from-file` for certificates and keys
- Remember secret values are base64 encoded (but NOT encrypted)
- Test secret decoding: `kubectl get secret <name> -o jsonpath='{.data.key}' | base64 -d`
- Use volume mounts for TLS certificates
- Use env vars for simple credentials
- Use `stringData` in YAML to avoid manual base64 encoding
- Remember to create secret before creating pods that use it
- Use imagePullSecrets for private registries

❌ **DON'T:**

- Don't put non-sensitive data in Secrets (use ConfigMaps)
- Don't forget base64 encoding when creating secrets manually in YAML
- Don't confuse `data` (base64) with `stringData` (plain text)
- Don't expect environment variables from secrets to update automatically
- Don't hardcode credentials in pod specs
- Don't forget secrets are namespace-scoped
- Don't exceed 1MB size limit
- Don't log secret values
- Don't mount secrets at system-critical paths

## Base64 Encoding/Decoding

```bash
# Encode
echo -n "mypassword" | base64
# Output: bXlwYXNzd29yZA==

# Decode
echo "bXlwYXNzd29yZA==" | base64 -d
# Output: mypassword

# Get and decode secret
kubectl get secret db-secret -o jsonpath='{.data.password}' | base64 -d
```

**Important:** Use `-n` with echo to avoid encoding newline character.

## Using stringData

Instead of manually base64 encoding, use `stringData` in YAML:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: db-secret
type: Opaque
stringData:  # Plain text, automatically encoded
  username: admin
  password: MyPassword123
```

Kubernetes automatically converts `stringData` to base64 in `data` field.

## Immutable Secrets

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: immutable-secret
type: Opaque
data:
  key: dmFsdWU=
immutable: true  # Cannot be updated
```

**Benefits:**

- Protects against accidental updates
- Better performance
- Use case: Production credentials

## Troubleshooting Secrets

| Issue | Possible Causes | How to Debug |
|-------|-----------------|--------------|
| Pod won't start | Secret doesn't exist, wrong name | `kubectl describe pod`, check events |
| Missing env vars | Wrong key, wrong secret name | `kubectl exec -- env`, check YAML |
| Image pull error | Wrong registry secret, bad credentials | Check imagePullSecrets, describe pod |
| File not in volume | Wrong mount path, wrong secret | `kubectl exec -- ls <path>` |
| Wrong secret value | Base64 encoding error | Decode with `base64 -d` |

## Quick Debugging Workflow

```bash
# 1. Check secret exists
kubectl get secret <name>

# 2. Check secret type
kubectl get secret <name> -o jsonpath='{.type}'

# 3. List keys in secret
kubectl describe secret <name>

# 4. Decode specific value
kubectl get secret <name> -o jsonpath='{.data.key}' | base64 -d

# 5. Check pod references correct secret
kubectl get pod <name> -o yaml | grep -A 5 secret

# 6. Check if mounted correctly
kubectl exec <pod> -- ls <mount-path>

# 7. Check environment variables
kubectl exec <pod> -- env | grep <VAR>

# 8. Check pod events
kubectl describe pod <name>
```

## Security Best Practices

1. **Enable encryption at rest** (cluster-level)
2. **Use RBAC** to restrict secret access
3. **Don't commit secrets to version control**
4. **Use external secret management** (Vault, AWS Secrets Manager, etc.)
5. **Rotate secrets regularly**
6. **Use least privilege** - only grant access to needed secrets
7. **Audit secret access**
8. **Don't log secret values**
9. **Use volume mounts** instead of env vars when possible (more secure)
10. **Consider using ServiceAccount tokens** for pod-to-API auth

## Advanced Usage

### Mount Specific Secret Keys

```yaml
volumes:
- name: secret-volume
  secret:
    secretName: db-secret
    items:
    - key: username
      path: db-user
    - key: password
      path: db-pass
```

### Set File Permissions

```yaml
volumes:
- name: secret-volume
  secret:
    secretName: tls-secret
    defaultMode: 0400  # Read-only for owner
```

### Optional Secret

```yaml
env:
- name: API_KEY
  valueFrom:
    secretKeyRef:
      name: optional-secret
      key: api-key
      optional: true  # Pod starts even if secret missing
```

### Project Service Account Token

```yaml
volumes:
- name: token
  projected:
    sources:
    - serviceAccountToken:
        path: token
        expirationSeconds: 3600
```

## Time-Saving Tips

```bash
# Quick secret creation
k create secret generic db-secret --from-literal=password=pass123

# Generate YAML
k create secret generic db-secret --from-literal=password=pass123 --dry-run=client -o yaml

# Decode secret quickly
k get secret db-secret -o jsonpath='{.data.password}' | base64 -d

# Create from files
k create secret generic ssh-secret --from-file=id_rsa --from-file=id_rsa.pub

# Docker registry secret
k create secret docker-registry reg --docker-server=docker.io --docker-username=user --docker-password=pass

# TLS secret
k create secret tls tls-secret --cert=cert.crt --key=cert.key

# Update secret
k patch secret db-secret -p '{"stringData":{"password":"newpass"}}'
```
