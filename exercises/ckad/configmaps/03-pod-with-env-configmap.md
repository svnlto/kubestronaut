# Exercise 3: Pod with ConfigMap as Environment Variables (★★☆)

Time: 5-7 minutes

## Task

1. Create a ConfigMap named `env-config` with:
   - `API_URL=https://api.example.com`
   - `API_VERSION=v1`
   - `TIMEOUT=30`
2. Create a pod named `env-pod` with image `busybox:1.35`
3. The pod should:
   - Use command: `sh -c "env | grep API; sleep 3600"`
   - Have environment variables from the ConfigMap
   - Load `API_URL` as env var `API_URL`
   - Load `API_VERSION` as env var `API_VERSION`
4. Verify the environment variables are set correctly

## Hint

Use `valueFrom.configMapKeyRef` to load individual values, or use `envFrom.configMapRef` to load all values
at once. The latter is faster but loads all keys.

## Verification

Check that:

- ConfigMap exists: `kubectl get configmap env-config`
- Pod is running: `kubectl get pod env-pod`
- Environment variables are set: `kubectl logs env-pod`
- Check specific env var: `kubectl exec env-pod -- env | grep API_URL`
- All ConfigMap values available: `kubectl exec env-pod -- env | grep -E "API|TIMEOUT"`

**Useful commands:** `kubectl create configmap`, `kubectl logs`, `kubectl exec`
