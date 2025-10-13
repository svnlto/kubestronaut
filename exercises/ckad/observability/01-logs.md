# Exercise 1: View and Filter Logs (★☆☆)

Time: 3-4 minutes

## Task

1. Create a pod named `logger` with image `busybox:1.35`
2. Command: `sh -c "for i in $(seq 1 100); do echo Log line $i; sleep 1; done"`
3. View logs in various ways: all logs, last 10 lines, follow logs, since time

## Hint

Use `kubectl logs` with flags: `--tail`, `--follow`, `--since`, `--timestamps`

## Verification

Check that:

- Pod running: `kubectl get pod logger`
- View all logs: `kubectl logs logger`
- Last 10 lines: `kubectl logs logger --tail=10`
- Follow logs: `kubectl logs logger --follow` (Ctrl+C to exit)
- With timestamps: `kubectl logs logger --timestamps`
- Since 30s ago: `kubectl logs logger --since=30s`

**Useful commands:** `kubectl logs`, `kubectl logs --tail`, `kubectl logs --follow`, `kubectl logs --since`
