# Exercise 6: Cleanup CronJob with RBAC (★★★)

Time: 10-12 minutes

## Task

Create a CronJob that:

- Name: `cleanup-job`
- Schedule: Every hour
- Container: Uses `bitnami/kubectl:latest` image
- Command: Delete completed pods (status.phase==Succeeded)
- ServiceAccount with appropriate RBAC permissions (Role, RoleBinding)
- restartPolicy: OnFailure

**Hint:** You'll need to create a ServiceAccount, Role (with permissions to get, list, delete pods), and RoleBinding.

## Verification

Check that:

- ServiceAccount `cleanup-sa` exists
- Role has permissions: get, list, delete on pods
- RoleBinding connects ServiceAccount to Role
- CronJob spec references `serviceAccountName: cleanup-sa`
- Manual test job successfully deletes completed pods
- Logs show cleanup actions

**Useful commands:** `kubectl get sa/role/rolebinding`, `kubectl describe role`, `kubectl create job --from=cronjob`
