# Exercise 6: Adapter Container Pattern (★★★)

Time: 8-10 minutes

## Task

Create a pod that:

- Is named `adapter-pod`
- Has a main container named `app` using image `busybox:1.35`
  - Command:
    `sh -c "while true; do echo 'metric=value timestamp='$(date +%s) >> /var/log/metrics.log; sleep 5; done"`
  - Mounts volume `logs` at `/var/log`
- Has an adapter container named `formatter` using image `busybox:1.35`
  - Command: Tail metrics log and transform timestamps
    (`sed 's/timestamp=/time:/g'` on `/var/log/metrics.log`)
  - Mounts volume `logs` at `/var/log`
- Uses an emptyDir volume named `logs`
- Has label `pattern=adapter`

## Hint

The adapter pattern transforms data from the main container into a different format.
Both containers share a volume, and the adapter reads and transforms the data.

## Verification

Check that:

- Pod is running: `kubectl get pod adapter-pod`
- Both containers are running: `kubectl get pod adapter-pod -o jsonpath='{.status.containerStatuses[*].ready}'`
- App generates logs: `kubectl logs adapter-pod -c app`
- Adapter transforms output: `kubectl logs adapter-pod -c formatter`
- Volume is shared: `kubectl exec adapter-pod -c formatter -- ls -la /var/log`

**Useful commands:** `kubectl logs`, `kubectl exec`, `kubectl get pod`
