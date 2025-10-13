# Exercise 5: Update ConfigMap and Observe Changes (★★★)

Time: 7-9 minutes

## Task

1. Create a ConfigMap named `dynamic-config` with `message=Hello Version 1`
2. Create a pod named `reader-pod` with image `busybox:1.35`
   - Command: `sh -c "while true; do cat /config/message; sleep 5; done"`
   - Mount ConfigMap as volume at `/config`
3. Verify the pod reads the original message
4. Update the ConfigMap to `message=Hello Version 2`
5. Wait and verify the pod eventually reads the new message (may take up to 60 seconds)
6. Compare with env var approach: create another pod that uses ConfigMap as env var and note it doesn't update

## Hint

ConfigMap mounted as volume updates automatically (with kubelet sync period delay, typically 60s).
ConfigMap loaded as environment variables does NOT update - requires pod restart.
Use `kubectl edit configmap` or `kubectl patch` to update.

## Verification

Check that:

- ConfigMap created: `kubectl get configmap dynamic-config`
- Pod is running: `kubectl get pod reader-pod`
- Initial message appears in logs: `kubectl logs reader-pod --tail=5`
- ConfigMap updated: `kubectl get configmap dynamic-config -o yaml`
- New message appears in logs after update: `kubectl logs reader-pod --tail=5` (wait up to 60s)
- Volume-mounted config updates, env var doesn't

**Useful commands:** `kubectl edit configmap`, `kubectl logs`, `kubectl patch configmap`
