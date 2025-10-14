# Exercise 14: Pod with Service Account (★★☆)

Time: 5-7 minutes

## Task

Create a pod that uses a custom service account with specific permissions:

- Create a ServiceAccount named `app-reader`
- Create a Role named `pod-reader` that allows `get`, `list`, and `watch` on `pods` resources
- Create a RoleBinding named `read-pods` that binds the `pod-reader` role to the `app-reader` service account
- Create a pod named `kubectl-pod` that:
  - Uses the `bitnami/kubectl:latest` image
  - Uses the `app-reader` service account
  - Runs command: `sh -c "kubectl get pods && sleep 3600"`
  - Has label `role=api-client`

## Hint

Service accounts provide an identity for pods to interact with the Kubernetes API.
Use `kubectl create serviceaccount`, `kubectl create role`, and `kubectl create rolebinding` for quick creation.
The pod spec has a `serviceAccountName` field.

## Verification

Check that:

- ServiceAccount, Role, and RoleBinding are created correctly
- Pod is using the correct service account
- Pod can successfully list pods (check logs)
- Pod cannot perform unauthorized actions (try to delete a pod from within)

**Useful commands:** `kubectl get sa app-reader`, `kubectl get role pod-reader`,
`kubectl get rolebinding read-pods`, `kubectl describe pod kubectl-pod | grep "Service Account"`,
`kubectl logs kubectl-pod`, `kubectl exec kubectl-pod -- kubectl auth can-i delete pods`
