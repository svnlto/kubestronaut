# Exercise 4: Sidecar Container Pattern (★★☆)

Time: 7-8 minutes

## Task

Create a pod that:

- Is named `sidecar-pod`
- Has a main container named `app` using image `busybox:1.35`
  - Command: `sh -c "while true; do echo $(date) >> /var/log/app.log; sleep 2; done"`
  - Mounts a volume named `logs` at `/var/log`
- Has a sidecar container named `log-shipper` using image `busybox:1.35`
  - Command: `sh -c "tail -f /var/log/app.log"`
  - Mounts the same `logs` volume at `/var/log`
- Uses an emptyDir volume named `logs`

## Hint

Both containers need to mount the same volume to share the log file. The emptyDir volume should be defined in
`spec.volumes` and referenced in each container's `volumeMounts`.

## Verification

Check that:

- Pod is running: `kubectl get pod sidecar-pod`
- Both containers are ready: `kubectl get pod sidecar-pod -o jsonpath='{.status.containerStatuses[*].name}'`
- App container logs: `kubectl logs sidecar-pod -c app`
- Sidecar sees the logs: `kubectl logs sidecar-pod -c log-shipper`

**Useful commands:** `kubectl logs`, `kubectl describe pod`, `kubectl get pod`
