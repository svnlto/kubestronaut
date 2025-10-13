# Exercise 7: Deployment with Health Checks (★★★)

Time: 8-10 minutes

## Task

Create a deployment that:

- Is named `healthy-app`
- Uses image `nginx:alpine`
- Has 3 replicas
- Has a readiness probe:
  - HTTP GET on path `/` port 80
  - Initial delay: 5 seconds
  - Period: 10 seconds
- Has a liveness probe:
  - HTTP GET on path `/` port 80
  - Initial delay: 15 seconds
  - Period: 20 seconds
- Has resource limits: CPU `200m`, memory `256Mi`
- Has resource requests: CPU `100m`, memory `128Mi`

## Hint

Generate base deployment YAML, then add probes under `spec.template.spec.containers[0]`. Probes go at the same level
as `image`, `name`, and `resources`.
Use `kubectl explain deployment.spec.template.spec.containers.livenessProbe` for structure.

## Verification

Check that:

- Deployment is created: `kubectl get deployment healthy-app`
- All 3 pods are running and ready: `kubectl get pods -l app=healthy-app`
- Readiness probe configured: `kubectl describe deployment healthy-app | grep -A 5 "Readiness"`
- Liveness probe configured: `kubectl describe deployment healthy-app | grep -A 5 "Liveness"`
- Resources configured: `kubectl describe deployment healthy-app | grep -A 5 "Limits"`
- Pods pass health checks: `kubectl get pods -l app=healthy-app -o jsonpath='{.items[*].status.conditions[?(@.type=="Ready")].status}'`

**Useful commands:** `kubectl describe deployment`, `kubectl get pods`, `kubectl explain deployment.spec.template.spec.containers`
