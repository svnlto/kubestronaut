# Exercise 3: PersistentVolumeClaim (★★☆)

Time: 6-7 minutes

## Task

1. Create a PVC named `my-pvc` requesting:
   - Storage: 1Gi
   - Access mode: ReadWriteOnce
   - Storage class: standard (or available class)
2. Create a pod named `pvc-pod` that:
   - Uses image `nginx:alpine`
   - Mounts the PVC at `/usr/share/nginx/html`
3. Verify the volume is bound and mounted

## Hint

PVC requests storage from cluster. StorageClass provisions PV automatically. Pod uses PVC name to mount volume.

## Verification

Check that:

- PVC created and bound: `kubectl get pvc my-pvc`
- PV auto-created: `kubectl get pv`
- Pod running: `kubectl get pod pvc-pod`
- Volume mounted: `kubectl exec pvc-pod -- df -h /usr/share/nginx/html`
- Write test: `kubectl exec pvc-pod -- sh -c "echo test > /usr/share/nginx/html/index.html"`

**Useful commands:** `kubectl get pvc`, `kubectl get pv`, `kubectl exec`
