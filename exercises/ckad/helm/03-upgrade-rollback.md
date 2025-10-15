# Exercise 3: Upgrade and Rollback Helm Release (★★☆)

Time: 7-9 minutes

## Task

Manage the lifecycle of a Helm release:

- Install the `bitnami/nginx` chart with release name `my-nginx` and 1 replica
- Upgrade the release to use 3 replicas using `helm upgrade`
- Check the revision history to see both versions
- Perform a rollback to the first revision
- Verify that the replica count returns to 1

## Hint

Use `helm upgrade <release-name> <chart>` with `--set` to modify values. The `helm history` command shows all
revisions. Use `helm rollback <release-name> <revision>` to rollback to a specific revision.

## Verification

Check that:

- The initial installation creates 1 replica
- After upgrade, there are 3 replicas: `kubectl get pods -l app.kubernetes.io/instance=my-nginx`
- The history shows at least 2 revisions: `helm history my-nginx`
- After rollback, there is 1 replica again: `kubectl get deployment -l app.kubernetes.io/instance=my-nginx -o jsonpath='{.items[0].spec.replicas}'`
- The history shows 3 total revisions (install, upgrade, rollback): `helm history my-nginx`

**Useful commands:** `helm install`, `helm upgrade`, `helm history`, `helm rollback`, `kubectl get pods`, `kubectl get deployment`
