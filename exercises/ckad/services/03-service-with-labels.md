# Exercise 3: Service with Label Selectors (★★☆)

Time: 5-7 minutes

## Task

1. Create three pods:
   - Pod `frontend-1`: image `nginx:alpine`, labels `app=web`, `tier=frontend`, `version=v1`
   - Pod `frontend-2`: image `nginx:alpine`, labels `app=web`, `tier=frontend`, `version=v2`
   - Pod `backend-1`: image `nginx:alpine`, labels `app=web`, `tier=backend`
2. Create a service named `frontend-service` that:
   - Selects only frontend pods (both v1 and v2)
   - Exposes port 80
   - Type ClusterIP
3. Create a service named `v1-service` that selects only v1 frontend pods
4. Verify endpoints match the expected pods

## Hint

Service selectors use `matchLabels` logic - all specified labels must match.
Use `kubectl get endpoints` to see which pods are selected by each service.

## Verification

Check that:

- All three pods are running: `kubectl get pods --show-labels`
- `frontend-service` has 2 endpoints: `kubectl get endpoints frontend-service`
- `v1-service` has 1 endpoint: `kubectl get endpoints v1-service`
- Correct pods are selected: `kubectl describe svc frontend-service | grep Endpoints`
- Service selectors are correct: `kubectl get svc frontend-service -o jsonpath='{.spec.selector}'`

**Useful commands:** `kubectl get endpoints`, `kubectl describe svc`, `kubectl get pods -l <selector>`
