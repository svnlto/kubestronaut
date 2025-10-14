# Exercise 1: Basic Container Logging (★☆☆)

Time: 5-8 minutes

## Task

Learn how to view and understand container logs in Kubernetes, including single and multi-container Pods,
and understand basic logging architecture.

Requirements:

- View logs from a single-container Pod using kubectl logs
- Work with multi-container Pods and specify which container to view logs from
- Understand how container stdout and stderr streams work
- Learn basic log streaming and filtering options
- Understand the concept of log aggregation in cloud native systems

## Hint

Container logs in Kubernetes capture stdout and stderr streams from your applications. The `kubectl logs` command
retrieves these logs from the container runtime. For multi-container Pods, you must specify which container's logs
you want to view using the `-c` flag.

Logs are ephemeral by default - they're stored on the node and lost when containers are deleted.
Production systems use centralized logging solutions (like Fluentd, ELK stack, or Loki) to aggregate and persist
logs.

## Verification

Check that:

- You can view logs from a single-container Pod
- You can specify and view logs from a specific container in a multi-container Pod
- You understand the difference between `kubectl logs` and `kubectl logs -f` (follow mode)
- You can view previous container logs using `--previous` flag
- You understand why centralized logging is important for cloud native applications

**Useful commands:** `kubectl logs <pod-name>`, `kubectl logs <pod-name> -c <container-name>`,
`kubectl logs -f <pod-name>`, `kubectl logs --previous <pod-name>`

## Deep Dive Questions

- Where are container logs physically stored on a Kubernetes node?
- What happens to logs when a container restarts?
- Why is stdout/stderr the recommended logging approach for containerized applications?
- What are common log aggregation solutions in the CNCF landscape?
- How does logging relate to observability in cloud native systems?

## Solution Example

1. **Create a single-container Pod that generates logs:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: logger-simple
spec:
  containers:
  - name: logger
    image: busybox:1.36
    command: ["/bin/sh", "-c"]
    args:
    - |
      echo "Application starting..."
      counter=1
      while true; do
        echo "$(date) - Log entry $counter"
        counter=$((counter + 1))
        sleep 3
      done
```

1. **View logs:**

```bash
# View current logs
kubectl logs logger-simple

# Follow logs in real-time
kubectl logs -f logger-simple

# View last 10 lines
kubectl logs logger-simple --tail=10

# View logs with timestamps
kubectl logs logger-simple --timestamps
```

1. **Create a multi-container Pod:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: logger-multi
spec:
  containers:
  - name: app
    image: busybox:1.36
    command: ["/bin/sh", "-c"]
    args:
    - |
      while true; do
        echo "[APP] Processing request at $(date)"
        sleep 4
      done
  - name: sidecar
    image: busybox:1.36
    command: ["/bin/sh", "-c"]
    args:
    - |
      while true; do
        echo "[SIDECAR] Health check at $(date)"
        sleep 5
      done
```

1. **View logs from specific containers:**

```bash
# Must specify container name for multi-container Pods
kubectl logs logger-multi -c app
kubectl logs logger-multi -c sidecar

# Follow both containers (in separate terminals)
kubectl logs -f logger-multi -c app
kubectl logs -f logger-multi -c sidecar

# View all container logs (requires recent kubectl version)
kubectl logs logger-multi --all-containers=true
```

1. **Simulate container restart and view previous logs:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: crasher
spec:
  restartPolicy: Always
  containers:
  - name: app
    image: busybox:1.36
    command: ["/bin/sh", "-c"]
    args:
    - |
      echo "Starting application..."
      echo "Processing some work..."
      sleep 10
      echo "Error occurred! Crashing..."
      exit 1
```

```bash
# Wait for crash and restart
kubectl get pods -w

# View current container logs
kubectl logs crasher

# View previous (crashed) container logs
kubectl logs crasher --previous
```

## Key Concepts for KCNA

### Container Logging Architecture

- **stdout/stderr**: Standard output streams captured by container runtime
- **Container runtime**: Captures logs and stores them on the node (typically in `/var/log/containers/`)
- **kubectl logs**: Retrieves logs through the Kubernetes API from the container runtime
- **Ephemeral nature**: Logs are lost when Pods are deleted or nodes fail

### Log Aggregation

- **Problem**: Logs on individual nodes are not persistent or searchable at scale
- **Solution**: Centralized logging systems aggregate logs from all containers
- **CNCF Projects**: Fluentd, Fluent Bit, Loki
- **Common Stacks**: ELK (Elasticsearch, Logstash, Kibana), EFK (Elasticsearch, Fluentd, Kibana)

### Best Practices

- Applications should log to stdout/stderr (not files)
- Use structured logging (JSON) for easier parsing
- Include correlation IDs for distributed tracing
- Implement log levels (INFO, WARN, ERROR)
- Avoid logging sensitive information

### Observability Context

Logging is one of the three pillars of observability:

- **Logs**: Discrete events (what happened)
- **Metrics**: Numeric measurements (how much/how many)
- **Traces**: Request flow through distributed systems (where/when)

## Cleanup

```bash
kubectl delete pod logger-simple logger-multi crasher
```

## Additional Resources

- Kubernetes Logging Architecture: <https://kubernetes.io/docs/concepts/cluster-administration/logging/>
- CNCF Observability Landscape: <https://landscape.cncf.io/>
- The Twelve-Factor App - Logs: <https://12factor.net/logs>
