# Exercise 6: Service Troubleshooting (★★★)

Time: 8-10 minutes

## Task

A deployment exists but the service cannot reach the pods. Debug and fix the broken service:

**Step 1:** First, create the deployment:

```bash
kubectl create deployment webapp --image=nginx:alpine --replicas=3
kubectl label deployment webapp app=webapp
```

**Step 2:** The following service manifest has errors. Apply it and debug:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: broken-service
spec:
  selector:
    app: wrong-label
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
  type: ClusterIP
```

Your tasks:

1. Apply the broken service manifest
2. Use debugging commands to identify why the service has no endpoints
3. Find the issues:
   - Selector doesn't match deployment labels (should be `app: webapp`)
   - Target port is wrong (should be `80`, not `8080`)
4. Create a corrected service named `fixed-service`
5. Verify connectivity works through the fixed service

## Hint

Use `kubectl get endpoints broken-service` to check if any pods are selected (empty means selector mismatch).
Check deployment labels with `kubectl get deployment webapp --show-labels`. Compare service selector with pod labels.
Test connectivity: `kubectl run test-pod --image=busybox --rm -it --restart=Never -- wget -O- service-name:80`

## Verification

Check that:

- Broken service has no endpoints: `kubectl get endpoints broken-service` (should show `<none>`)
- Fixed service has 3 endpoints: `kubectl get endpoints fixed-service` (should show 3 pod IPs)
- Selector matches: `kubectl get svc fixed-service -o jsonpath='{.spec.selector.app}'` (should be `webapp`)
- TargetPort is correct: `kubectl get svc fixed-service -o jsonpath='{.spec.ports[0].targetPort}'` (should be `80`)
- Service works: `kubectl run test --image=busybox --rm -it --restart=Never -- wget -qO- fixed-service:80`
  (should return nginx welcome page)

**Useful commands:** `kubectl get endpoints`, `kubectl describe svc`, `kubectl get pods --show-labels`,
`kubectl run` for testing
