# Helm Exercises for CKAD

Helm is the package manager for Kubernetes that simplifies application deployment and management. The CKAD v1.33
curriculum requires basic understanding of using Helm to deploy existing packages. These exercises focus on practical
Helm operations you'll encounter in the exam: installing charts, customizing deployments with values, and managing
release lifecycles.

## Exercises

1. [Install Helm Chart from Repository](01-install-chart.md) (★☆☆) - 5-7 minutes
2. [Customize Helm Installation with Values](02-custom-values.md) (★★☆) - 6-8 minutes
3. [Upgrade and Rollback Helm Release](03-upgrade-rollback.md) (★★☆) - 7-9 minutes
4. [Inspect and List Helm Releases](04-inspect-releases.md) (★☆☆) - 5-6 minutes
5. [Use Values File for Complex Configuration](05-values-file.md) (★★★) - 8-10 minutes

## Quick Reference

**Essential Commands:**

```bash
# Repository management
helm repo add <name> <url>                    # Add a chart repository
helm repo list                                 # List added repositories
helm repo update                               # Update local cache of charts
helm search repo <keyword>                     # Search for charts in repos

# Installing charts
helm install <release-name> <chart>            # Install a chart
helm install <name> <chart> --set key=value    # Install with custom values
helm install <name> <chart> -f values.yaml     # Install with values file
helm install <name> <chart> -n <namespace>     # Install in specific namespace
helm install <name> <chart> --dry-run          # Test installation without deploying

# Listing and inspecting
helm list                                      # List releases in current namespace
helm list -A                                   # List releases in all namespaces
helm status <release-name>                     # Show status of a release
helm get manifest <release-name>               # Get deployed manifest
helm get values <release-name>                 # Get values used in release
helm get notes <release-name>                  # Get release notes
helm history <release-name>                    # Show revision history

# Upgrading and rolling back
helm upgrade <release-name> <chart>            # Upgrade a release
helm upgrade <name> <chart> --set key=value    # Upgrade with new values
helm upgrade <name> <chart> -f values.yaml     # Upgrade with values file
helm rollback <release-name> <revision>        # Rollback to specific revision
helm rollback <release-name>                   # Rollback to previous revision

# Chart information
helm show chart <chart>                        # Show chart metadata
helm show values <chart>                       # Show default values
helm show readme <chart>                       # Show chart README
helm show all <chart>                          # Show all chart information

# Uninstalling
helm uninstall <release-name>                  # Remove a release
helm uninstall <name> --keep-history           # Uninstall but keep history
```

**Common Helm Repositories:**

```bash
# Bitnami (most popular for CKAD practice)
helm repo add bitnami https://charts.bitnami.com/bitnami

# Prometheus community
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Ingress NGINX
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# After adding repos, update cache
helm repo update
```

**Values Override Precedence (highest to lowest):**

1. `--set` flags (highest priority)
2. `-f` / `--values` files (in order specified, last wins)
3. Chart's default `values.yaml` (lowest priority)

**Values File Example:**

```yaml
# custom-values.yaml
replicaCount: 3

image:
  repository: nginx
  tag: "1.21"
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi

nodeSelector:
  disktype: ssd

tolerations:
  - key: "node-role"
    operator: "Equal"
    value: "frontend"
    effect: "NoSchedule"
```

## Common Exam Scenarios

1. **Install a chart from a repository**
   - Add repository with `helm repo add`
   - Update repo cache with `helm repo update`
   - Install with `helm install <name> <repo>/<chart>`

2. **Customize installation with specific values**
   - Use `--set key=value` for single values
   - Use `-f values.yaml` for multiple values
   - Check available values: `helm show values <chart>`

3. **Upgrade a release with new configuration**
   - Use `helm upgrade <name> <chart> --set key=newvalue`
   - Or update values file and use `helm upgrade <name> <chart> -f values.yaml`
   - Verify with `helm get values <name>`

4. **Rollback a failed upgrade**
   - Check history: `helm history <name>`
   - Rollback: `helm rollback <name> <revision>` or just `helm rollback <name>`
   - Verify with `helm status <name>`

5. **List and inspect existing releases**
   - List all: `helm list` or `helm list -A`
   - Get details: `helm status <name>`
   - View manifest: `helm get manifest <name>`

6. **Uninstall a release**
   - Use `helm uninstall <name>`
   - Verify with `kubectl get all -l app.kubernetes.io/instance=<name>`

## Tips for CKAD Exam

✅ **DO:**

- Use `helm repo add` before installing from external repos
- Run `helm repo update` after adding repos to refresh cache
- Use `--set` for quick single-value changes (faster than files)
- Use `-f values.yaml` for complex multi-value configurations
- Check default values before installing: `helm show values <chart>`
- Use `helm list` to verify release was created successfully
- Use `helm history` before rolling back to see available revisions
- Use `helm get values <name>` to verify custom values were applied
- Use `helm status <name>` to check deployment status and get notes
- Remember helm release names must be unique per namespace
- Use `--dry-run` to test installations without deploying
- Know that Helm creates labels like `app.kubernetes.io/instance=<release-name>`

❌ **DON'T:**

- Don't forget to add the repository before installing charts
- Don't skip `helm repo update` - you might get outdated chart versions
- Don't confuse chart name with release name (release = installed instance of chart)
- Don't manually edit resources created by Helm - use `helm upgrade` instead
- Don't delete Helm resources with kubectl - use `helm uninstall`
- Don't forget namespaces - Helm releases are namespace-scoped
- Don't expect `--set` changes to persist without `helm upgrade`
- Don't forget that rollback creates a new revision (doesn't delete history)
- Don't assume chart values match common Kubernetes field names - check first
- Don't use `helm install` when you mean `helm upgrade` (install fails if exists)

## Helm Architecture Basics

**Key Concepts:**

- **Chart:** A package containing Kubernetes resource definitions
- **Repository:** A collection of charts (like a package repository)
- **Release:** An instance of a chart running in a Kubernetes cluster
- **Revision:** A version in the release history (created on install/upgrade/rollback)
- **Values:** Configuration parameters that customize a chart installation

**Release Lifecycle:**

```text
helm install    →  Revision 1 (deployed)
helm upgrade    →  Revision 2 (deployed)
helm upgrade    →  Revision 3 (deployed)
helm rollback 2 →  Revision 4 (deployed) ← note: creates new revision
```

## Common Chart Value Patterns

Most Bitnami and standard charts follow these patterns:

```yaml
# Replica configuration
replicaCount: 3

# Image configuration
image:
  registry: docker.io
  repository: bitnami/nginx
  tag: latest
  pullPolicy: IfNotPresent

# Service configuration
service:
  type: ClusterIP
  port: 80
  targetPort: http

# Resource limits
resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi

# Persistence
persistence:
  enabled: true
  storageClass: "standard"
  size: 8Gi

# Pod security
securityContext:
  runAsUser: 1001
  runAsNonRoot: true
```

## Troubleshooting Helm Releases

| Issue | Possible Causes | How to Debug |
|-------|-----------------|--------------|
| Release not installing | Invalid values, missing repo, wrong chart name | `helm install --dry-run --debug` |
| Pods not starting | Wrong image, insufficient resources, wrong values | `kubectl describe pod`, `helm get manifest` |
| Values not applied | Wrong value path, typo in YAML, wrong file used | `helm get values`, `helm show values <chart>` |
| Upgrade fails | Breaking changes, incompatible values | `helm history`, `helm rollback` |
| Can't find chart | Repository not added/updated, wrong chart name | `helm repo list`, `helm search repo` |

## Quick Debugging Workflow

```bash
# 1. Check if release exists
helm list

# 2. Check release status and notes
helm status <release-name>

# 3. View values used
helm get values <release-name>

# 4. Check deployed manifest
helm get manifest <release-name>

# 5. Check associated pods
kubectl get pods -l app.kubernetes.io/instance=<release-name>

# 6. Check revision history
helm history <release-name>

# 7. If issues, check pod details
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

## Values Override Examples

**Using --set:**

```bash
# Single value
helm install web bitnami/nginx --set replicaCount=3

# Multiple values
helm install web bitnami/nginx --set replicaCount=3,service.type=NodePort

# Nested values (use dot notation)
helm install web bitnami/nginx --set image.tag=1.21,service.port=8080

# Array values (use {})
helm install web bitnami/nginx --set nodeSelector.disktype=ssd
```

**Using values file:**

```bash
# Single file
helm install web bitnami/nginx -f custom-values.yaml

# Multiple files (last wins for conflicts)
helm install web bitnami/nginx -f base-values.yaml -f override-values.yaml

# Combine file and --set (--set has highest priority)
helm install web bitnami/nginx -f values.yaml --set replicaCount=5
```

## Time-Saving Tips

```bash
# Set aliases
alias h=helm
alias hls='helm list'
alias hst='helm status'

# Quick install with custom values
helm install myapp bitnami/nginx --set replicaCount=3,service.type=NodePort

# Quick upgrade
helm upgrade myapp bitnami/nginx --set replicaCount=5

# Quick rollback to previous
helm rollback myapp

# View values before installing
helm show values bitnami/nginx | less

# Test install without deploying
helm install myapp bitnami/nginx --dry-run --debug

# Get all info about a chart
helm show all bitnami/nginx | less

# Search for charts
helm search repo nginx

# Uninstall and verify
helm uninstall myapp && kubectl get all -l app.kubernetes.io/instance=myapp
```

## Namespace Considerations

Helm releases are namespace-scoped:

```bash
# Install in specific namespace
helm install myapp bitnami/nginx -n production

# List releases in specific namespace
helm list -n production

# List releases in all namespaces
helm list -A

# Upgrade in specific namespace
helm upgrade myapp bitnami/nginx -n production

# Uninstall from specific namespace
helm uninstall myapp -n production
```

**Important:** If you don't specify `-n`, Helm uses your current kubectl context namespace.

## Exam Strategy

**Speed Optimization:**

1. **Repository setup (do once):**

   ```bash
   helm repo add bitnami https://charts.bitnami.com/bitnami
   helm repo update
   ```

2. **For simple installs:**

   ```bash
   helm install <name> bitnami/<chart> --set key=value
   ```

3. **For complex installs:**
   - Create values file first
   - Test with `--dry-run`
   - Then install with `-f`

4. **For troubleshooting:**
   - `helm status <name>` - first check
   - `helm get values <name>` - verify config
   - `kubectl get pods -l app.kubernetes.io/instance=<name>` - check pods
   - `helm history <name>` - check revisions

**Time Allocation:**

- Simple install: 2-3 minutes
- Install with values: 4-5 minutes
- Upgrade/rollback: 3-4 minutes
- Troubleshooting: 5-7 minutes

**Common Mistakes to Avoid:**

1. Forgetting to add/update repository
2. Using `helm install` on existing release (use `upgrade`)
3. Not checking values structure before using `--set`
4. Manually editing Helm-managed resources with kubectl
5. Not verifying installation with `helm list` and `kubectl get pods`
