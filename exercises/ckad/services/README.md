# Service Exercises for CKAD

Services provide stable networking for pods, enabling pod-to-pod communication and external access.
Understanding service types, selectors, and endpoints is crucial for the CKAD exam.

## Exercises

1. [ClusterIP Service](01-clusterip-service.md) (★☆☆) - 3-4 minutes
2. [NodePort Service](02-nodeport-service.md) (★☆☆) - 4-5 minutes
3. [Service with Label Selectors](03-service-with-labels.md) (★★☆) - 5-7 minutes
4. [Headless Service](04-headless-service.md) (★★☆) - 5-7 minutes
5. [Multi-Port Service](05-multi-port-service.md) (★★☆) - 6-8 minutes
6. [Service Troubleshooting](06-service-troubleshooting.md) (★★★) - 8-10 minutes

## Quick Reference

**Essential Commands:**

```bash
# Create ClusterIP service (expose deployment)
kubectl expose deployment web --port=80 --target-port=80 --name=web-service

# Create NodePort service
kubectl expose deployment web --type=NodePort --port=80 --name=web-nodeport

# Create LoadBalancer service
kubectl expose deployment web --type=LoadBalancer --port=80 --name=web-lb

# Create service from YAML
kubectl create service clusterip web --tcp=80:80 --dry-run=client -o yaml > service.yaml

# Create headless service
kubectl create service clusterip web --clusterip=None --tcp=80:80

# Get services
kubectl get svc
kubectl get svc web-service -o wide
kubectl get svc web-service -o yaml

# Get endpoints
kubectl get endpoints
kubectl get endpoints web-service
kubectl describe endpoints web-service

# Test service connectivity
kubectl run test --image=busybox --rm -it --restart=Never -- wget -O- web-service:80
kubectl run test --image=busybox --rm -it --restart=Never -- nslookup web-service

# Delete service
kubectl delete svc web-service
```

**Common Service YAML Pattern:**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
  labels:
    app: web
spec:
  type: ClusterIP  # ClusterIP, NodePort, LoadBalancer, ExternalName
  selector:
    app: web       # Must match pod labels
  ports:
  - name: http
    protocol: TCP
    port: 80           # Service port
    targetPort: 80     # Container port
  # For NodePort:
  # - port: 80
  #   targetPort: 80
  #   nodePort: 30080  # Optional: 30000-32767
```

**Multi-Port Service:**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: multi-service
spec:
  selector:
    app: web
  ports:
  - name: http      # Names required for multi-port
    port: 80
    targetPort: 80
  - name: https
    port: 443
    targetPort: 443
```

**Headless Service:**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: headless-service
spec:
  clusterIP: None   # Makes it headless
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
```

## Service Types

### 1. ClusterIP (Default)

- **Scope:** Internal cluster only
- **IP:** Cluster-internal IP assigned
- **Use case:** Internal microservice communication
- **Access:** Only from within cluster
- **DNS:** `<service-name>.<namespace>.svc.cluster.local`

### 2. NodePort

- **Scope:** External access via node IP
- **IP:** ClusterIP + port on each node (30000-32767)
- **Use case:** Development, testing, specific port requirements
- **Access:** `<NodeIP>:<NodePort>`
- **Note:** Less common in production (use LoadBalancer or Ingress)

### 3. LoadBalancer

- **Scope:** External access via cloud load balancer
- **IP:** External IP from cloud provider
- **Use case:** Production external access
- **Access:** External IP assigned by cloud provider
- **Note:** Requires cloud provider integration

### 4. ExternalName

- **Scope:** Maps service to external DNS name
- **IP:** No ClusterIP assigned
- **Use case:** Access external services via service name
- **Example:** Map to `database.example.com`

### 5. Headless Service (clusterIP: None)

- **Scope:** Direct pod access
- **IP:** No ClusterIP assigned
- **Use case:** StatefulSets, direct pod discovery
- **DNS:** Returns all pod IPs instead of single service IP

## Service Discovery

### DNS-Based Discovery

```bash
# Full DNS name
<service-name>.<namespace>.svc.cluster.local

# Short names (within same namespace)
<service-name>

# Example
web-service.default.svc.cluster.local
web-service  # If in same namespace
```

### Environment Variables

When a service is created before a pod, the pod gets environment variables:

```bash
<SERVICE_NAME>_SERVICE_HOST=10.96.0.1
<SERVICE_NAME>_SERVICE_PORT=80
```

## Selectors and Endpoints

**How it works:**

1. Service selector matches pod labels
2. Kubernetes creates Endpoints with matching pod IPs
3. Service routes traffic to endpoint IPs

**Example:**

```yaml
# Service selector
spec:
  selector:
    app: web
    tier: frontend

# Matching pod labels
metadata:
  labels:
    app: web
    tier: frontend
    version: v1  # Extra labels OK
```

**Important:** Service selects pods with ALL specified labels (AND logic, not OR).

## Common Exam Scenarios

1. **Expose deployment as ClusterIP service**
   - Fastest: `kubectl expose deployment <name> --port=<port>`
   - Default type is ClusterIP

2. **Create NodePort service**
   - Use `kubectl expose --type=NodePort`
   - Or edit YAML to add `type: NodePort`

3. **Create service for existing pods**
   - Match service selector to pod labels
   - Use `kubectl create service` or `kubectl expose`

4. **Debug service with no endpoints**
   - Check `kubectl get endpoints <service>`
   - Verify selector matches pod labels
   - Ensure pods are running and ready

5. **Create headless service**
   - Set `clusterIP: None` in YAML
   - Used with StatefulSets for direct pod access

6. **Create multi-port service**
   - Each port must have a unique name
   - Specify multiple ports in `spec.ports[]`

7. **Test service connectivity**
   - Use `kubectl run test --image=busybox --rm -it -- wget <service>:<port>`
   - Or use `kubectl exec` from existing pod

## Tips for CKAD Exam

✅ **DO:**

- Use `kubectl expose` for fastest service creation
- Always verify endpoints: `kubectl get endpoints <service>`
- Test connectivity with temporary busybox pod
- Remember: service selector must match pod labels exactly (all specified labels)
- Use `kubectl explain service.spec` if you forget structure
- Check DNS: `nslookup <service-name>` from inside a pod
- For multi-port services, name all ports
- Use short service names within the same namespace

❌ **DON'T:**

- Don't confuse `port` (service port) with `targetPort` (container port)
- Don't forget that selector matches ALL specified labels (AND logic)
- Don't manually create Endpoints - they're auto-generated from selector
- Don't use NodePort in production without good reason (use LoadBalancer or Ingress)
- Don't forget to check if pods are Ready (probes must pass)
- Don't assume service works without testing connectivity
- Don't forget namespace - services are namespace-scoped
- Don't manually assign ClusterIP (let Kubernetes do it)

## Port Terminology

| Term | Meaning | Where Used |
|------|---------|------------|
| `port` | Port exposed by service | Service spec |
| `targetPort` | Port on the container | Service spec |
| `containerPort` | Port container listens on | Pod spec |
| `nodePort` | Port on each node (30000-32767) | NodePort service |

**Example Flow:**

```text
External → NodePort (30080) → Service Port (80) → TargetPort (8080) → Container Port (8080)
```

## Troubleshooting Services

| Issue | Possible Causes | How to Debug |
|-------|-----------------|--------------|
| No endpoints | Selector mismatch, no ready pods | `kubectl get endpoints`, check labels |
| Can't connect | Wrong port, pod not ready, network policy | Test with busybox, check pod logs |
| Wrong pods selected | Selector too broad/narrow | `kubectl get pods -l <selector>` |
| Service not found | Wrong namespace, typo | `kubectl get svc -A`, check namespace |
| NodePort not accessible | Firewall, wrong node IP | Check cloud security groups |

## Quick Debugging Workflow

```bash
# 1. Check service exists
kubectl get svc <service-name>

# 2. Check service details
kubectl describe svc <service-name>

# 3. Check endpoints
kubectl get endpoints <service-name>

# 4. If no endpoints, check pod labels
kubectl get pods --show-labels

# 5. Verify selector matches
kubectl get svc <service-name> -o jsonpath='{.spec.selector}'

# 6. Test connectivity
kubectl run test --image=busybox --rm -it --restart=Never -- wget -O- <service>:80

# 7. Check DNS
kubectl run test --image=busybox --rm -it --restart=Never -- nslookup <service>

# 8. Check pod logs if still failing
kubectl logs <pod-name>
```

## Service Session Affinity

```yaml
spec:
  sessionAffinity: ClientIP  # Default: None
  sessionAffinityConfig:
    clientIP:
      timeoutSeconds: 10800  # 3 hours default
```

- **None:** Load balances each request
- **ClientIP:** Routes requests from same client IP to same pod

## ExternalName Service Example

```yaml
apiVersion: v1
kind: Service
metadata:
  name: external-db
spec:
  type: ExternalName
  externalName: database.example.com
```

- No selector, no endpoints
- DNS CNAME record to external name
- Useful for accessing external services via service name

## Time-Saving Tips

```bash
# Quick service creation
k expose deploy web --port=80 --name=web-svc

# Quick test
k run test --image=busybox --rm -it --restart=Never -- wget -O- web-svc:80

# Get service IP
k get svc web-svc -o jsonpath='{.spec.clusterIP}'

# Get service endpoints
k get ep web-svc -o jsonpath='{.subsets[*].addresses[*].ip}'

# Create and test in one go
k expose deploy web --port=80 && k run test --image=busybox --rm -it --restart=Never -- wget -O- web:80
```
