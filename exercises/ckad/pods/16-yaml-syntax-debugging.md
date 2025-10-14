# Exercise 16: YAML Syntax Debugging (★★☆)

Time: 5-7 minutes

## Task

The following pod manifest has YAML syntax and field name errors. Debug and fix it:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: syntax-errors
  labels:
    app web
    tier: frontend
spec:
  containers:
  - name: nginx
    image: nginx:1.19
    Port:
    - containerPort: 80
    resources:
      request:
        cpu: 100m
        memory: 128Mi
      limits:
        cpu: 200m
        memory: 256Mi
    livenessProbe:
      httpGet:
        path: /healthz
        port: 80
      initialDelaySeconds: 5
      periodSeconds: 10
  restartPolicy: always
```

Your tasks:

1. Try to apply the manifest and observe the errors
2. Fix all syntax errors and field name mistakes:
   - Invalid label format (missing colon)
   - Wrong field name for ports (should be lowercase `ports`)
   - Wrong field name for requests (should be plural `requests`)
   - Wrong restartPolicy value (should be `Always` with capital A)
3. Create the corrected pod named `syntax-fixed`

## Hint

YAML syntax errors often show immediately when you try to apply. Field name errors will show as "unknown field" or
"validation error". Use `kubectl apply -f file.yaml --dry-run=client` to test without actually creating the resource.
Pay attention to case sensitivity in Kubernetes field values.

## Verification

Check that:

- Fixed pod is running: `kubectl get pod syntax-fixed` (should show Running status)
- Labels are correct: `kubectl get pod syntax-fixed --show-labels` (should show `app=web,tier=frontend`)
- Resources are set: `kubectl get pod syntax-fixed -o jsonpath='{.spec.containers[0].resources}'`
- Liveness probe exists: `kubectl get pod syntax-fixed -o jsonpath='{.spec.containers[0].livenessProbe}'`
- RestartPolicy is correct: `kubectl get pod syntax-fixed -o jsonpath='{.spec.restartPolicy}'` (should be `Always`)

**Useful commands:** `kubectl apply --dry-run=client`, `kubectl explain pod.spec`, `kubectl get -o yaml`
