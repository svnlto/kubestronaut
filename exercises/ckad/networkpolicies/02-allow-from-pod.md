# Exercise 2: Allow from Specific Pod (★★☆)

Time: 6-7 minutes

## Task

1. Create pods: `frontend` (nginx, label `app=frontend`) and `backend` (nginx, label `app=backend`)
2. Create NetworkPolicy `backend-policy` that:
   - Applies to pods with `app=backend`
   - Allows ingress only from pods with `app=frontend`
   - Denies all other ingress
3. Test: frontend can access backend, but other pods cannot

## Hint

Use `podSelector` in `spec` to apply policy, and `podSelector` in `ingress.from` to allow specific pods.

## Verification

Check that:

- Both pods running: `kubectl get pods`
- NetworkPolicy exists: `kubectl get networkpolicy backend-policy`
- Frontend can access: `kubectl exec frontend -- wget -O- backend:80`
- Other pods cannot: `kubectl run test --image=busybox --rm -it -- wget -O- backend:80 --timeout=2` (fails)

**Useful commands:** `kubectl exec`, `kubectl get networkpolicy`, `kubectl describe networkpolicy`
