# Exercise 1: Pod Security Context (★★☆)

Time: 5-6 minutes

## Task

Create a pod named `secure-pod` with:

- Image: `busybox:1.35`
- Command: `sh -c "sleep 3600"`
- Pod-level security context:
  - runAsUser: 1000
  - runAsGroup: 3000
  - fsGroup: 2000

## Hint

Security context sets user/group IDs and filesystem permissions. Pod-level applies to all containers.

## Verification

Check that:

- Pod running: `kubectl get pod secure-pod`
- Check user: `kubectl exec secure-pod -- id` (uid=1000, gid=3000)
- Check groups: `kubectl exec secure-pod -- id -G` (includes 2000)
- Security context set: `kubectl get pod secure-pod -o yaml | grep -A 5 securityContext`

**Useful commands:** `kubectl exec -- id`, `kubectl describe pod`, `kubectl get pod -o yaml`
