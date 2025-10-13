# Deployment Exercises for CKAD

Deployments provide declarative updates for Pods and ReplicaSets. They are the primary way to deploy and manage
stateless applications in Kubernetes. Understanding deployments, scaling, rolling updates,
and rollbacks is essential for CKAD.

## Exercises

1. [Basic Deployment Creation](01-basic-deployment.md) (★☆☆) - 3-4 minutes
2. [Scaling Deployments](02-scaling.md) (★☆☆) - 3-5 minutes
3. [Rolling Update](03-rolling-update.md) (★★☆) - 5-7 minutes
4. [Rollback Deployment](04-rollback.md) (★★☆) - 6-8 minutes
5. [Deployment Strategy Configuration](05-update-strategy.md) (★★☆) - 6-8 minutes
6. [Pause and Resume Rollout](06-pause-resume.md) (★★★) - 7-9 minutes
7. [Deployment with Health Checks](07-deployment-with-probes.md) (★★★) - 8-10 minutes

## Quick Reference

**Essential Commands:**

```bash
# Create deployment imperatively
kubectl create deployment web --image=nginx:alpine --replicas=3

# Generate deployment YAML
kubectl create deployment web --image=nginx --dry-run=client -o yaml > deploy.yaml

# Get deployments
kubectl get deployments
kubectl get deploy web -o wide
kubectl get deploy web -o yaml

# Scale deployment
kubectl scale deployment web --replicas=5

# Update deployment image
kubectl set image deployment/web nginx=nginx:1.21
kubectl set image deployment/web *=nginx:1.21  # Update all containers

# Rollout management
kubectl rollout status deployment/web
kubectl rollout history deployment/web
kubectl rollout undo deployment/web
kubectl rollout undo deployment/web --to-revision=2
kubectl rollout restart deployment/web

# Pause and resume
kubectl rollout pause deployment/web
kubectl rollout resume deployment/web

# Edit deployment
kubectl edit deployment web
kubectl patch deployment web -p '{"spec":{"replicas":5}}'

# Delete deployment
kubectl delete deployment web

# Autoscaling
kubectl autoscale deployment web --min=2 --max=10 --cpu-percent=80
```

**Common Deployment YAML Pattern:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  labels:
    app: web
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: nginx
        image: nginx:1.21
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: "128Mi"
            cpu: "200m"
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 15
          periodSeconds: 20
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 10
```

## Deployment Strategies

### RollingUpdate (Default)

- **How it works:** Gradually replaces old pods with new ones
- **Parameters:**
  - `maxSurge`: Max number of pods above desired count during update (default: 25%)
  - `maxUnavailable`: Max number of pods unavailable during update (default: 25%)
- **Use case:** Most common, zero-downtime updates
- **Example:** maxSurge=1, maxUnavailable=0 means one extra pod created before old one terminates

### Recreate

- **How it works:** Terminates all old pods before creating new ones
- **Parameters:** None
- **Use case:** When you can't run old and new versions simultaneously
- **Downtime:** Yes (all pods down during transition)

## Update Strategies

### Fast Update (More Resources)

```yaml
strategy:
  rollingUpdate:
    maxSurge: 100%
    maxUnavailable: 0
```

- Creates all new pods first, then terminates old ones
- Requires 2x resources temporarily
- Zero downtime

### Slow Update (Fewer Resources)

```yaml
strategy:
  rollingUpdate:
    maxSurge: 0
    maxUnavailable: 1
```

- Terminates one pod, creates replacement, repeat
- Minimal extra resources
- May have reduced capacity during update

### Balanced Update (Default-ish)

```yaml
strategy:
  rollingUpdate:
    maxSurge: 1
    maxUnavailable: 1
```

- Creates one new, can have one unavailable
- Balanced between speed and resource usage

## Common Exam Scenarios

1. **Create deployment with specific replicas**
   - Use `kubectl create deployment --image=<image> --replicas=<n>`
   - Fastest way: imperative command

2. **Scale deployment up or down**
   - Use `kubectl scale deployment/<name> --replicas=<n>`
   - Or: `kubectl patch deployment/<name> -p '{"spec":{"replicas":<n>}}'`

3. **Update deployment image (rolling update)**
   - Use `kubectl set image deployment/<name> <container>=<new-image>`
   - Monitor with `kubectl rollout status deployment/<name>`

4. **Rollback deployment to previous version**
   - Use `kubectl rollout undo deployment/<name>`
   - Check history first: `kubectl rollout history deployment/<name>`

5. **Configure rolling update strategy**
   - Edit YAML: add `spec.strategy.rollingUpdate`
   - Set `maxSurge` and `maxUnavailable`

6. **Pause deployment for multiple changes**
   - Use `kubectl rollout pause deployment/<name>`
   - Make changes, then `kubectl rollout resume deployment/<name>`

7. **Add health checks to deployment**
   - Edit deployment YAML
   - Add `livenessProbe` and `readinessProbe` under container spec

## Tips for CKAD Exam

✅ **DO:**

- Use `kubectl create deployment` for quick creation - it's fastest
- Use `kubectl scale` for quick scaling changes
- Use `kubectl set image` for quick image updates
- Monitor rollouts with `kubectl rollout status -w` (watch mode)
- Check `kubectl rollout history` before doing rollbacks
- Use `kubectl rollout pause` when making multiple changes
- Remember: selector labels must match template labels
- Use `kubectl explain deployment.spec.strategy` if you forget the structure
- Test your deployment: `kubectl get pods -l <label>` to see if pods are running

❌ **DON'T:**

- Don't manually edit replica count in YAML if you can use `kubectl scale`
- Don't forget to record changes if you need detailed history
  (--record is deprecated, but kubernetes.io/change-cause annotation works)
- Don't confuse Deployment with ReplicaSet - Deployment manages ReplicaSets
- Don't manually delete ReplicaSets - the Deployment controller manages them
- Don't forget the selector must match the pod template labels
- Don't use `kubectl rollout restart` when you need to actually update the image
- Don't forget that `maxSurge` and `maxUnavailable` can be numbers or percentages
- Don't skip verification - always check pods are running after changes

## Rollout Commands Explained

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `rollout status` | Check update progress | After any update to see if it succeeded |
| `rollout history` | View revision history | Before rollback to see available revisions |
| `rollout undo` | Rollback to previous revision | When current version has issues |
| `rollout undo --to-revision=N` | Rollback to specific revision | When you need a specific old version |
| `rollout pause` | Pause rollout | Before making multiple changes |
| `rollout resume` | Resume paused rollout | After making changes to paused deployment |
| `rollout restart` | Restart pods without changing spec | Force pod recreation (e.g., to pick up new secrets) |

## Selector and Labels

**Critical Rule:** Deployment selector must match Pod template labels

```yaml
spec:
  selector:
    matchLabels:
      app: web        # Must match template labels
  template:
    metadata:
      labels:
        app: web      # Must match selector
        version: v1   # Additional labels OK
```

**Common Mistake:**

```yaml
# WRONG - selector doesn't match template
selector:
  matchLabels:
    app: web
template:
  metadata:
    labels:
      app: api      # Doesn't match selector!
```

## Troubleshooting Deployments

| Issue | Possible Causes | How to Debug |
|-------|-----------------|--------------|
| Pods not created | Selector mismatch, invalid image | `kubectl describe deployment` |
| Rollout stuck | Image pull error, failing probes | `kubectl rollout status`, `kubectl describe pod` |
| Old pods not terminating | High termination grace period | `kubectl get pods -w`, check `terminationGracePeriodSeconds` |
| Rollback not working | No previous revision | `kubectl rollout history` |
| Wrong number of pods | Scaling in progress, multiple ReplicaSets | `kubectl get rs`, `kubectl rollout status` |

## Quick Debugging Workflow

```bash
# 1. Check deployment status
kubectl get deployment <name>

# 2. Check rollout status
kubectl rollout status deployment/<name>

# 3. Check pods
kubectl get pods -l app=<label>

# 4. If issues, check events
kubectl describe deployment <name>
kubectl describe pod <pod-name>

# 5. Check ReplicaSets
kubectl get rs -l app=<label>

# 6. Check rollout history
kubectl rollout history deployment/<name>
```

## Resource Requirements

When a deployment specifies resources:

- **Requests:** Minimum guaranteed resources (used for scheduling)
- **Limits:** Maximum resources the container can use

```yaml
resources:
  requests:
    memory: "64Mi"
    cpu: "100m"      # 0.1 CPU
  limits:
    memory: "128Mi"
    cpu: "200m"      # 0.2 CPU
```

## Time-Saving Tips

```bash
# Set alias
alias k=kubectl
alias kgd='kubectl get deployments'
alias kgp='kubectl get pods'

# Quick deployment creation
k create deploy nginx --image=nginx --replicas=3

# Quick image update
k set image deploy/nginx nginx=nginx:1.21

# Quick scale
k scale deploy/nginx --replicas=5

# Watch rollout
k rollout status deploy/nginx -w

# Quick rollback
k rollout undo deploy/nginx

# Get deployment with custom output
k get deploy nginx -o custom-columns=NAME:.metadata.name,REPLICAS:.spec.replicas,IMAGE:.spec.template.spec.containers[0].image
```
