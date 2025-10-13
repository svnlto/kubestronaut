# Job Exercises for CKAD

Jobs create one or more pods and ensure that a specified number complete successfully. They're used for batch
processing, one-time tasks, and parallel workloads. Understanding Job configurations is essential for CKAD.

## Exercises

1. [Basic Job](01-basic-job.md) (★☆☆) - 3-4 minutes
2. [Job with Multiple Completions](02-job-with-completions.md) (★★☆) - 5-6 minutes
3. [Parallel Job](03-parallel-job.md) (★★☆) - 5-7 minutes
4. [Job with Backoff Limit](04-job-with-backoff.md) (★★★) - 6-8 minutes
5. [Job with TTL After Finished](05-job-ttl.md) (★★★) - 6-8 minutes

## Quick Reference

**Essential Commands:**

```bash
# Create job
kubectl create job hello --image=busybox -- echo "Hello World"

# Create job from cronjob
kubectl create job test-job --from=cronjob/my-cronjob

# Get jobs
kubectl get jobs
kubectl get job hello
kubectl describe job hello

# Get pods from job
kubectl get pods -l job-name=hello

# View job logs
kubectl logs job/hello
kubectl logs -l job-name=hello --all-containers=true

# Delete job
kubectl delete job hello

# Delete job and its pods
kubectl delete job hello --cascade=foreground
```

**Job YAML Structure:**

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: pi-job
spec:
  # Number of successful completions required
  completions: 3

  # Number of pods running in parallel
  parallelism: 2

  # Number of retries before marking as failed
  backoffLimit: 4

  # Auto-cleanup after completion (seconds)
  ttlSecondsAfterFinished: 100

  # Maximum time job can run (seconds)
  activeDeadlineSeconds: 600

  template:
    spec:
      containers:
      - name: pi
        image: perl:5.34
        command: ["perl", "-Mbignum=bpi", "-wle", "print bpi(2000)"]
      restartPolicy: Never  # or OnFailure
```

## Key Job Concepts

### Completions

- **Default:** 1
- **Purpose:** Number of successful pod completions needed
- **Example:** `completions: 5` means 5 pods must succeed
- **Use case:** Batch processing multiple items

### Parallelism

- **Default:** 1
- **Purpose:** Number of pods running concurrently
- **Example:** `parallelism: 2` means max 2 pods run at once
- **Use case:** Speed up batch processing

### Backoff Limit

- **Default:** 6
- **Purpose:** Number of retries before marking job as failed
- **Example:** `backoffLimit: 3` means retry 3 times
- **Note:** With restartPolicy Never, each retry is a new pod

### Restart Policy

- **Never:** Create new pod on failure (recommended for jobs)
- **OnFailure:** Restart container in same pod on failure
- **Always:** NOT allowed for Jobs
- **Critical:** Must be Never or OnFailure (not Always)

## Job Patterns

### Single Job (Run Once)

```yaml
spec:
  completions: 1
  parallelism: 1
```

- Runs one pod to completion
- Most common pattern

### Parallel Job (Fixed Completions)

```yaml
spec:
  completions: 10
  parallelism: 3
```

- Creates 10 successful completions
- Max 3 pods run concurrently
- Use for: Processing fixed number of items

### Work Queue Job

```yaml
spec:
  parallelism: 5
  # No completions specified
```

- Pods coordinate using external work queue
- Job completes when all pods succeed
- Use for: Dynamic work distribution

### Cron-like Job

Use CronJob instead (see cronjobs directory)

## Common Exam Scenarios

1. **Create basic job**
   - Use `kubectl create job <name> --image=<image> -- <command>`
   - Fastest for simple jobs

2. **Create job with completions**
   - Generate YAML and add `spec.completions`
   - Set to number of required successful runs

3. **Create parallel job**
   - Set both `completions` and `parallelism`
   - Parallelism controls concurrency

4. **Handle failing jobs**
   - Set `backoffLimit` to control retries
   - Use `Never` restart policy for new pods each retry

5. **Auto-cleanup completed jobs**
   - Set `ttlSecondsAfterFinished`
   - Prevents job accumulation

6. **Time-limited jobs**
   - Set `activeDeadlineSeconds`
   - Job terminates after time limit

## Tips for CKAD Exam

✅ **DO:**

- Use `kubectl create job` for quick creation
- Remember: restartPolicy must be Never or OnFailure (not Always)
- Use `kubectl logs job/<name>` to view logs directly
- Use `ttlSecondsAfterFinished` for auto-cleanup
- Check job status with `kubectl get job`
- View failed pods: `kubectl get pods -l job-name=<name>`
- Use `parallelism` to speed up batch jobs
- Set `backoffLimit` to control retry behavior

❌ **DON'T:**

- Don't use restartPolicy: Always (Jobs don't support it)
- Don't forget to set completions for multi-run jobs
- Don't confuse completions (total successes) with parallelism (concurrency)
- Don't forget jobs leave pods after completion (use TTL for cleanup)
- Don't use Jobs for long-running services (use Deployments)
- Don't forget backoffLimit default is 6 retries
- Don't manually delete pods created by jobs (they'll be recreated)

## RestartPolicy Comparison

| Policy | Behavior | New Pod on Failure? | Use Case |
|--------|----------|---------------------|----------|
| Never | Don't restart failed container | Yes (new pod) | Jobs requiring fresh state |
| OnFailure | Restart failed container in same pod | No | Jobs that can retry in place |
| Always | Always restart (NOT ALLOWED in Jobs) | N/A | Deployments only |

## Job Status States

| State | Meaning |
|-------|---------|
| Active | Pods currently running |
| Succeeded | Pods completed successfully |
| Failed | Pods failed and backoffLimit reached |

## Troubleshooting Jobs

| Issue | Possible Causes | How to Debug |
|-------|-----------------|--------------|
| Job not starting | Image error, resource limits | `kubectl describe job`, check events |
| Job keeps retrying | Command fails, wrong image | `kubectl logs job/<name>`, check pod logs |
| Job won't complete | Wrong completions, pods failing | `kubectl get pods -l job-name=<name>` |
| Too many pods created | High backoffLimit, failing command | Check backoffLimit, review logs |
| Job stuck | activeDeadlineSeconds exceeded | `kubectl describe job` |

## Quick Debugging Workflow

```bash
# 1. Check job status
kubectl get job <name>

# 2. Check job details
kubectl describe job <name>

# 3. List job pods
kubectl get pods -l job-name=<name>

# 4. Check logs
kubectl logs -l job-name=<name>

# 5. Check failed pods
kubectl get pods -l job-name=<name> --field-selector=status.phase=Failed

# 6. Describe failed pod
kubectl describe pod <pod-name>
```

## Advanced Features

### Active Deadline Seconds

```yaml
spec:
  activeDeadlineSeconds: 600  # Job terminates after 10 minutes
```

- Job fails if running longer than specified
- Applies to all pods in the job

### Suspend Job

```yaml
spec:
  suspend: true  # Suspends job execution
```

- Prevents new pods from being created
- Existing pods continue running
- Can be toggled: `kubectl patch job <name> -p '{"spec":{"suspend":true}}'`

### Pod Failure Policy (v1.25+)

```yaml
spec:
  podFailurePolicy:
    rules:
    - action: FailJob
      onExitCodes:
        operator: In
        values: [42]
```

- Customize job behavior on pod failures
- Different actions for different exit codes

## Job vs CronJob

| Feature | Job | CronJob |
|---------|-----|---------|
| **Scheduling** | Run once | Scheduled (cron syntax) |
| **Use case** | One-time task | Recurring task |
| **Creation** | Manual or triggered | Automatic (time-based) |
| **Example** | Database migration | Backup every night |

## Time-Saving Tips

```bash
# Quick job creation
k create job test --image=busybox -- echo hello

# Generate YAML
k create job test --image=busybox --dry-run=client -o yaml -- echo hello > job.yaml

# View logs quickly
k logs job/test

# Check completion status
k get job test -w

# Delete job and all pods
k delete job test

# Create job from cronjob (test cronjob)
k create job test --from=cronjob/backup-cron
```

## Common Command Examples

```bash
# Calculate pi
kubectl create job pi --image=perl:5.34 -- perl -Mbignum=bpi -wle 'print bpi(2000)'

# Sleep job
kubectl create job sleeper --image=busybox -- sleep 30

# Echo job
kubectl create job hello --image=busybox -- echo "Hello Kubernetes"

# Date job
kubectl create job date --image=busybox -- date
```
