# Exercise 5: Multi-Port Service (★★☆)

Time: 6-8 minutes

## Task

Create a service that exposes multiple ports:

1. Create a pod named `multi-app` with image `nginx:alpine`, labels `app=multi`
2. Create a service named `multi-service` that exposes:
   - Port 80 (name: `http`) targeting container port 80
   - Port 443 (name: `https`) targeting container port 443
3. Service type should be ClusterIP
4. Verify both ports are configured correctly

## Hint

Multi-port services require each port to have a name. Use `kubectl create service` with `--dry-run=client -o yaml` to
generate base YAML, then add multiple ports. Each port needs: `name`, `port`, `targetPort`, and `protocol`.

## Verification

Check that:

- Service is created: `kubectl get svc multi-service`
- Service has 2 ports: `kubectl get svc multi-service -o jsonpath='{.spec.ports[*].port}'`
- Ports are named correctly: `kubectl get svc multi-service -o jsonpath='{.spec.ports[*].name}'`
- Both ports target correct container ports: `kubectl describe svc multi-service`
- Endpoints exist for the pod: `kubectl get endpoints multi-service`

**Useful commands:** `kubectl get svc -o yaml`, `kubectl describe svc`, `kubectl get endpoints`
