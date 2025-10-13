# Exercise 1: ClusterIP Service (★☆☆)

Time: 3-4 minutes

## Task

1. Create a deployment named `web` with image `nginx:alpine` and 3 replicas, label `app=web`
2. Expose the deployment with a ClusterIP service named `web-service`
3. The service should expose port 80 and target port 80
4. Verify the service is accessible from within the cluster

## Hint

Use `kubectl expose deployment` to quickly create a service. ClusterIP is the default service type and provides internal
cluster access only.

## Verification

Check that:

- Service is created: `kubectl get svc web-service`
- Service type is ClusterIP: `kubectl get svc web-service -o jsonpath='{.spec.type}'`
- Service has correct port: `kubectl get svc web-service -o jsonpath='{.spec.ports[0].port}'`
- Endpoints are populated: `kubectl get endpoints web-service`
- Test connectivity: `kubectl run test-pod --image=busybox --rm -it --restart=Never -- wget -O- web-service:80`

**Useful commands:** `kubectl expose`, `kubectl get svc`, `kubectl get endpoints`
