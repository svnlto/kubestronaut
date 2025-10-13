# Exercise 2: Pod with Resource Limits (★☆☆)

Time: 4-5 minutes

## Task

Create a pod that:

- Is named `resource-pod`
- Uses the image `nginx:alpine`
- Has resource requests: CPU `100m`, memory `128Mi`
- Has resource limits: CPU `200m`, memory `256Mi`
- Has the label `env=test`

## Hint

Generate the pod YAML with `kubectl run --dry-run=client -o yaml > pod.yaml`, then edit the file to add the resources
section under `spec.containers[0].resources`.

## Verification

Check that:

- Pod is running: `kubectl get pod resource-pod`
- Resources are set correctly: `kubectl describe pod resource-pod | grep -A 4 "Limits"`
- Check the resources: `kubectl get pod resource-pod -o jsonpath='{.spec.containers[0].resources}'`

**Useful commands:** `kubectl run`, `kubectl describe pod`, `kubectl get pod -o yaml`
