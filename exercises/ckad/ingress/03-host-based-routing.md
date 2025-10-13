# Exercise 3: Host-Based Routing (★★★)

Time: 8-9 minutes

## Task

1. Create deployments: `site-a` (nginx) and `site-b` (nginx)
2. Expose with services: `site-a-service` and `site-b-service`
3. Create Ingress `host-ingress` that routes:
   - `a.example.local` → `site-a-service`
   - `b.example.local` → `site-b-service`

## Hint

Multiple host rules in same Ingress. Each host has its own set of paths and backend.

## Verification

Check that:

- Deployments running: `kubectl get deployments`
- Services exist: `kubectl get services`
- Ingress created: `kubectl get ingress host-ingress`
- Two hosts configured: `kubectl get ingress host-ingress -o yaml`
- Rules show both hosts: `kubectl describe ingress host-ingress`

**Useful commands:** `kubectl get ingress`, `kubectl describe ingress`, `kubectl get ingress -o yaml`
