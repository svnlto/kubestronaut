# Exercise 3: Rolling Update (★★☆)

Time: 5-7 minutes

## Task

1. Create a deployment named `rolling-app` with:
   - Image: `nginx:1.20`
   - Replicas: 4
   - Label: `app=rolling`
2. Perform a rolling update to change the image to `nginx:1.21`
3. Monitor the rollout status
4. Verify the new image is deployed across all pods

## Hint

Use `kubectl set image deployment/<name> <container-name>=<new-image>` to update the image.
Use `kubectl rollout status` to watch the update progress.
Remember the container name defaults to the deployment name.

## Verification

Check that:

- Deployment exists: `kubectl get deployment rolling-app`
- All pods are running new image: `kubectl get pods -l app=rolling -o jsonpath='{.items[*].spec.containers[0].image}'`
- Rollout completed: `kubectl rollout status deployment/rolling-app`
- Check rollout history: `kubectl rollout history deployment/rolling-app`
- Old ReplicaSet has 0 pods: `kubectl get rs -l app=rolling`

**Useful commands:** `kubectl set image`, `kubectl rollout status`, `kubectl rollout history`
