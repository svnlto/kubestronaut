# Exercise 2: Multi-Container Logs (★★☆)

Time: 4-5 minutes

## Task

1. Create a pod named `multi-logger` with two containers:
   - Container `app`: busybox, command: `sh -c "while true; do echo APP: $(date); sleep 3; done"`
   - Container `sidecar`: busybox, command: `sh -c "while true; do echo SIDECAR: $(date); sleep 5; done"`
2. View logs from each container separately and combined

## Hint

Use `-c` flag to specify container. Use `--all-containers` to view all logs.

## Verification

Check that:

- Pod running: `kubectl get pod multi-logger`
- App logs: `kubectl logs multi-logger -c app`
- Sidecar logs: `kubectl logs multi-logger -c sidecar`
- All logs: `kubectl logs multi-logger --all-containers=true`
- Previous logs (after restart): `kubectl logs multi-logger -c app --previous`

**Useful commands:** `kubectl logs -c`, `kubectl logs --all-containers`, `kubectl logs --previous`
