# Exercise 2: Path-Based Routing (★★☆)

Time: 7-8 minutes

## Task

1. Create two deployments: `app1` (nginx) and `app2` (httpd)
2. Expose each with services: `app1-service` and `app2-service`
3. Create Ingress `path-ingress` that routes:
   - `/app1` → `app1-service`
   - `/app2` → `app2-service`
   - Host: `apps.local`

## Hint

Ingress rules support multiple paths. Each path specifies pathType (Prefix/Exact) and backend service.

## Verification

Check that:

- Both deployments running: `kubectl get deployments`
- Both services exist: `kubectl get services`
- Ingress created: `kubectl get ingress path-ingress`
- Two paths configured: `kubectl describe ingress path-ingress`
- Rules show both backends: `kubectl get ingress path-ingress -o yaml`

**Useful commands:** `kubectl get ingress`, `kubectl describe ingress`
