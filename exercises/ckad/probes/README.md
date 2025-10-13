# Probe Exercises for CKAD

Probes are health checks that Kubernetes uses to monitor container health and readiness. Understanding liveness, readiness,
and startup probes is critical for building resilient applications and is heavily tested in CKAD.

## Exercises

1. [Liveness Probe](01-liveness-probe.md) (★☆☆) - 4-5 minutes
2. [Readiness Probe](02-readiness-probe.md) (★★☆) - 5-6 minutes
3. [Startup Probe](03-startup-probe.md) (★★☆) - 6-7 minutes
4. [Failing Liveness Probe](04-failing-liveness.md) (★★★) - 7-9 minutes
5. [Combined Probes](05-combined-probes.md) (★★★) - 8-10 minutes

## Quick Reference

**Probe Types:**

```yaml
livenessProbe:     # Is container alive? Restart if failed
readinessProbe:    # Is container ready for traffic? Remove from endpoints if failed
startupProbe:      # Has container finished starting? Disables other probes until success
```

**Probe Methods:**

```yaml
# HTTP GET request
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
    httpHeaders:
    - name: Custom-Header
      value: Value
  initialDelaySeconds: 3
  periodSeconds: 10
  timeoutSeconds: 1
  successThreshold: 1
  failureThreshold: 3

# TCP Socket
livenessProbe:
  tcpSocket:
    port: 8080
  initialDelaySeconds: 15
  periodSeconds: 20

# Exec command
livenessProbe:
  exec:
    command:
    - cat
    - /tmp/healthy
  initialDelaySeconds: 5
  periodSeconds: 5

# gRPC (v1.24+)
livenessProbe:
  grpc:
    port: 2379
  initialDelaySeconds: 10
```

**Common Configuration:**

```yaml
spec:
  containers:
  - name: app
    image: myapp:latest
    ports:
    - containerPort: 8080

    startupProbe:
      httpGet:
        path: /startup
        port: 8080
      initialDelaySeconds: 0
      periodSeconds: 10
      failureThreshold: 30    # 30 * 10 = 300s max startup time

    livenessProbe:
      httpGet:
        path: /healthz
        port: 8080
      initialDelaySeconds: 0  # Startup probe handles initial delay
      periodSeconds: 10
      timeoutSeconds: 1
      failureThreshold: 3     # Restart after 3 failures

    readinessProbe:
      httpGet:
        path: /ready
        port: 8080
      initialDelaySeconds: 0
      periodSeconds: 5
      timeoutSeconds: 1
      successThreshold: 1
      failureThreshold: 3
```

## Probe Types Explained

### Liveness Probe

**Purpose:** Detect when container is dead/hung and needs restart

**Action:** Restarts container on failure

**Use cases:**

- Deadlocked application
- Infinite loop
- Memory leak causing unresponsiveness

**Example scenarios:**

- Web server responding 500 errors
- Database connection pool exhausted
- Application crashed but process still running

**Best practice:** Conservative timeouts (don't restart healthy apps)

### Readiness Probe

**Purpose:** Detect when container is ready to accept traffic

**Action:** Removes pod from service endpoints on failure (doesn't restart)

**Use cases:**

- Application warming up
- Loading configuration/data
- Dependencies not ready
- Temporary overload

**Example scenarios:**

- Application starting (loading cache, connecting to DB)
- Temporary resource constraint
- External dependency unavailable

**Best practice:** More aggressive than liveness (okay to mark unready frequently)

### Startup Probe

**Purpose:** Handle slow-starting containers

**Action:** Disables liveness/readiness probes until success

**Use cases:**

- Legacy applications with long startup
- Applications with unpredictable startup time
- Cold start scenarios

**Example scenarios:**

- Java applications with long JVM startup
- Applications loading large datasets
- First-time initialization tasks

**Best practice:** Use high `failureThreshold * periodSeconds` for maximum startup time

## Probe Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `initialDelaySeconds` | 0 | Delay before first probe |
| `periodSeconds` | 10 | How often to probe |
| `timeoutSeconds` | 1 | Probe timeout |
| `successThreshold` | 1 | Min consecutive successes (readiness only) |
| `failureThreshold` | 3 | Min consecutive failures to mark failed |

**Calculation examples:**

```yaml
# Max startup time before failure
startupProbe:
  failureThreshold: 30
  periodSeconds: 10
  # Max time: 30 * 10 = 300 seconds (5 minutes)

# Time until restart after failure
livenessProbe:
  periodSeconds: 10
  failureThreshold: 3
  # Time: 10 * 3 = 30 seconds after first failure
```

## Common Exam Scenarios

1. **Add liveness probe to pod**
   - Use `httpGet`, `exec`, or `tcpSocket`
   - Set `initialDelaySeconds` and `periodSeconds`

2. **Add readiness probe to deployment**
   - Usually same endpoint as liveness
   - More frequent checks (smaller `periodSeconds`)

3. **Configure startup probe for slow app**
   - High `failureThreshold` * `periodSeconds`
   - Set `initialDelaySeconds: 0`

4. **Debug container restart loop**
   - Check liveness probe configuration
   - Probe may be too aggressive
   - Application may not be responding

5. **Fix pod not receiving traffic**
   - Check readiness probe
   - Verify probe endpoint returns success
   - Check service endpoints

## Tips for CKAD Exam

✅ **DO:**

- Use startup probes for slow-starting applications
- Set readiness probe more aggressive than liveness
- Use `httpGet` for HTTP services (easiest to implement)
- Use `exec` for non-HTTP services
- Remember probe delays: `initialDelaySeconds` + `periodSeconds * failureThreshold`
- Check `kubectl describe pod` for probe failures
- Use `kubectl get endpoints` to verify readiness impact
- Test probe endpoints separately before configuring

❌ **DON'T:**

- Don't make liveness probe too aggressive (causes restart loops)
- Don't forget `initialDelaySeconds` for slow-starting apps
- Don't use same thresholds for all probes (readiness can be more sensitive)
- Don't point probes at external dependencies (only check own health)
- Don't confuse liveness (restarts) with readiness (endpoints)
- Don't forget startup probe disables others until success
- Don't use liveness probe for temporary issues (use readiness)
- Don't set `timeoutSeconds` too low (network variability)

## Probe Decision Tree

```text
Is it a startup issue (slow/variable startup time)?
└─ YES → Use startupProbe
└─ NO → Continue

Should container be restarted if this fails?
└─ YES → Use livenessProbe (deadlock, hang, crash)
└─ NO → Continue

Should container stop receiving traffic if this fails?
└─ YES → Use readinessProbe (temporary issue, overload, dependency)
└─ NO → Probe not needed
```

## Troubleshooting Probes

| Issue | Possible Causes | How to Debug |
|-------|-----------------|--------------|
| Pod keeps restarting | Liveness probe failing | `kubectl describe pod`, check probe endpoint |
| Pod never becomes Ready | Readiness probe failing | `kubectl describe pod`, test endpoint |
| Pod removed from endpoints | Readiness probe failing | `kubectl get endpoints`, check service |
| Slow startup causing restarts | No startup probe | Add startup probe with high timeout |
| Restart loop | Liveness probe too aggressive | Increase `initialDelaySeconds` or `failureThreshold` |

## Quick Debugging Workflow

```bash
# 1. Check pod status
kubectl get pod <name>

# 2. Check probe configuration
kubectl describe pod <name> | grep -A 10 -E "Liveness|Readiness|Startup"

# 3. Check recent events
kubectl describe pod <name> | grep -A 20 Events

# 4. Test probe endpoint manually
kubectl exec <pod> -- curl http://localhost:8080/healthz

# 5. Check logs for errors
kubectl logs <pod>

# 6. Check service endpoints (readiness impact)
kubectl get endpoints <service>

# 7. Watch pod status changes
kubectl get pod <name> -w
```

## HTTP Probe Return Codes

| HTTP Code | Result |
|-----------|--------|
| 200-399 | Success |
| 400-599 | Failure |
| No response | Failure (after timeout) |

## Probe Best Practices

1. **Liveness Probe:**
   - Check only critical functionality
   - Don't check dependencies (use readiness)
   - Conservative thresholds (avoid false positives)
   - Endpoint should be fast (<1s)

2. **Readiness Probe:**
   - Can check dependencies
   - More frequent than liveness
   - Okay to fail temporarily
   - Endpoint can include warm-up check

3. **Startup Probe:**
   - Only for slow-starting apps
   - Set high `failureThreshold * periodSeconds`
   - Once succeeds, never runs again
   - Use same endpoint as liveness

4. **General:**
   - Keep probe endpoints lightweight
   - Don't restart databases in probe checks
   - Use separate endpoints for each probe type
   - Test probes in development

## Example Probe Endpoints

```go
// Liveness: Is the application alive?
http.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
    // Simple check - is process responding?
    w.WriteHeader(http.StatusOK)
    w.Write([]byte("ok"))
})

// Readiness: Can the application serve traffic?
http.HandleFunc("/ready", func(w http.ResponseWriter, r *http.Request) {
    // Check dependencies
    if !database.Ping() || !cache.Available() {
        w.WriteHeader(http.StatusServiceUnavailable)
        return
    }
    w.WriteHeader(http.StatusOK)
    w.Write([]byte("ready"))
})

// Startup: Has the application finished starting?
http.HandleFunc("/startup", func(w http.ResponseWriter, r *http.Request) {
    // Check if initialization complete
    if !app.InitializationComplete() {
        w.WriteHeader(http.StatusServiceUnavailable)
        return
    }
    w.WriteHeader(http.StatusOK)
    w.Write([]byte("started"))
})
```

## Time-Saving Tips

```bash
# Generate pod with probe quickly
k run nginx --image=nginx --dry-run=client -o yaml > pod.yaml
# Then edit to add probes

# Test probe endpoint
k exec <pod> -- wget -O- http://localhost:80/

# Check if readiness affecting service
k get endpoints <service>

# Watch pod for restart loops
k get pod <name> -w

# Check probe failure in events
k describe pod <name> | grep -i probe
```
