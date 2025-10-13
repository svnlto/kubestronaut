# Exercise 5: Ambassador Container Pattern (★★☆)

Time: 6-8 minutes

## Task

Create a pod that:

- Is named `ambassador-pod`
- Has a main container named `web` using image `nginx:alpine`
- Has an ambassador container named `proxy` using image `haproxy:2.6-alpine`
- Both containers should be able to communicate via localhost
- Add labels: `app=ambassador`, `pattern=proxy`

For this exercise, focus on the structure - in real scenarios, the ambassador would proxy requests to external services.

## Hint

In the ambassador pattern, the sidecar (ambassador) represents the main container to the outside world.
Both containers share the same network namespace and can communicate via localhost.

## Verification

Check that:

- Pod is running: `kubectl get pod ambassador-pod`
- Both containers are running: `kubectl get pod ambassador-pod -o jsonpath='{.status.containerStatuses[*].name}'`
- Containers share network: `kubectl exec ambassador-pod -c web -- nc -zv localhost 8080` (if proxy listens on 8080)
- Labels are correct: `kubectl get pod ambassador-pod --show-labels`

**Useful commands:** `kubectl get pod`, `kubectl exec`, `kubectl describe pod`
