# Exercise 7: Pod Debugging and Troubleshooting (★★★)

Time: 8-12 minutes

## Task

Create a pod that has issues and debug it:

1. Create a pod named `broken-pod` with image `nginx:alpine`
2. The pod should have:
   - Resource requests that are too high: CPU `100`, memory `100Gi`
   - A non-existent configMap volume reference named `missing-config`
   - An environment variable from a non-existent secret `missing-secret`, key `password`
3. Identify why the pod fails
4. Fix the pod by creating a corrected version named `fixed-pod` that:
   - Has reasonable resource requests: CPU `100m`, memory `128Mi`
   - Removes the configMap volume
   - Removes the secret environment variable

## Hint

The pod will likely be in Pending or CreateContainerConfigError state. Use `kubectl describe pod` to see events and
error messages. You may need to delete and recreate the pod with fixes.

## Verification

Check that:

- Original pod fails: `kubectl get pod broken-pod` (shows error state)
- Describe shows errors: `kubectl describe pod broken-pod`
- Fixed pod is running: `kubectl get pod fixed-pod`
- Fixed pod has correct resources: `kubectl describe pod fixed-pod | grep -A 4 "Requests"`

**Useful commands:** `kubectl describe pod`, `kubectl get events`, `kubectl logs`, `kubectl delete pod`
