# Exercise 5: Deployment Strategy Configuration (★★☆)

Time: 6-8 minutes

## Task

Create a deployment that:

- Is named `strategy-demo`
- Uses image `nginx:alpine`
- Has 6 replicas
- Uses RollingUpdate strategy with:
  - maxSurge: 2 (max 2 extra pods during update)
  - maxUnavailable: 1 (max 1 pod unavailable during update)
- Has label `app=strategy`

## Hint

Generate base YAML with `kubectl create deployment --dry-run=client -o yaml`, then add the strategy section under
`spec.strategy`. The strategy type is `RollingUpdate` and the settings go under `spec.strategy.rollingUpdate`.

## Verification

Check that:

- Deployment is created: `kubectl get deployment strategy-demo`
- Strategy is RollingUpdate: `kubectl get deployment strategy-demo -o jsonpath='{.spec.strategy.type}'`
- maxSurge is 2: `kubectl get deployment strategy-demo -o jsonpath='{.spec.strategy.rollingUpdate.maxSurge}'`
- maxUnavailable is 1: `kubectl get deployment strategy-demo -o jsonpath='{.spec.strategy.rollingUpdate.maxUnavailable}'`
- All 6 replicas running: `kubectl get pods -l app=strategy --no-headers | wc -l`

**Useful commands:** `kubectl get deployment -o yaml`, `kubectl describe deployment`, `kubectl explain deployment.spec.strategy`
