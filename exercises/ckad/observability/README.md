# Observability Exercises for CKAD

Observability in Kubernetes involves monitoring, logging, and debugging applications. Understanding how to access logs,
debug failing pods, and use monitoring tools is essential for CKAD.

## Exercises

1. [View and Filter Logs](01-logs.md) (★☆☆) - 3-4 minutes
2. [Multi-Container Logs](02-multi-container-logs.md) (★★☆) - 4-5 minutes
3. [Debug Failing Pod](03-debugging-pod.md) (★★★) - 7-9 minutes

## Quick Reference

**Logging Commands:**

```bash
# Basic logs
kubectl logs <pod>
kubectl logs <pod> -c <container>    # Specific container
kubectl logs <pod> --all-containers  # All containers

# Filtering
kubectl logs <pod> --tail=20         # Last 20 lines
kubectl logs <pod> --since=1h        # Last hour
kubectl logs <pod> --since-time=2024-01-01T10:00:00Z
kubectl logs <pod> --timestamps      # With timestamps

# Following logs
kubectl logs <pod> -f                # Follow (stream)
kubectl logs <pod> --follow

# Previous container (after restart)
kubectl logs <pod> --previous
kubectl logs <pod> -c <container> --previous

# Multiple pods (labels)
kubectl logs -l app=web              # All pods with label
kubectl logs -l app=web --all-containers=true
```

**Debugging Commands:**

```bash
# Pod status and details
kubectl get pod <pod>
kubectl describe pod <pod>
kubectl get pod <pod> -o yaml

# Events
kubectl get events
kubectl get events --sort-by='.lastTimestamp'
kubectl get events --field-selector involvedObject.name=<pod>

# Execute commands in pod
kubectl exec <pod> -- ls /
kubectl exec -it <pod> -- sh

# Port forward for testing
kubectl port-forward <pod> 8080:80

# Resource usage (requires metrics-server)
kubectl top pod
kubectl top pod <pod>
kubectl top node
```

## Common Exam Scenarios

1. **View application logs**
   - Use `kubectl logs <pod>`
   - Filter with `--tail`, `--since`

2. **Debug multi-container pod**
   - Specify container with `-c`
   - Check all containers with `--all-containers`

3. **Find why pod is failing**
   - Use `kubectl describe pod`
   - Check events and status
   - View logs if container started

4. **Access previous container logs**
   - After crash: `kubectl logs --previous`

5. **Monitor resource usage**
   - Use `kubectl top pod`
   - Requires metrics-server

## Tips for CKAD Exam

✅ **DO:**

- Use `kubectl logs` as first debugging step
- Use `kubectl describe pod` for detailed status
- Check events with `kubectl get events`
- Use `-c` for multi-container pods
- Use `--previous` for crashed containers
- Filter logs with `--tail` and `--since`
- Use `kubectl exec` to inspect running containers

❌ **DON'T:**

- Don't forget `-c` for multi-container pods
- Don't forget `--previous` for restarted pods
- Don't overlook events in `kubectl describe`
- Don't forget to check both pod and container status

**Useful commands:** `kubectl logs`, `kubectl describe`, `kubectl exec`, `kubectl get events`, `kubectl top`
