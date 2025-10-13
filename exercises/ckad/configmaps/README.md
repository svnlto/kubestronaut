# ConfigMap Exercises for CKAD

ConfigMaps provide a way to inject configuration data into pods. They decouple configuration from container images,
making applications more portable and easier to manage. Understanding how to create and consume ConfigMaps is
essential for CKAD.

## Exercises

1. [ConfigMap from Literals](01-literal-configmap.md) (★☆☆) - 3-4 minutes
2. [ConfigMap from File](02-configmap-from-file.md) (★☆☆) - 4-5 minutes
3. [Pod with ConfigMap as Environment Variables](03-pod-with-env-configmap.md) (★★☆) - 5-7 minutes
4. [Pod with ConfigMap as Volume](04-pod-with-volume-configmap.md) (★★☆) - 6-8 minutes
5. [Update ConfigMap and Observe Changes](05-update-configmap.md) (★★★) - 7-9 minutes

## Quick Reference

**Essential Commands:**

```bash
# Create from literal values
kubectl create configmap app-config --from-literal=key1=value1 --from-literal=key2=value2

# Create from file (file name becomes key)
kubectl create configmap app-config --from-file=app.properties

# Create from file with custom key
kubectl create configmap app-config --from-file=mykey=app.properties

# Create from directory (all files)
kubectl create configmap app-config --from-file=config-dir/

# Create from env file (KEY=value format)
kubectl create configmap app-config --from-env-file=app.env

# Get ConfigMaps
kubectl get configmap
kubectl get cm app-config
kubectl describe configmap app-config
kubectl get configmap app-config -o yaml

# Edit ConfigMap
kubectl edit configmap app-config

# Delete ConfigMap
kubectl delete configmap app-config
```

**ConfigMap YAML Structure:**

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  # Simple key-value pairs
  app_mode: "production"
  log_level: "info"

  # File-like data
  app.properties: |
    database.host=localhost
    database.port=5432
    database.name=myapp

  nginx.conf: |
    server {
        listen 80;
        server_name localhost;
    }
```

**Using ConfigMap as Environment Variables:**

```yaml
# Option 1: Individual keys
apiVersion: v1
kind: Pod
metadata:
  name: env-pod
spec:
  containers:
  - name: app
    image: busybox
    env:
    - name: APP_MODE
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: app_mode
    - name: LOG_LEVEL
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: log_level

# Option 2: All keys at once
apiVersion: v1
kind: Pod
metadata:
  name: env-pod
spec:
  containers:
  - name: app
    image: busybox
    envFrom:
    - configMapRef:
        name: app-config
```

**Using ConfigMap as Volume:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: volume-pod
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: config-volume
      mountPath: /etc/config
  volumes:
  - name: config-volume
    configMap:
      name: app-config
      # Optional: select specific keys
      items:
      - key: nginx.conf
        path: nginx.conf
```

## ConfigMap Creation Methods

### 1. From Literal Values

```bash
kubectl create configmap my-config \
  --from-literal=key1=value1 \
  --from-literal=key2=value2
```

- **Use case:** Simple key-value pairs
- **Best for:** Quick configuration, small values

### 2. From File

```bash
# File name becomes the key
kubectl create configmap my-config --from-file=app.properties

# Custom key name
kubectl create configmap my-config --from-file=config=app.properties
```

- **Use case:** Configuration files
- **Best for:** Existing config files (nginx.conf, application.yaml, etc.)

### 3. From Directory

```bash
kubectl create configmap my-config --from-file=config-dir/
```

- **Use case:** Multiple configuration files
- **Best for:** Entire config directories

### 4. From Env File

```bash
# File format: KEY=value (one per line)
kubectl create configmap my-config --from-env-file=app.env
```

- **Use case:** Environment variable files
- **Best for:** .env style configurations

### 5. From YAML

```bash
kubectl apply -f configmap.yaml
```

- **Use case:** Complex configurations, version control
- **Best for:** Production deployments, GitOps

## Consuming ConfigMaps

### Environment Variables

**Pros:**

- Simple to use
- Works with all applications
- Good for simple key-value configs

**Cons:**

- Static (doesn't update without pod restart)
- Not suitable for large files
- All values loaded into memory

**When to use:** Simple configuration values, API keys, flags

### Volume Mounts

**Pros:**

- Updates automatically (with delay)
- Good for large files
- Can mount specific keys
- Supports file permissions

**Cons:**

- More complex setup
- Sync delay (up to 60s)
- Application must handle file changes

**When to use:** Configuration files, certificates, frequently changing configs

## ConfigMap Update Behavior

| Method | Updates Automatically? | Requires Pod Restart? |
|--------|----------------------|---------------------|
| Environment Variable | No | Yes |
| Volume Mount | Yes (with delay) | No (app must reload) |

**Volume Mount Update Delay:**

- Kubelet sync period: typically 60 seconds
- Atomic update: symlink swap
- Application must watch for changes or reload config

## Common Exam Scenarios

1. **Create ConfigMap from literal values**
   - Fastest: `kubectl create configmap --from-literal=key=value`
   - Can chain multiple `--from-literal` flags

2. **Create ConfigMap from file**
   - Use `kubectl create configmap --from-file=filename`
   - File name becomes the key automatically

3. **Inject ConfigMap as environment variables**
   - Use `envFrom.configMapRef` for all keys
   - Use `env[].valueFrom.configMapKeyRef` for specific keys

4. **Mount ConfigMap as volume**
   - Define volume with `configMap` source
   - Mount in container with `volumeMounts`
   - Each key becomes a file

5. **Update ConfigMap**
   - Use `kubectl edit configmap <name>`
   - Or `kubectl patch configmap <name>`
   - Volume mounts update automatically, env vars don't

6. **Mount specific ConfigMap keys**
   - Use `volumes[].configMap.items[]` to select keys
   - Specify `key` and `path` for each item

## Tips for CKAD Exam

✅ **DO:**

- Use imperative commands for quick ConfigMap creation
- Use `--from-literal` for simple key-value pairs
- Use `--from-file` when you have configuration files
- Remember: `envFrom` loads all keys, `env[].valueFrom` loads specific keys
- Test ConfigMap content: `kubectl get configmap <name> -o yaml`
- Use volume mounts for large configs or files that need updates
- Use env vars for simple, static configuration
- Know that volume-mounted ConfigMaps update automatically
- Remember to create ConfigMap before creating pods that use it

❌ **DON'T:**

- Don't use ConfigMaps for sensitive data (use Secrets instead)
- Don't forget the key name when using `configMapKeyRef`
- Don't expect environment variables to update (they're static)
- Don't put binary data in ConfigMaps (use Secrets with type Opaque)
- Don't forget ConfigMaps are namespace-scoped
- Don't create huge ConfigMaps (1MB limit)
- Don't forget that file name becomes key when using `--from-file`
- Don't mount ConfigMap at `/` or other critical system paths

## ConfigMap Immutability

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: immutable-config
data:
  key: value
immutable: true  # Cannot be updated
```

**Benefits:**

- Protects against accidental updates
- Better performance (no watches needed)
- Use case: Known-good configurations

**Note:** Once set to immutable, you must delete and recreate to change data.

## Troubleshooting ConfigMaps

| Issue | Possible Causes | How to Debug |
|-------|-----------------|--------------|
| Pod won't start | ConfigMap doesn't exist | `kubectl get configmap`, check pod events |
| Missing env vars | Wrong key name, wrong ConfigMap name | `kubectl exec -- env`, check YAML |
| File not in volume | Wrong mount path, wrong ConfigMap | `kubectl exec -- ls <mount-path>` |
| Updates not appearing | Using env vars (static) | Use volume mounts instead |
| ConfigMap too large | Over 1MB limit | Split into multiple ConfigMaps |

## Quick Debugging Workflow

```bash
# 1. Check ConfigMap exists
kubectl get configmap <name>

# 2. View ConfigMap data
kubectl get configmap <name> -o yaml

# 3. Check pod references correct ConfigMap
kubectl get pod <name> -o yaml | grep -A 5 configMap

# 4. Check if mounted correctly
kubectl exec <pod> -- ls <mount-path>

# 5. Check environment variables
kubectl exec <pod> -- env

# 6. Check pod events for errors
kubectl describe pod <name>
```

## Advanced Usage

### Mount Specific Keys

```yaml
volumes:
- name: config
  configMap:
    name: app-config
    items:
    - key: app.properties
      path: application.properties  # Rename file
    - key: log.conf
      path: config/logging.conf     # Subdirectory
```

### Set File Permissions

```yaml
volumes:
- name: config
  configMap:
    name: app-config
    defaultMode: 0644  # Octal format
```

### Optional ConfigMap

```yaml
env:
- name: CONFIG_KEY
  valueFrom:
    configMapKeyRef:
      name: optional-config
      key: some-key
      optional: true  # Pod starts even if ConfigMap missing
```

## Time-Saving Tips

```bash
# Quick ConfigMap creation
k create cm app-config --from-literal=key=value

# Generate YAML
k create cm app-config --from-literal=key=value --dry-run=client -o yaml > cm.yaml

# View specific key
k get cm app-config -o jsonpath='{.data.key}'

# Create from multiple files
k create cm app-config --from-file=file1.txt --from-file=file2.txt

# Test env vars quickly
k run test --image=busybox --rm -it --restart=Never --env="KEY=value" -- env

# Update ConfigMap quickly
k patch cm app-config -p '{"data":{"key":"new-value"}}'
```
