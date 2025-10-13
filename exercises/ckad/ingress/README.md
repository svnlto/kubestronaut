# Ingress Exercises for CKAD

Ingress manages external access to services in a cluster, typically HTTP/HTTPS. It provides load balancing,
SSL termination, and name-based virtual hosting. Understanding Ingress configuration is important for CKAD.

## Exercises

1. [Basic Ingress](01-basic-ingress.md) (★★☆) - 6-7 minutes
2. [Path-Based Routing](02-path-based-routing.md) (★★☆) - 7-8 minutes
3. [Host-Based Routing](03-host-based-routing.md) (★★★) - 8-9 minutes

## Quick Reference

**Basic Ingress:**

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
spec:
  rules:
  - host: example.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
```

**Path-Based Routing:**

```yaml
spec:
  rules:
  - host: apps.local
    http:
      paths:
      - path: /app1
        pathType: Prefix
        backend:
          service:
            name: app1-service
            port:
              number: 80
      - path: /app2
        pathType: Prefix
        backend:
          service:
            name: app2-service
            port:
              number: 80
```

**Host-Based Routing:**

```yaml
spec:
  rules:
  - host: a.example.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: site-a-service
            port:
              number: 80
  - host: b.example.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: site-b-service
            port:
              number: 80
```

**With TLS:**

```yaml
spec:
  tls:
  - hosts:
    - example.local
    secretName: tls-secret  # Secret with tls.crt and tls.key
  rules:
  - host: example.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
```

## Key Concepts

**Ingress Controller:** Required to implement Ingress (nginx, traefik, etc.)
**PathType:**

- `Prefix`: Matches path prefix (e.g., `/app` matches `/app`, `/app/test`)
- `Exact`: Exact path match
- `ImplementationSpecific`: Depends on Ingress Controller

**Common annotations:**

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
```

## Common Exam Scenarios

1. **Create basic ingress**
   - Single host, single path
   - Route to service

2. **Path-based routing**
   - Multiple paths to different services
   - Same host

3. **Host-based routing**
   - Multiple hosts
   - Each to different service

4. **Add TLS to ingress**
   - Reference TLS secret
   - Configure hosts

## Tips for CKAD Exam

✅ **DO:**

- Remember Ingress needs Ingress Controller
- Use `kubectl create ingress` for quick creation
- Verify service exists before creating Ingress
- Check `pathType` (Prefix vs Exact)
- Use `kubectl describe ingress` to verify backends
- Remember host and path are optional (default routing)

❌ **DON'T:**

- Don't forget service must exist first
- Don't forget port number in backend
- Don't confuse Ingress (resource) with Ingress Controller (implementation)
- Don't forget namespace (Ingress and Service must match)
- Don't forget pathType is required in v1

**Commands:** `kubectl create ingress`, `kubectl get ingress`, `kubectl describe ingress`

**Quick creation:**

```bash
# Basic ingress
kubectl create ingress web --rule="example.local/=web-service:80"

# Path-based
kubectl create ingress paths \
  --rule="apps.local/app1=app1-service:80" \
  --rule="apps.local/app2=app2-service:80"

# Multiple hosts
kubectl create ingress hosts \
  --rule="a.example.local/=site-a:80" \
  --rule="b.example.local/=site-b:80"
```
