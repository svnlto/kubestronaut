# Exercise 1: Basic Pod Creation (★☆☆)

Time: 3-4 minutes

## Task

Create a pod that:

- Is named `nginx-pod`
- Uses the image `nginx:1.21`
- Has the label `app=web` and `tier=frontend`
- Is created in the `default` namespace

## Hint

Use imperative commands with `kubectl run` and add labels with the `--labels` flag.
You can use `--dry-run=client -o yaml` to generate YAML first if needed.

## Verification

Check that:

- Pod is running: `kubectl get pod nginx-pod`
- Labels are correct: `kubectl get pod nginx-pod --show-labels`
- Image is correct: `kubectl describe pod nginx-pod | grep Image`

**Useful commands:** `kubectl run`, `kubectl get pod`, `kubectl describe pod`
