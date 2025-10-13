# Exercise 4: Rollback Deployment (★★☆)

Time: 6-8 minutes

## Task

1. Create a deployment named `rollback-demo` with image `nginx:1.20` and 3 replicas
2. Record the deployment with `--record` flag (or use `kubectl annotate`)
3. Update the image to `nginx:1.21` (record this change)
4. Update the image to `nginx:invalid-tag` (this will fail)
5. Check the rollout status and notice the failure
6. Rollback to the previous working version
7. Verify the deployment is now running `nginx:1.21`

## Hint

Use `kubectl rollout undo deployment/<name>` to rollback. You can specify `--to-revision=<number>` to rollback to a
specific revision. Check history with `kubectl rollout history deployment/<name>`.

## Verification

Check that:

- Deployment is running: `kubectl get deployment rollback-demo`
- Image is `nginx:1.21`: `kubectl get deployment rollback-demo -o jsonpath='{.spec.template.spec.containers[0].image}'`
- All pods are ready: `kubectl get pods -l app=rollback-demo`
- Rollout history shows revisions: `kubectl rollout history deployment/rollback-demo`
- No pods with invalid image:
  `kubectl get pods -l app=rollback-demo -o jsonpath='{.items[*].spec.containers[0].image}' | grep -v invalid`

**Useful commands:** `kubectl rollout undo`, `kubectl rollout history`, `kubectl describe deployment`
