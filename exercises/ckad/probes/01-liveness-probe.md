# Exercise 1: Liveness Probe (★☆☆)

Time: 4-5 minutes

## Task

Create a pod named `liveness-pod` that:

- Uses image `nginx:alpine`
- Has a liveness probe:
  - Type: HTTP GET request to `/` on port 80
  - Initial delay: 5 seconds
  - Period: 10 seconds

## Hint

Liveness probes determine if a container is healthy. If it fails, Kubernetes restarts the container. Add probe under `spec.containers[0].livenessProbe`.

## Verification

Check that:

- Pod is running: `kubectl get pod liveness-pod`
- Liveness probe configured: `kubectl describe pod liveness-pod | grep -A 5 Liveness`
- Probe is passing: Pod remains Running (not restarting)
- Check restart count:
  `kubectl get pod liveness-pod -o jsonpath='{.status.containerStatuses[0].restartCount}'` (should be 0)
- View probe details: `kubectl get pod liveness-pod -o yaml | grep -A 10 livenessProbe`

**Useful commands:** `kubectl describe pod`, `kubectl get pod`, `kubectl logs`
