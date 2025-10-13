# Exercise 4: Resource Limits (★★☆)

Time: 5-6 minutes

## Task

Create a pod named `limited-pod` with:

- Image: `nginx:alpine`
- Resource requests: CPU 100m, memory 128Mi
- Resource limits: CPU 200m, memory 256Mi

## Hint

Requests: guaranteed resources. Limits: maximum allowed. Pod evicted if exceeds memory limit.

## Verification

Check that:

- Pod running: `kubectl get pod limited-pod`
- Requests set: `kubectl describe pod limited-pod | grep -A 4 Requests`
- Limits set: `kubectl describe pod limited-pod | grep -A 4 Limits`
- Values correct: `kubectl get pod limited-pod -o yaml | grep -A 10 resources`

**Useful commands:** `kubectl describe pod`, `kubectl get pod -o yaml`
