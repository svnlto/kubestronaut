# Exercise 3: Pod with Init Container (★★☆)

Time: 6-7 minutes

## Task

Create a pod that:

- Is named `init-demo`
- Has a main container named `main` using image `nginx:alpine`
  - Command: `['/bin/sh', '-c']`
  - Args: `['echo App started && nginx -g "daemon off;"']`
- Has an init container named `init-setup` using image `busybox:1.35`
  - Command: `sh -c "echo 'Initializing...' && sleep 5"`

## Hint

Use `kubectl run --dry-run=client -o yaml` to generate base YAML, then add the
`initContainers` section at the same level as `containers` under `spec`. The init container
runs to completion before the main container starts.

## Verification

Check that:

- Pod is running: `kubectl get pod init-demo`
- Init container completed: `kubectl describe pod init-demo | grep -A 5 "Init Containers"`
- Check init container logs: `kubectl logs init-demo -c init-setup`
- Check main container logs: `kubectl logs init-demo -c main`

**Useful commands:** `kubectl run`, `kubectl logs`, `kubectl describe pod`
