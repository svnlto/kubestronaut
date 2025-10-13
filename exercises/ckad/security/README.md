# Security Exercises for CKAD

Kubernetes security includes SecurityContext, ServiceAccounts, RBAC, and resource limits. Understanding these concepts
is essential for building secure applications and is heavily tested in CKAD.

## Exercises

1. [Pod Security Context](01-security-context-pod.md) (★★☆) - 5-6 minutes
2. [Container Security Context](02-container-security-context.md) (★★☆) - 6-7 minutes
3. [ServiceAccount](03-serviceaccount.md) (★★☆) - 6-7 minutes
4. [Resource Limits](04-resource-limits.md) (★★☆) - 5-6 minutes
5. [RBAC - Role and RoleBinding](05-rbac-basic.md) (★★★) - 8-10 minutes

## Quick Reference

**SecurityContext (Pod level):**

```yaml
spec:
  securityContext:
    runAsUser: 1000
    runAsGroup: 3000
    fsGroup: 2000
    runAsNonRoot: true
```

**SecurityContext (Container level):**

```yaml
containers:
- name: app
  securityContext:
    allowPrivilegeEscalation: false
    readOnlyRootFilesystem: true
    runAsNonRoot: true
    capabilities:
      drop: ["ALL"]
      add: ["NET_BIND_SERVICE"]
```

**ServiceAccount:**

```yaml
spec:
  serviceAccountName: my-sa
```

**Resource Limits:**

```yaml
containers:
- name: app
  resources:
    requests:
      memory: "64Mi"
      cpu: "100m"
    limits:
      memory: "128Mi"
      cpu: "200m"
```

**Role:**

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
```

**RoleBinding:**

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
subjects:
- kind: ServiceAccount
  name: pod-reader
  namespace: default
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

## Security Concepts

**SecurityContext:** Controls privilege and access for pods/containers
**ServiceAccount:** Identity for pods to access K8s API
**RBAC:** Role-Based Access Control (who can do what)
**ResourceQuota:** Limits per namespace
**LimitRange:** Default/min/max resources per resource type
**PodSecurityPolicy/Standards:** Cluster-wide pod security policies

## Common Exam Scenarios

1. **Set user/group for pod**
2. **Make filesystem read-only**
3. **Create and use ServiceAccount**
4. **Set resource requests/limits**
5. **Create Role and RoleBinding**
6. **Test RBAC permissions**

## Tips for CKAD Exam

✅ **DO:**

- Use SecurityContext for non-root users
- Drop all capabilities by default
- Set `readOnlyRootFilesystem: true` when possible
- Always set resource requests and limits
- Use ServiceAccounts for API access
- Test RBAC with `kubectl auth can-i`

❌ **DON'T:**

- Don't run as root (use runAsNonRoot)
- Don't allow privilege escalation
- Don't forget namespace in RBAC
- Don't confuse Role (namespace) with ClusterRole (cluster-wide)

**Commands:** `kubectl create sa`, `kubectl create role`, `kubectl create rolebinding`, `kubectl auth can-i`
