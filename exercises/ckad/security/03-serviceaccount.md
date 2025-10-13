# Exercise 3: ServiceAccount (★★☆)

Time: 6-7 minutes

## Task

1. Create a ServiceAccount named `app-sa`
2. Create a pod named `sa-pod` that:
   - Uses image `nginx:alpine`
   - Uses the ServiceAccount `app-sa`
3. Verify the pod uses the custom ServiceAccount

## Hint

ServiceAccounts provide identity for pods to access Kubernetes API. Default SA is used if not specified.

## Verification

Check that:

- ServiceAccount exists: `kubectl get serviceaccount app-sa`
- Pod created: `kubectl get pod sa-pod`
- Pod uses SA: `kubectl get pod sa-pod -o jsonpath='{.spec.serviceAccountName}'` (should be app-sa)
- Token mounted: `kubectl exec sa-pod -- ls /var/run/secrets/kubernetes.io/serviceaccount/`
- Token content: `kubectl exec sa-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/token`

**Useful commands:** `kubectl create serviceaccount`, `kubectl get sa`, `kubectl describe pod`
