# Exercise 1: Deny All Network Policy (★★☆)

Time: 5-6 minutes

## Task

1. Create a namespace `secure-ns`
2. Create a pod named `web` with image `nginx:alpine` and label `app=web`
3. Create a NetworkPolicy named `deny-all` that blocks all ingress traffic
4. Verify the pod is not accessible

## Hint

Default is allow-all. NetworkPolicy with empty ingress rules denies all ingress. Test with temporary pod.

## Verification

Check that:

- Namespace exists: `kubectl get ns secure-ns`
- Pod running: `kubectl get pod web -n secure-ns`
- NetworkPolicy created: `kubectl get networkpolicy deny-all -n secure-ns`
- Test fails: `kubectl run test --image=busybox --rm -it -n secure-ns -- wget -O- web:80 --timeout=2` (should timeout)

**Useful commands:** `kubectl get networkpolicy`, `kubectl describe networkpolicy`
