# Exercise 3: Allow from Specific Namespace (★★★)

Time: 7-8 minutes

## Task

1. Create namespaces: `prod` and `dev`
2. In `prod`: create pod `api` (nginx, label `app=api`)
3. In `dev`: create pod `client` (busybox)
4. Create NetworkPolicy in `prod` that allows ingress to `app=api` only from namespace `dev`

## Hint

Use `namespaceSelector` in `ingress.from`. Label namespace with `kubectl label namespace dev name=dev`.

## Verification

Check that:

- Namespaces exist: `kubectl get ns prod dev`
- Pods exist: `kubectl get pods -n prod`, `kubectl get pods -n dev`
- NetworkPolicy exists: `kubectl get networkpolicy -n prod`
- Dev can access: `kubectl exec client -n dev -- wget -O- api.prod:80`
- Default namespace cannot

**Useful commands:** `kubectl label namespace`, `kubectl exec -n`, `kubectl describe networkpolicy -n`
