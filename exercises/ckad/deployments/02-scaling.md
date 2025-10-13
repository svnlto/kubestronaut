# Exercise 2: Scaling Deployments (★☆☆)

Time: 3-5 minutes

## Task

1. Create a deployment named `scale-demo` with image `nginx:alpine` and 2 replicas
2. Scale the deployment to 5 replicas using the `kubectl scale` command
3. Verify all 5 pods are running
4. Scale it back down to 3 replicas
5. Verify the pod count is now 3

## Hint

Use `kubectl scale deployment <name> --replicas=<number>` to change the number of replicas.
You can watch the scaling process with `kubectl get pods -w`.

## Verification

Check that:

- Deployment exists: `kubectl get deployment scale-demo`
- Current replica count is 3: `kubectl get deployment scale-demo -o jsonpath='{.spec.replicas}'`
- Exactly 3 pods are running: `kubectl get pods -l app=scale-demo --no-headers | wc -l`
- ReplicaSet shows correct desired/current: `kubectl get rs -l app=scale-demo`

**Useful commands:** `kubectl scale`, `kubectl get deployment`, `kubectl get pods -w`
