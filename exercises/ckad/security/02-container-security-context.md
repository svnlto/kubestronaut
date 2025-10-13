# Exercise 2: Container Security Context (★★☆)

Time: 6-7 minutes

## Task

Create a pod named `readonly-pod` with:

- Image: `nginx:alpine`
- Container-level security context:
  - readOnlyRootFilesystem: true
  - allowPrivilegeEscalation: false
  - runAsNonRoot: true
  - capabilities: drop ALL

## Hint

Container-level security context overrides pod-level. readOnlyRootFilesystem prevents writes to container filesystem.

## Verification

Check that:

- Pod running: `kubectl get pod readonly-pod`
- Cannot write: `kubectl exec readonly-pod -- touch /tmp/test` (should fail)
- Running as non-root: `kubectl exec readonly-pod -- id` (uid != 0)
- Capabilities dropped: `kubectl exec readonly-pod -- cat /proc/1/status | grep Cap`

**Useful commands:** `kubectl exec`, `kubectl describe pod`
