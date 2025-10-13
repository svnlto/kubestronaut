# Exercise 2: HostPath Volume (★★☆)

Time: 5-6 minutes

## Task

Create a pod named `hostpath-pod` that:

- Uses image `nginx:alpine`
- Mounts a hostPath volume from node's `/var/log` to pod's `/host-logs`
- Volume type: Directory

## Hint

HostPath volumes mount files/directories from the host node's filesystem. Use for accessing node logs or data.
NOT portable across nodes.

## Verification

Check that:

- Pod running: `kubectl get pod hostpath-pod`
- Volume mounted: `kubectl exec hostpath-pod -- ls /host-logs`
- Can see host logs: `kubectl exec hostpath-pod -- ls -la /host-logs`
- Describe shows hostPath: `kubectl describe pod hostpath-pod | grep -A 3 Volumes`

**Useful commands:** `kubectl exec`, `kubectl describe pod`
