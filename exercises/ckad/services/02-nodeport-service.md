# Exercise 2: NodePort Service (★☆☆)

Time: 4-5 minutes

## Task

1. Create a deployment named `nodeport-app` with image `nginx:alpine`, 2 replicas, label `app=nodeport`
2. Create a NodePort service named `nodeport-service` that:
   - Exposes port 80
   - Has targetPort 80
   - Uses nodePort 30080 (or let Kubernetes assign one)
3. Verify the service is accessible via the node's IP

## Hint

Use `kubectl expose deployment --type=NodePort` or create service YAML with `type: NodePort`.
NodePort services expose the service on each node's IP at a static port (30000-32767 range).

## Verification

Check that:

- Service is created: `kubectl get svc nodeport-service`
- Service type is NodePort: `kubectl get svc nodeport-service -o jsonpath='{.spec.type}'`
- NodePort is assigned: `kubectl get svc nodeport-service -o jsonpath='{.spec.ports[0].nodePort}'`
- Endpoints exist: `kubectl get endpoints nodeport-service`
- Service has correct selector: `kubectl describe svc nodeport-service | grep Selector`

**Useful commands:** `kubectl expose`, `kubectl get svc`, `kubectl describe svc`
