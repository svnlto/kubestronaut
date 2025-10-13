# Exercise 3: Debug Failing Pod (★★★)

Time: 7-9 minutes

## Task

1. Create a pod named `broken-app` with image `nginx:alpine` that has issues:
   - Wrong command that causes crash: `command: ["nonexistent-command"]`
2. Debug and identify the issue using various commands
3. Fix the pod by creating `fixed-app` with correct configuration

## Hint

Use `kubectl describe`, `kubectl logs`, `kubectl get events` to troubleshoot. Check pod status, events, and logs.

## Verification

Check that:

- Broken pod fails: `kubectl get pod broken-app` (CrashLoopBackOff or Error)
- Describe shows error: `kubectl describe pod broken-app | grep -A 10 Events`
- Logs show error: `kubectl logs broken-app` (if container started)
- Events show issues: `kubectl get events --field-selector involvedObject.name=broken-app`
- Fixed pod works: `kubectl get pod fixed-app` (Running)

**Useful commands:** `kubectl describe pod`, `kubectl logs`, `kubectl get events`, `kubectl exec`
