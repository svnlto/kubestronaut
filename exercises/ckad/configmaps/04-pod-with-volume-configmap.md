# Exercise 4: Pod with ConfigMap as Volume (★★☆)

Time: 6-8 minutes

## Task

1. Create a ConfigMap named `nginx-config` with a file `nginx.conf`:

   ```text
   server {
       listen 80;
       server_name localhost;
       location / {
           return 200 'Hello from ConfigMap!';
       }
   }
   ```

2. Create a pod named `nginx-pod` with image `nginx:alpine`
3. Mount the ConfigMap as a volume at `/etc/nginx/conf.d/`
4. Verify the configuration file is mounted correctly

## Hint

Create ConfigMap with `--from-file` or use literal with proper formatting. Mount as volume by defining `volumes`
with `configMap` source and `volumeMounts` in container spec. Each key becomes a file in the mount path.

## Verification

Check that:

- ConfigMap exists: `kubectl get configmap nginx-config`
- Pod is running: `kubectl get pod nginx-pod`
- File is mounted: `kubectl exec nginx-pod -- ls /etc/nginx/conf.d/`
- File contents correct: `kubectl exec nginx-pod -- cat /etc/nginx/conf.d/nginx.conf`
- Can see ConfigMap data: `kubectl describe configmap nginx-config`

**Useful commands:** `kubectl exec`, `kubectl describe configmap`, `kubectl get pod`
