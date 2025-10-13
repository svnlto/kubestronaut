# Exercise 1: ConfigMap from Literals (★☆☆)

Time: 3-4 minutes

## Task

1. Create a ConfigMap named `app-config` with the following key-value pairs:
   - `app_mode=production`
   - `log_level=info`
   - `max_connections=100`
2. Verify the ConfigMap contains all three values
3. View the ConfigMap data in YAML format

## Hint

Use `kubectl create configmap` with the `--from-literal` flag. You can specify multiple `--from-literal` flags in one command.

## Verification

Check that:

- ConfigMap is created: `kubectl get configmap app-config`
- All three keys exist: `kubectl describe configmap app-config`
- Values are correct: `kubectl get configmap app-config -o yaml`
- Specific value: `kubectl get configmap app-config -o jsonpath='{.data.app_mode}'`

**Useful commands:** `kubectl create configmap --from-literal`, `kubectl get configmap`, `kubectl describe configmap`
