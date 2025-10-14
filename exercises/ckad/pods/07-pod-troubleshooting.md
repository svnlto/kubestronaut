# Exercise 7: Pod Debugging and Troubleshooting (★★★)

Time: 8-12 minutes

## Task

The following pod manifest has multiple errors. Debug and fix it, then create the corrected pod:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: broken-pod
spec:
  containers:
  - name: nginx
    image: nginx:alpine
    resources:
      requests:
        cpu: "100"
        memory: "100Gi"
    env:
    - name: APP_CONFIG
      valueFrom:
        configMapKeyRef:
          name: missing-app-config
          key: config
    volumeMounts:
    - name: config-vol
      mountPath: /etc/config
  volumes:
  - name: config-vol
    configMap:
      name: missing-config
```

Your tasks:

1. Copy the manifest above and try to apply it
2. Read the error messages carefully
3. Fix all issues to create a working pod named `fixed-pod`:
   - Fix resource requests to reasonable values (CPU: `100m`, memory: `128Mi`)
   - Remove references to non-existent ConfigMaps (both env and volume)
4. Verify the corrected pod runs successfully

## Hint

Apply the broken manifest first to see the errors: `kubectl apply -f broken-pod.yaml`. Use
`kubectl describe pod` to see detailed error messages in events. Common issues: missing resources,
typos in resource values, non-existent ConfigMaps/Secrets.

## Verification

Check that:

- Fixed pod is running: `kubectl get pod fixed-pod` (should show Running status)
- Pod has correct resources:
  `kubectl get pod fixed-pod -o jsonpath='{.spec.containers[0].resources.requests}'`
- No volumes: `kubectl get pod fixed-pod -o jsonpath='{.spec.volumes}'` (should be empty)
- No env vars: `kubectl get pod fixed-pod -o jsonpath='{.spec.containers[0].env}'` (should be empty)

**Useful commands:** `kubectl describe pod`, `kubectl get events`, `kubectl apply`, `kubectl delete pod`
