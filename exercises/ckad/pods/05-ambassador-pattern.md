# Exercise 5: Ambassador Container Pattern (★★☆)

Time: 6-8 minutes

## Task

Create a pod that:

- Is named `ambassador-pod`
- Has a main container named `app` using image `nginx:alpine`
  (serves as the main application)
- Has an ambassador container named `proxy` using image `busybox:1.35` with command `sleep 3600`
  (represents the ambassador/proxy sidecar)
- Both containers should be in the same pod (sharing network namespace)
- Add labels: `app=ambassador`, `pattern=proxy`

For this exercise, focus on the multi-container structure - in real scenarios, the
ambassador would proxy requests to external services or provide protocol translation.

## Hint

In the ambassador pattern, the ambassador container acts as a proxy between the main
application and external services. Both containers share the same network namespace and can
communicate via localhost. Use `kubectl run` with `--dry-run=client -o yaml` to generate a
template, then add the second container with appropriate command.

## Verification

Check that:

- Pod is running with 2/2 containers ready: `kubectl get pod ambassador-pod`
- Both containers are running:
  `kubectl describe pod ambassador-pod | grep -A5 "Containers:"`
- Verify both container names (should show "app proxy"):
  `kubectl get pod ambassador-pod -o jsonpath='{.spec.containers[*].name}'`
- Both containers are in Ready state (should show "true true"):
  `kubectl get pod ambassador-pod -o jsonpath='{.status.containerStatuses[*].ready}'`
- Labels are correct: `kubectl get pod ambassador-pod --show-labels`
- Network namespace is shared (proxy can reach app via localhost):
  `kubectl exec ambassador-pod -c proxy -- wget -O- -q localhost:80 | grep "Welcome to nginx"`

**Useful commands:** `kubectl get pod`, `kubectl describe pod`, `kubectl exec`, `kubectl get pod -o jsonpath`
