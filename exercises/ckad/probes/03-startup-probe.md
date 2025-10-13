# Exercise 3: Startup Probe (★★☆)

Time: 6-7 minutes

## Task

Create a pod named `startup-pod` with:

- Image: `busybox:1.35`
- Command: `sh -c "sleep 15; touch /tmp/ready; sleep 3600"`
- Startup probe:
  - Type: exec command `cat /tmp/ready`
  - Initial delay: 0 seconds
  - Period: 5 seconds
  - Failure threshold: 5
- Liveness probe (only starts after startup succeeds):
  - Type: exec command `cat /tmp/ready`
  - Period: 10 seconds

## Hint

Startup probes give slow-starting containers time to start before liveness/readiness probes begin.
Once startup probe succeeds, liveness and readiness probes take over.

## Verification

Check that:

- Pod is running: `kubectl get pod startup-pod`
- Startup probe configured: `kubectl describe pod startup-pod | grep -A 5 Startup`
- Pod eventually becomes Ready (after 15s + probe time)
- Check events: `kubectl describe pod startup-pod | grep -A 20 Events`
- Liveness probe only starts after startup succeeds

**Useful commands:** `kubectl describe pod`, `kubectl get pod -w`, `kubectl get events`
