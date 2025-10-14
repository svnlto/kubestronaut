# Exercise 8: Pod with Environment Variables from ConfigMap and Secret (★★☆)

Time: 5-7 minutes

## Task

Create a pod that demonstrates different ways to inject environment variables:

- Create a ConfigMap named `app-config` with keys: `APP_MODE=production` and `LOG_LEVEL=info`
- Create a Secret named `app-secret` with keys: `DB_PASSWORD=supersecret` and `API_KEY=abc123xyz`
- Create a pod named `webapp` using the `nginx:alpine` image that:
  - Has an environment variable `APP_MODE` from the ConfigMap key `APP_MODE`
  - Has an environment variable `LOG_LEVEL` from the ConfigMap key `LOG_LEVEL`
  - Has an environment variable `DB_PASSWORD` from the Secret key `DB_PASSWORD`
  - Has an environment variable `API_KEY` from the Secret key `API_KEY`
  - Has a direct environment variable `ENVIRONMENT=staging`

## Hint

Use `kubectl create configmap` and `kubectl create secret generic` with `--from-literal` flag for quick creation.
For the pod, use `valueFrom.configMapKeyRef` and `valueFrom.secretKeyRef` in the env section.

## Verification

Check that:

- ConfigMap and Secret exist with correct data
- Pod is running
- All environment variables are correctly set in the container

**Useful commands:** `kubectl get configmap app-config -o yaml`, `kubectl get secret app-secret -o yaml`,
`kubectl exec webapp -- env | grep -E "APP_MODE|LOG_LEVEL|DB_PASSWORD|API_KEY|ENVIRONMENT"`
