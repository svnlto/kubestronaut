# Storage Exercises for CKAD

Kubernetes storage enables persistent data for containers. Understanding volumes, PersistentVolumes (PV),
PersistentVolumeClaims (PVC), and StorageClasses is essential for CKAD.

## Exercises

1. [EmptyDir Volume](01-emptydir-volume.md) (★☆☆) - 4-5 minutes
2. [HostPath Volume](02-hostpath-volume.md) (★★☆) - 5-6 minutes
3. [PersistentVolumeClaim](03-pvc-basic.md) (★★☆) - 6-7 minutes
4. [Manual PV and PVC](04-pv-pvc-manual.md) (★★★) - 8-10 minutes

## Quick Reference

**Volume Types:**

```yaml
# emptyDir - temporary storage
volumes:
- name: cache
  emptyDir: {}

# hostPath - mount from node
volumes:
- name: host-volume
  hostPath:
    path: /data
    type: Directory

# PVC - persistent storage
volumes:
- name: my-volume
  persistentVolumeClaim:
    claimName: my-pvc
```

**PersistentVolumeClaim:**

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: standard  # optional
```

**Pod with PVC:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pvc-pod
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: data
      mountPath: /usr/share/nginx/html
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: my-pvc
```

## Volume Types

| Type | Lifecycle | Use Case |
|------|-----------|----------|
| emptyDir | Pod lifetime | Temporary, scratch space, cache |
| hostPath | Node lifetime | Access node files (logs, sockets) |
| PVC/PV | Persistent | Database, user data, permanent storage |
| configMap | ConfigMap lifetime | Configuration files |
| secret | Secret lifetime | Credentials, certificates |

## Access Modes

- **ReadWriteOnce (RWO):** Mount by single node
- **ReadOnlyMany (ROX):** Mount read-only by many nodes
- **ReadWriteMany (RWX):** Mount read-write by many nodes
- **ReadWriteOncePod (RWOP):** Mount by single pod (v1.27+)

## Common Exam Scenarios

1. **Create pod with emptyDir**
   - Define volume in `spec.volumes`
   - Mount in containers

2. **Create and use PVC**
   - Create PVC with storage request
   - Reference in pod's `volumes` section

3. **Mount ConfigMap/Secret as volume**
   - Already covered in ConfigMap/Secret exercises

4. **Debug volume mount issues**
   - Check PVC status (Bound?)
   - Check pod events for mount errors

## Tips for CKAD Exam

✅ **DO:**

- Use emptyDir for temporary data sharing
- Use PVC for persistent storage (not hostPath)
- Check `kubectl get pvc` to verify binding
- Remember volume name must match in volumes and volumeMounts
- Use `storageClassName` if specific storage needed
- Verify mount with `kubectl exec -- df -h`

❌ **DON'T:**

- Don't use hostPath in production (not portable)
- Don't forget PVC must be Bound before pod starts
- Don't confuse volume name with PVC name
- Don't forget access mode matching for PV/PVC
- Don't forget namespace (PVC and Pod must be same namespace)

**Useful commands:** `kubectl get pv`, `kubectl get pvc`, `kubectl describe pvc`, `kubectl exec -- df -h`
