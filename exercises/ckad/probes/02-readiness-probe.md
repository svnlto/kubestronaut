# Exercise 2: Readiness Probe (★★☆)

Time: 5-6 minutes

## Task

Create a deployment named `ready-deploy` that:

- Uses image `nginx:alpine`
- Has 3 replicas
- Has a readiness probe:
  - Type: HTTP GET to `/` on port 80
  - Initial delay: 3 seconds
  - Period: 5 seconds
- Expose it with a service to see readiness impact on endpoints

## Hint

Readiness probes determine if a container is ready to receive traffic. Failed probes remove pod from service endpoints.
Add under `spec.template.spec.containers[0].readinessProbe`.

## Verification

Check that:

- Deployment created: `kubectl get deployment ready-deploy`
- All 3 pods ready: `kubectl get pods -l app=ready-deploy`
- Readiness probe configured: `kubectl describe deployment ready-deploy | grep -A 5 Readiness`
- Service has 3 endpoints: `kubectl expose deployment ready-deploy --port=80 && kubectl get endpoints ready-deploy`
- Pods show READY 1/1: `kubectl get pods -l app=ready-deploy`

**Useful commands:** `kubectl describe pod`, `kubectl get endpoints`, `kubectl expose deployment`
