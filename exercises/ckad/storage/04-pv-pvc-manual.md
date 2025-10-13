# Exercise 4: Manual PV and PVC (★★★)

Time: 8-10 minutes

## Task

1. Create a PersistentVolume named `manual-pv` with:
   - Capacity: 2Gi
   - Access mode: ReadWriteOnce
   - HostPath: /mnt/data
   - Reclaim policy: Retain
2. Create a PVC named `manual-pvc` that claims this PV
3. Create a pod using the PVC

## Hint

Manually create PV first, then PVC. PVC binds to PV based on capacity and access mode matching.
In exam, dynamic provisioning is more common.

## Verification

Check that:

- PV created: `kubectl get pv manual-pv`
- PV shows Available: `kubectl get pv manual-pv -o jsonpath='{.status.phase}'`
- PVC created and bound: `kubectl get pvc manual-pvc`
- PV now shows Bound to PVC: `kubectl get pv`
- Pod uses PVC: `kubectl describe pod <pod> | grep ClaimName`

**Useful commands:** `kubectl get pv`, `kubectl get pvc`, `kubectl describe pv`, `kubectl describe pvc`
