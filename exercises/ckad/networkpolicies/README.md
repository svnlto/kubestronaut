# NetworkPolicy Exercises for CKAD

NetworkPolicies control traffic between pods. They act as firewalls, allowing you to restrict ingress and egress
traffic. Understanding NetworkPolicy selectors is critical for CKAD.

## Exercises

1. [Deny All Network Policy](01-deny-all.md) (★★☆) - 5-6 minutes
2. [Allow from Specific Pod](02-allow-from-pod.md) (★★☆) - 6-7 minutes
3. [Allow from Specific Namespace](03-allow-from-namespace.md) (★★★) - 7-8 minutes
4. [Egress Network Policy](04-egress-policy.md) (★★★) - 7-9 minutes

## Quick Reference

**Deny all ingress:**

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector: {}  # Applies to all pods
  policyTypes:
  - Ingress
```

**Allow from specific pods:**

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 80
```

**Allow from namespace:**

```yaml
spec:
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: prod
```

**Egress with DNS:**

```yaml
spec:
  policyTypes:
  - Egress
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: database
    ports:
    - protocol: TCP
      port: 5432
  - to:  # Allow DNS
    - namespaceSelector:
        matchLabels:
          name: kube-system
    ports:
    - protocol: UDP
      port: 53
```

## Key Concepts

**Default behavior:** Allow all (no NetworkPolicies)
**With NetworkPolicy:** Deny all except explicitly allowed
**Selectors:** podSelector, namespaceSelector, ipBlock
**Policy Types:** Ingress, Egress, or both

## Common Exam Scenarios

1. **Create deny-all policy**
2. **Allow specific pod-to-pod communication**
3. **Allow from specific namespace**
4. **Configure egress restrictions**
5. **Allow DNS for name resolution**

## Tips for CKAD Exam

✅ **DO:**

- Remember: NetworkPolicy requires CNI plugin support
- Empty `podSelector: {}` applies to all pods
- Always allow DNS for egress policies
- Use labels to select pods/namespaces
- Test with temporary pods

❌ **DON'T:**

- Don't forget `policyTypes` field
- Don't forget to label namespaces for `namespaceSelector`
- Don't block DNS (UDP port 53 to kube-system)

**Useful commands:** `kubectl get networkpolicy`, `kubectl describe networkpolicy`, `kubectl exec -- wget`
