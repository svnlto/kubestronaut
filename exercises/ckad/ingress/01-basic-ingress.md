# Exercise 1: Basic Ingress (★★☆)

Time: 6-7 minutes

## Task

1. Create a deployment `web` with image `nginx:alpine`, 2 replicas
2. Expose it with a service named `web-service` on port 80
3. Create an Ingress named `web-ingress` that routes traffic to the service at path `/`
4. Use host `example.local`

## Hint

Ingress requires an Ingress Controller. Use `kubectl create ingress` or write YAML with rules.

## Verification

Check that:

- Deployment running: `kubectl get deployment web`
- Service exists: `kubectl get service web-service`
- Ingress created: `kubectl get ingress web-ingress`
- Ingress shows host: `kubectl get ingress web-ingress -o yaml`
- Backend configured: `kubectl describe ingress web-ingress`

**Useful commands:** `kubectl create ingress`, `kubectl get ingress`, `kubectl describe ingress`
