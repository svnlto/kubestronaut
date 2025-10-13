# Exercise 5: Combined Probes (★★★)

Time: 8-10 minutes

## Task

Create a pod named `multi-probe` with all three probe types:

- Image: `nginx:alpine`
- Startup probe:
  - HTTP GET to `/` port 80
  - Initial delay: 0
  - Period: 2 seconds
  - Failure threshold: 15
- Readiness probe:
  - HTTP GET to `/` port 80
  - Initial delay: 0
  - Period: 5 seconds
- Liveness probe:
  - HTTP GET to `/` port 80
  - Initial delay: 0
  - Period: 10 seconds
- Create a service to observe readiness impact

## Hint

Order: Startup probe runs first. Once it succeeds, readiness and liveness probes start.
All three work together to ensure healthy, ready containers.

## Verification

Check that:

- Pod is running and ready: `kubectl get pod multi-probe`
- All three probes configured: `kubectl describe pod multi-probe | grep -A 5 -E "Startup|Liveness|Readiness"`
- Pod becomes ready quickly: `kubectl get pod multi-probe -w`
- Service endpoints include pod: `kubectl expose pod multi-probe --port=80 && kubectl get endpoints multi-probe`
- No restarts: `kubectl get pod multi-probe` (RESTARTS = 0)

**Useful commands:** `kubectl describe pod`, `kubectl get pod -w`, `kubectl get endpoints`
