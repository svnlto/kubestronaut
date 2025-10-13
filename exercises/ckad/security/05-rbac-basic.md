# Exercise 5: RBAC - Role and RoleBinding (★★★)

Time: 8-10 minutes

## Task

1. Create a ServiceAccount `pod-reader`
2. Create a Role `pod-reader-role` that allows:
   - Resources: pods
   - Verbs: get, list, watch
3. Create a RoleBinding `pod-reader-binding` that binds the role to the ServiceAccount
4. Test access

## Hint

RBAC: Role defines permissions, RoleBinding assigns role to subject (user/SA/group).

## Verification

Check that:

- SA exists: `kubectl get sa pod-reader`
- Role exists: `kubectl get role pod-reader-role`
- RoleBinding exists: `kubectl get rolebinding pod-reader-binding`
- Describe role: `kubectl describe role pod-reader-role`
- Test with: `kubectl auth can-i list pods --as=system:serviceaccount:default:pod-reader`

**Useful commands:** `kubectl create role`, `kubectl create rolebinding`, `kubectl auth can-i --as`
