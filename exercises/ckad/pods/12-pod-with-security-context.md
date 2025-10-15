# Exercise 12: Pod with Security Context (★★★)

Time: 7-9 minutes

## Task

Create a pod with security restrictions to follow the principle of least privilege:

- Create a pod named `secure-app` using the `nginx:alpine` image
- Configure **pod-level security context**:
  - Run as user ID `1000`
  - Run as group ID `3000`
  - Use `fsGroup: 2000` for volume permissions
- Configure **container-level security context**:
  - Set `allowPrivilegeEscalation: false`
  - Set `readOnlyRootFilesystem: true`
  - Add capability `NET_BIND_SERVICE`
  - Drop capability `ALL`
- Add an emptyDir volume named `cache` mounted at `/var/cache/nginx` (root filesystem is read-only, nginx needs writable
  cache dir)
- Add another emptyDir volume named `run` mounted at `/var/run`

## Hint

Security contexts can be set at both pod and container level. Container-level settings override pod-level settings.
Use `kubectl explain pod.spec.securityContext` and `kubectl explain pod.spec.containers.securityContext`.
Remember that nginx needs some writable directories to function.

## Verification

Check that:

- Pod is running successfully
- Security contexts are correctly configured at both levels
- Container is running with the specified user and group IDs
- Root filesystem is read-only
- Capabilities are configured correctly

**Useful commands:** `kubectl describe pod secure-app | grep -A 15 "Security Context"`,
`kubectl exec secure-app -- id`, `kubectl exec secure-app -- touch /test.txt` (should fail),
`kubectl exec secure-app -- touch /cache/test.txt` (should succeed)
