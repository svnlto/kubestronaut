# Exercise 4: Failing Liveness Probe (★★★)

Time: 7-9 minutes

## Task

1. Create a pod named `failing-liveness` with:
   - Image: `busybox:1.35`
   - Command: `sh -c "touch /tmp/healthy; sleep 30; rm /tmp/healthy; sleep 600"`
   - Liveness probe:
     - Type: exec command `cat /tmp/healthy`
     - Initial delay: 5 seconds
     - Period: 5 seconds
2. Watch the pod restart after the probe fails (after 30 seconds)
3. Verify the restart count increases

## Hint

This simulates an application that becomes unhealthy after 30 seconds.
The liveness probe detects this and Kubernetes restarts the container.

## Verification

Check that:

- Pod initially running: `kubectl get pod failing-liveness`
- After 30+ seconds, probe fails and pod restarts
- Restart count increases: `kubectl get pod failing-liveness` (RESTARTS column)
- Check events show liveness failure: `kubectl describe pod failing-liveness | grep -i liveness`
- Logs show the pattern repeating: `kubectl logs failing-liveness`
- Previous container logs: `kubectl logs failing-liveness --previous`

**Useful commands:** `kubectl get pod -w`, `kubectl describe pod`, `kubectl logs --previous`
