# Kustomize Exercises for CKAD

Kustomize is a built-in Kubernetes configuration management tool that allows you to customize resource
configurations without modifying the original YAML files. It's essential for CKAD v1.33+ as it enables
efficient management of multiple environments (dev, staging, production) and configuration customization.
Kustomize is integrated directly into kubectl via the `-k` flag.

## Exercises

1. [Basic Kustomization](01-basic-kustomization.md) (★☆☆) - 5-7 minutes
2. [Base and Overlay Pattern](02-overlays.md) (★★☆) - 7-9 minutes
3. [Strategic Merge and JSON Patches](03-patches.md) (★★☆) - 8-10 minutes
4. [ConfigMaps and Secrets with Kustomize](04-configmaps-secrets.md) (★★☆) - 6-8 minutes
5. [Advanced Kustomize Features](05-advanced-customization.md) (★★★) - 10-12 minutes

## Quick Reference

### Essential Commands

```bash
# Apply Kustomize configuration
kubectl apply -k <directory>
kubectl apply -k ./base
kubectl apply -k ./overlays/dev

# Preview what will be applied (dry-run)
kubectl apply -k <directory> --dry-run=client
kubectl apply -k <directory> --dry-run=server

# View the rendered output without applying
kubectl kustomize <directory>
kubectl kustomize ./overlays/prod

# Delete resources from Kustomize directory
kubectl delete -k <directory>

# Diff between current cluster state and kustomize config
kubectl diff -k <directory>

# Build and view kustomization (same as kubectl kustomize)
kustomize build <directory>
```

### Directory Structure Pattern

```text
myapp/
├── base/                          # Base resources (shared)
│   ├── deployment.yaml           # Base deployment
│   ├── service.yaml              # Base service
│   └── kustomization.yaml        # Base kustomization
└── overlays/                      # Environment-specific overlays
    ├── dev/
    │   ├── kustomization.yaml    # Dev customizations
    │   └── patches/              # Optional patches
    │       └── replica-patch.yaml
    ├── staging/
    │   └── kustomization.yaml    # Staging customizations
    └── production/
        ├── kustomization.yaml    # Production customizations
        └── patches/
            └── resource-patch.yaml
```

### Basic kustomization.yaml Structure

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

# Reference to base or other kustomizations
resources:
  - deployment.yaml
  - service.yaml
  # Or reference another directory
  # - ../../base

# Common metadata applied to all resources
namespace: production
namePrefix: prod-
nameSuffix: -v2
commonLabels:
  env: production
  team: platform
commonAnnotations:
  managed-by: kustomize
  version: "1.0.0"

# Image transformations
images:
  - name: nginx
    newName: nginx
    newTag: "1.23"
  - name: myapp
    newName: myregistry.io/myapp
    newTag: "v2.0.0"

# Replica count overrides
replicas:
  - name: myapp-deployment
    count: 5

# ConfigMap generators
configMapGenerator:
  - name: app-config
    literals:
      - KEY=value
      - ANOTHER_KEY=another_value
    files:
      - config.properties
      - application.yml
    envs:
      - .env

# Secret generators
secretGenerator:
  - name: app-secret
    literals:
      - username=admin
      - password=secret123
    files:
      - ssh-privatekey=~/.ssh/id_rsa
    envs:
      - .env.secret

# Patches (Strategic Merge)
patchesStrategicMerge:
  - patch-resources.yaml
  - patch-replicas.yaml

# Patches (JSON 6902)
patches:
  - target:
      kind: Deployment
      name: myapp
    patch: |-
      - op: replace
        path: /spec/replicas
        value: 3
      - op: add
        path: /spec/template/spec/containers/0/env/-
        value:
          name: NEW_VAR
          value: "new_value"
```

## Common Kustomize Patterns

### 1. Base + Overlays (Most Common)

**Base:** Shared configuration

```yaml
# base/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - deployment.yaml
  - service.yaml
```

**Overlay:** Environment-specific customizations

```yaml
# overlays/production/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../../base
namePrefix: prod-
replicas:
  - name: myapp
    count: 10
images:
  - name: myapp
    newTag: "v2.1.0"
```

### 2. Image Replacement

```yaml
images:
  - name: nginx                    # Match this image name
    newName: nginx                 # Replace with this (optional)
    newTag: "1.23"                # Replace tag
  - name: myapp
    newName: registry.io/myapp    # Change registry and tag
    newTag: "production"
```

### 3. ConfigMap from Multiple Sources

```yaml
configMapGenerator:
  - name: app-config
    literals:
      - LOG_LEVEL=info           # Inline key-value
      - DEBUG=false
    files:
      - application.properties   # Entire file as one key
      - config.json
    envs:
      - .env                     # File with KEY=value pairs
```

### 4. Strategic Merge Patch

```yaml
# patch-resources.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp                    # Must match deployment name
spec:
  template:
    spec:
      containers:
      - name: myapp              # Must match container name
        resources:
          limits:
            memory: "512Mi"
            cpu: "500m"
          requests:
            memory: "256Mi"
            cpu: "250m"
```

### 5. JSON Patch (RFC 6902)

```yaml
patches:
  - target:
      kind: Deployment
      name: myapp
    patch: |-
      - op: add                           # Operations: add, remove, replace
        path: /spec/template/spec/containers/0/env/-
        value:
          name: ENV_VAR
          value: "production"
      - op: replace
        path: /spec/replicas
        value: 5
```

## Common Exam Scenarios

1. **Create base resources and apply with Kustomize**
   - Generate YAML with `kubectl create --dry-run=client -o yaml`
   - Create `kustomization.yaml` with `resources` field
   - Apply with `kubectl apply -k .`

2. **Create dev and prod overlays from same base**
   - Structure: `base/` and `overlays/dev/`, `overlays/prod/`
   - Use `resources: [../../base]` in overlays
   - Customize replicas, images, names per environment

3. **Add resource limits using patches**
   - Create strategic merge patch file with resource limits
   - Reference in `patchesStrategicMerge`
   - Or use JSON patch with `op: add` and `path: /spec/template/spec/containers/0/resources`

4. **Generate ConfigMap from file and use in deployment**
   - Use `configMapGenerator` with `files` or `literals`
   - Kustomize adds hash suffix automatically
   - Reference ConfigMap in deployment (without hash)

5. **Change image tag across multiple deployments**
   - Use `images` field in kustomization.yaml
   - Specify `name` and `newTag` for each image
   - No need to edit individual deployment files

6. **Add common labels to all resources**
   - Use `commonLabels` in kustomization.yaml
   - Applied to all resources automatically
   - Also updates selectors and label selectors

7. **Set namespace for all resources**
   - Use `namespace: <name>` in kustomization.yaml
   - All resources deployed to that namespace
   - Create namespace first if it doesn't exist

## Tips for CKAD Exam

✅ **DO:**

- Use `kubectl kustomize .` to preview before applying (catches errors early)
- Start with `kubectl create --dry-run=client -o yaml` to generate base manifests quickly
- Use `kubectl apply -k .` from the directory containing kustomization.yaml
- Use `commonLabels` instead of manually adding labels to each resource
- Use `images` field to change image tags - faster than editing YAML
- Use `namePrefix` and `nameSuffix` to avoid resource name conflicts
- Remember ConfigMaps and Secrets from generators get automatic hash suffixes
- Test with `--dry-run=client` first: `kubectl apply -k . --dry-run=client`
- Use `kubectl explain kustomization` if you forget the structure (though it may not always work)
- Keep directory structure simple: base/ and overlays/ pattern is standard

❌ **DON'T:**

- Don't edit base files when you can use overlays - keep base reusable
- Don't manually add hash suffixes to ConfigMap/Secret names - Kustomize does it
- Don't forget to create the namespace before deploying with `namespace:` field
- Don't use `kubectl apply -f` on individual files if you're using Kustomize - use `-k`
- Don't forget that `commonLabels` updates selectors too (can cause issues if resource already exists)
- Don't use complex JSON patches when strategic merge is simpler
- Don't reference files that don't exist in `kustomization.yaml` - will fail
- Don't forget the `apiVersion` and `kind` in kustomization.yaml (common copy-paste error)
- Don't mix `-f` and `-k` flags - they're mutually exclusive
- Don't forget that paths in overlays are relative to the overlay directory

## Kustomization.yaml Fields Quick Reference

| Field | Purpose | Example |
|-------|---------|---------|
| `resources` | List of resource files or directories | `- deployment.yaml`<br>`- ../../base` |
| `namespace` | Target namespace for all resources | `production` |
| `namePrefix` | Add prefix to all resource names | `dev-` |
| `nameSuffix` | Add suffix to all resource names | `-v2` |
| `commonLabels` | Add labels to all resources | `env: prod` |
| `commonAnnotations` | Add annotations to all resources | `managed-by: kustomize` |
| `images` | Replace image names/tags | `name: nginx`<br>`newTag: "1.23"` |
| `replicas` | Override replica counts | `name: myapp`<br>`count: 5` |
| `configMapGenerator` | Generate ConfigMaps | `literals`, `files`, `envs` |
| `secretGenerator` | Generate Secrets | `literals`, `files`, `envs` |
| `patchesStrategicMerge` | Strategic merge patches (YAML) | `- patch.yaml` |
| `patches` | JSON patches (RFC 6902) | `target` + `patch` |

## Strategic Merge vs JSON Patch

### When to use Strategic Merge Patch

- Adding or modifying nested structures (like resources, env vars)
- More readable and YAML-native
- When you want to merge complex objects
- **Example:** Adding resource limits, environment variables

```yaml
# patch-resources.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  template:
    spec:
      containers:
      - name: myapp
        resources:
          limits:
            memory: "512Mi"
```

### When to use JSON Patch

- Precise modifications (replace, remove specific fields)
- Working with arrays (inserting at specific positions)
- More explicit and controlled
- **Example:** Replacing exact replica count, removing a field

```yaml
patches:
  - target:
      kind: Deployment
      name: myapp
    patch: |-
      - op: replace
        path: /spec/replicas
        value: 3
```

## ConfigMap/Secret Generation

### Hash Suffixes (Immutable Config Pattern)

Kustomize automatically adds hash suffixes to generated ConfigMaps and Secrets:

```text
app-config         → app-config-g2m8f4tkm5
app-secret         → app-secret-bht9d6m4h7
```

**Benefits:**

- Changes to ConfigMap/Secret trigger pod restarts (hash changes)
- Immutable config pattern (each version has unique name)
- Automatic rollout when config changes

**Reference in Deployment:**

```yaml
# In deployment.yaml, reference without hash
envFrom:
  - configMapRef:
      name: app-config    # Kustomize updates this automatically
```

## Debugging Kustomize Issues

```bash
# Preview rendered YAML before applying
kubectl kustomize .

# Dry-run to see what would be created
kubectl apply -k . --dry-run=client -o yaml

# Validate kustomization structure
kubectl kustomize . > /dev/null && echo "Valid" || echo "Invalid"

# Check what resources will be affected
kubectl diff -k .

# View with full paths (when references aren't working)
cd overlays/dev && kubectl kustomize .

# Check specific resource after kustomization
kubectl kustomize . | grep -A20 "kind: Deployment"
```

## Common Errors and Solutions

| Error | Cause | Solution |
|-------|-------|----------|
| `unable to find one of 'kustomization.yaml'` | Not in right directory | Ensure kustomization.yaml exists in current directory |
| `no matches for Id` | Referenced file doesn't exist | Check paths in `resources` field are correct |
| `Error: accumulating resources` | Invalid YAML in resource files | Validate individual resource files first |
| `multiple matches for Id` | Duplicate resources | Check for duplicate resource names in resources list |
| `field replicas not found` | Wrong target in replicas field | Use deployment name, not pod name |
| `rawResources failed to read` | Relative path incorrect | Check paths relative to kustomization.yaml location |

## Time-Saving Tips

```bash
# Alias for faster Kustomize operations
alias kk='kubectl kustomize'
alias ka='kubectl apply -k'
alias kd='kubectl delete -k'

# Quick preview and apply
kubectl kustomize . && kubectl apply -k .

# Apply and watch
kubectl apply -k . && kubectl get pods -w

# Generate base quickly
kubectl create deployment app --image=nginx --dry-run=client -o yaml > deployment.yaml
kubectl create service clusterip app --tcp=80:80 --dry-run=client -o yaml > service.yaml

# Basic kustomization.yaml template
cat <<EOF > kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - deployment.yaml
  - service.yaml
EOF

# Quick overlay creation
mkdir -p overlays/dev
cat <<EOF > overlays/dev/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../../base
namePrefix: dev-
replicas:
  - name: app
    count: 2
EOF
```

## Integration with Other Tools

### Helm + Kustomize

```bash
# Render Helm chart, then apply Kustomize
helm template myapp ./chart | kubectl apply -f -
# Or use helm post-renderer
helm install myapp ./chart --post-renderer kustomize
```

### GitOps (ArgoCD/Flux)

- Kustomize is natively supported in ArgoCD and Flux
- Point to `overlays/production` directory
- Automatic sync when kustomization.yaml changes

## Exam Time Estimates

- **Basic kustomization.yaml:** 2-3 minutes
- **Base + single overlay:** 4-5 minutes
- **Multiple overlays:** 6-8 minutes
- **With patches:** 5-7 minutes
- **ConfigMap/Secret generation:** 3-4 minutes
- **Complex multi-feature setup:** 8-12 minutes

## Key Takeaways for CKAD

1. **Kustomize is built into kubectl** - no separate installation needed
2. **Use `-k` flag** instead of `-f` for Kustomize directories
3. **Base + Overlays pattern** is the most common and exam-relevant
4. **Preview first** with `kubectl kustomize .` before applying
5. **ConfigMap/Secret generators** add hash suffixes automatically
6. **Don't edit base** - use overlays to customize
7. **Speed tip:** Generate base with `kubectl create --dry-run`, then kustomize it
