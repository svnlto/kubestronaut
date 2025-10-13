# Exercise 6: Pause and Resume Rollout (★★★)

Time: 7-9 minutes

## Task

1. Create a deployment named `pause-demo` with image `nginx:1.20` and 4 replicas
2. Pause the deployment rollout
3. Update the image to `nginx:1.21`
4. Update the replica count to 6
5. Verify that no changes have been applied yet
6. Resume the rollout
7. Verify all changes are applied together (image updated AND scaled to 6)

## Hint

Use `kubectl rollout pause deployment/<name>` to pause and `kubectl rollout resume deployment/<name>` to resume.
While paused, you can make multiple changes that will all be applied when you resume.

## Verification

Check that:

- After pause and changes, deployment still shows old config
- After resume, deployment is updated: `kubectl get deployment pause-demo`
- Image is nginx:1.21: `kubectl get deployment pause-demo -o jsonpath='{.spec.template.spec.containers[0].image}'`
- Replica count is 6: `kubectl get deployment pause-demo -o jsonpath='{.spec.replicas}'`
- All 6 pods are running with new image: `kubectl get pods -l app=pause-demo`
- Only one rollout in history for both changes: `kubectl rollout history deployment/pause-demo`

**Useful commands:** `kubectl rollout pause`, `kubectl rollout resume`, `kubectl rollout status`
