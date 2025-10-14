# Exercise 3: Debug Failing Pod (★★★)

Time: 7-9 minutes

## Task

The following pod manifest contains errors. Debug and fix it, then create the corrected pod:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: broken-app
spec:
  containers:
  - name: nginx
    image: nginx:latst
    command: ["nonexistent-command"]
    ports:
    - containerPort: 80
      protocol: UDP
```

Your tasks:

1. Copy the manifest above and apply it
2. Observe the pod status and behavior
3. Use debugging commands to identify all issues:
   - Image pull error (typo in image tag)
   - Wrong command that causes crash
   - Incorrect protocol for HTTP traffic
4. Create a corrected pod named `fixed-app` that:
   - Uses correct image tag: `nginx:alpine`
   - Removes the invalid command (use default nginx command)
   - Uses correct protocol: `TCP`

## Hint

Use `kubectl describe pod broken-app` to see events showing image pull errors. If the pod starts, use `kubectl logs broken-app`
to see crash errors. Check `kubectl get events` for recent cluster events related to this pod.

## Verification

Check that:

- Fixed pod is running: `kubectl get pod fixed-app` (should show Running status, not CrashLoopBackOff)
- Image is correct: `kubectl get pod fixed-app -o jsonpath='{.spec.containers[0].image}'` (should be nginx:alpine)
- No custom command: `kubectl get pod fixed-app -o jsonpath='{.spec.containers[0].command}'` (should be empty)
- Protocol is TCP: `kubectl get pod fixed-app -o jsonpath='{.spec.containers[0].ports[0].protocol}'`
- Pod responds to HTTP: `kubectl exec fixed-app -- curl -s localhost:80` (should return nginx welcome page)

**Useful commands:** `kubectl describe pod`, `kubectl logs`, `kubectl get events`, `kubectl exec`
