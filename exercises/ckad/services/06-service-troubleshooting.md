# Exercise 6: Service Troubleshooting (★★★)

Time: 8-10 minutes

## Task

Debug a broken service setup:

1. Create a deployment named `broken-app` with image `nginx:alpine`, 3 replicas, label `app=broken`
2. Create a service named `broken-service` with intentional issues:
   - Wrong selector (should be `app=broken` but use `app=wrong`)
   - Wrong targetPort (use 8080 instead of 80)
3. Verify the service doesn't work
4. Create a fixed service named `fixed-service` with correct configuration
5. Verify the fixed service works

## Hint

Use `kubectl get endpoints` to check if the service found any pods. Empty endpoints usually mean selector mismatch.
Use `kubectl describe svc` to see the selector and target port. Test connectivity with a temporary pod.

## Verification

Check that:

- Broken service has no endpoints: `kubectl get endpoints broken-service` (should be empty)
- Fixed service has 3 endpoints: `kubectl get endpoints fixed-service`
- Selector is correct: `kubectl get svc fixed-service -o jsonpath='{.spec.selector}'`
- TargetPort is correct: `kubectl get svc fixed-service -o jsonpath='{.spec.ports[0].targetPort}'`
- Service works: `kubectl run test --image=busybox --rm -it --restart=Never -- wget -O- fixed-service:80`

**Useful commands:** `kubectl get endpoints`, `kubectl describe svc`, `kubectl logs`, `kubectl run` for testing
