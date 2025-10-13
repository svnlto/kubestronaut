# Pod Exercises for CKAD

Pods are the smallest deployable units in Kubernetes and the foundation for all workloads. Understanding pod creation,
multi-container patterns, and debugging is critical for the CKAD exam.

## Exercises

1. [Basic Pod Creation](01-basic-pod.md) (★☆☆) - 3-4 minutes
2. [Pod with Resource Limits](02-pod-with-resources.md) (★☆☆) - 4-5 minutes
3. [Pod with Init Container](03-init-container.md) (★★☆) - 6-7 minutes
4. [Sidecar Container Pattern](04-sidecar-logging.md) (★★☆) - 7-8 minutes
5. [Ambassador Container Pattern](05-ambassador-pattern.md) (★★☆) - 6-8 minutes
6. [Adapter Container Pattern](06-adapter-pattern.md) (★★★) - 8-10 minutes
7. [Pod Debugging and Troubleshooting](07-pod-troubleshooting.md) (★★★) - 8-12 minutes

## Quick Reference

**Essential Commands:**

```bash
# Create a pod imperatively
kubectl run nginx --image=nginx:alpine --labels=app=web,tier=frontend

# Generate pod YAML without creating it
kubectl run nginx --image=nginx --dry-run=client -o yaml > pod.yaml

# Get pods with labels
kubectl get pods --show-labels
kubectl get pods -l app=web

# View pod details
kubectl describe pod nginx
kubectl get pod nginx -o yaml
kubectl get pod nginx -o jsonpath='{.spec.containers[0].image}'

# Access pod logs
kubectl logs nginx
kubectl logs nginx -c container-name  # For multi-container pods
kubectl logs nginx --previous          # Previous container instance

# Execute commands in pod
kubectl exec nginx -- ls /
kubectl exec -it nginx -- sh

# Debug pods
kubectl describe pod nginx
kubectl get events --sort-by='.lastTimestamp'
kubectl logs nginx -c init-container-name  # Init container logs

# Delete pods
kubectl delete pod nginx
kubectl delete pod nginx --force --grace-period=0  # Force delete
```

**Common Pod YAML Patterns:**

```yaml
# Basic pod structure
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app: web
spec:
  containers:
  - name: nginx
    image: nginx:alpine
    resources:
      requests:
        memory: "64Mi"
        cpu: "100m"
      limits:
        memory: "128Mi"
        cpu: "200m"
    env:
    - name: ENV_VAR
      value: "value"
    ports:
    - containerPort: 80

# Multi-container pod with init container
apiVersion: v1
kind: Pod
metadata:
  name: multi-container
spec:
  initContainers:
  - name: init
    image: busybox
    command: ['sh', '-c', 'echo initializing']
  containers:
  - name: main
    image: nginx
  - name: sidecar
    image: busybox
    command: ['sh', '-c', 'tail -f /var/log/app.log']
  volumes:
  - name: shared-logs
    emptyDir: {}
```

## Multi-Container Pod Patterns

### 1. Sidecar Pattern

- **Purpose:** Extends main container functionality
- **Use cases:** Logging, monitoring, file synchronization
- **Key:** Shares volumes with main container

### 2. Ambassador Pattern

- **Purpose:** Proxy connections to external services
- **Use cases:** Database proxy, API gateway
- **Key:** Simplifies main container networking logic

### 3. Adapter Pattern

- **Purpose:** Transforms data from main container
- **Use cases:** Log formatting, metric transformation
- **Key:** Normalizes output for external consumption

### 4. Init Container Pattern

- **Purpose:** Setup tasks before main container starts
- **Use cases:** Configuration, dependency checks, database migrations
- **Key:** Runs to completion before main containers start

## Common Exam Scenarios

1. **Create a pod with specific labels and image**
   - Use `kubectl run` with `--labels` flag
   - Fastest: imperative command

2. **Add resource limits to a pod**
   - Generate YAML, edit resources section
   - Remember: requests vs limits

3. **Create multi-container pod with shared volume**
   - Define volume in `spec.volumes`
   - Mount in each container's `volumeMounts`

4. **Debug a failing pod**
   - Use `kubectl describe pod` for events
   - Check logs with `kubectl logs`
   - Look for: ImagePullBackOff, CrashLoopBackOff, CreateContainerConfigError

5. **Create pod with init container**
   - Init containers run before main containers
   - Defined in `spec.initContainers`

6. **Create pod with environment variables**
   - Direct value: `env[].value`
   - From ConfigMap: `env[].valueFrom.configMapKeyRef`
   - From Secret: `env[].valueFrom.secretKeyRef`

## Tips for CKAD Exam

✅ **DO:**

- Use `kubectl run` for simple pods - it's fastest
- Use `--dry-run=client -o yaml` to generate YAML when you need to customize
- Master `kubectl explain pod.spec` to quickly check field names
- Practice typing common YAML structures from memory
- Use `kubectl delete pod --force --grace-period=0` if you need quick cleanup during exam
- Remember container names in multi-container pods for logs/exec commands
- Check pod status with `kubectl get pod -w` (watch mode)

❌ **DON'T:**

- Don't manually write complete YAML from scratch - use imperative commands
- Don't forget to specify container name with `-c` for multi-container pod logs
- Don't confuse init containers (run once) with sidecar containers (run continuously)
- Don't forget that init containers run in order, but regular containers start in parallel
- Don't waste time on perfect YAML formatting - focus on correctness
- Don't forget namespaces - use `-n` flag or set context namespace
- Don't skip verification steps - always confirm your pod is running correctly

## Resource Specifications

**CPU:**

- `1` = 1 CPU core
- `100m` = 100 millicores = 0.1 CPU
- Minimum: `1m`

**Memory:**

- `128Mi` = 128 Mebibytes
- `1Gi` = 1 Gibibyte
- Also supports: `K`, `M`, `G` (powers of 1000)

## Quick Troubleshooting Guide

| Status | Common Causes | How to Debug |
|--------|---------------|--------------|
| Pending | Resource constraints, node selector | `kubectl describe pod` - check events |
| ImagePullBackOff | Wrong image name, private registry | `kubectl describe pod` - check image |
| CrashLoopBackOff | App error, wrong command | `kubectl logs` - check application logs |
| CreateContainerConfigError | Missing ConfigMap/Secret | `kubectl describe pod` - check mounts |
| Error | Container exited with error | `kubectl logs` + `kubectl logs --previous` |

## Time-Saving Shortcuts

```bash
# Set alias for kubectl
alias k=kubectl

# Set default namespace to avoid -n flag
kubectl config set-context --current --namespace=my-namespace

# Quick pod creation
k run nginx --image=nginx --restart=Never

# Quick YAML generation and edit
k run nginx --image=nginx --dry-run=client -o yaml | kubectl apply -f -

# Get pod with custom columns
k get pod -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,NODE:.spec.nodeName
```
