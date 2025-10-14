# Exercise 13: Pod with Persistent Volume Claim (★★☆)

Time: 6-8 minutes

## Task

Create a pod that uses persistent storage:

- Create a PersistentVolumeClaim named `task-pvc` with:
  - Access mode: `ReadWriteOnce`
  - Storage request: `100Mi`
  - Storage class: use default (don't specify storageClassName)
- Create a pod named `data-pod` using `busybox:1.36` image that:
  - Mounts the PVC at path `/data`
  - Runs command:
    `sh -c "echo 'Hello from persistent storage!' > /data/message.txt && sleep 3600"`
  - Has label `app=storage-demo`

## Hint

Use `kubectl explain pvc.spec` to see PVC fields. The PVC must be created before the pod
and must be in the same namespace. Once bound, the PVC can be mounted by any pod in the
namespace.

## Verification

Check that:

- PVC is created and bound: `kubectl get pvc task-pvc`
- Pod is running: `kubectl get pod data-pod`
- File was written: `kubectl exec data-pod -- cat /data/message.txt`

**Test persistence (optional):**
To verify data persists across pod deletions:

1. Delete the pod: `kubectl delete pod data-pod`
2. Create new pod `data-pod-2` using the same PVC
3. Read the file: `kubectl exec data-pod-2 -- cat /data/message.txt`

**Useful commands:** `kubectl get pvc`, `kubectl describe pvc task-pvc`, `kubectl exec`
