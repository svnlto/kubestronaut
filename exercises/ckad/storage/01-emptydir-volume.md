# Exercise 1: EmptyDir Volume (★☆☆)

Time: 4-5 minutes

## Task

Create a pod named `emptydir-pod` with:

- Two containers: `writer` (busybox:1.35) and `reader` (busybox:1.35)
- Writer command: `sh -c "while true; do date >> /data/log.txt; sleep 5; done"`
- Reader command: `sh -c "while true; do cat /data/log.txt; sleep 10; done"`
- Both containers share an emptyDir volume mounted at `/data`

## Hint

EmptyDir volumes are created when pod is assigned to node and deleted when pod is removed.
Perfect for temporary data sharing between containers.

## Verification

Check that:

- Pod running: `kubectl get pod emptydir-pod`
- Both containers running: `kubectl get pod emptydir-pod -o jsonpath='{.status.containerStatuses[*].name}'`
- Writer logs: `kubectl logs emptydir-pod -c writer`
- Reader sees data: `kubectl logs emptydir-pod -c reader`
- Volume shared: `kubectl exec emptydir-pod -c reader -- ls /data`

**Useful commands:** `kubectl logs -c`, `kubectl exec`, `kubectl describe pod`
