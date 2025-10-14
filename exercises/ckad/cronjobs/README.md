# CronJob Exercises for CKAD

These exercises focus on Kubernetes CronJobs - a critical topic for the CKAD exam.

## Exercises

1. [Basic CronJob](01-basic-cronjob.md) (★☆☆) - 3-5 minutes
2. [Backup CronJob](02-backup-cronjob.md) (★★☆) - 5-7 minutes
3. [Concurrency Control](03-concurrency-control.md) (★★☆) - 5-7 minutes
4. [Suspend and Resume](04-suspend-resume.md) (★☆☆) - 3-5 minutes
5. [Multi-Container CronJob](05-multi-container.md) (★★★) - 8-10 minutes
6. [Timezone Configuration](06-timezone.md) (★★☆) - 5 minutes

## Quick Reference

**CronJob Schedule Format:**

```text
* * * * *
│ │ │ │ │
│ │ │ │ └─── Day of week (0-6, Sun-Sat)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)
```

**Common Patterns:**

- `*/5 * * * *` - Every 5 minutes
- `0 * * * *` - Every hour (at minute 0)
- `0 0 * * *` - Every day at midnight
- `0 0 * * 0` - Every Sunday at midnight
- `30 2 * * 1-5` - 2:30 AM, Monday through Friday

**Essential Commands:**

```bash
# Create CronJob
kubectl create cronjob NAME --image=IMAGE --schedule="CRON" -- COMMAND

# List CronJobs
kubectl get cronjob

# Manually trigger a job from CronJob
kubectl create job JOB-NAME --from=cronjob/CRONJOB-NAME

# Suspend/Resume
kubectl patch cronjob NAME -p '{"spec":{"suspend":true}}'
kubectl patch cronjob NAME -p '{"spec":{"suspend":false}}'

# Delete CronJob
kubectl delete cronjob NAME
```

## Common Exam Scenarios

1. **Create CronJob with specific schedule** - Practice cron syntax!
2. **Suspend/Resume CronJob** - Use patch command
3. **Manually trigger job from CronJob** - `kubectl create job --from=cronjob`
4. **Set history limits** - `successfulJobsHistoryLimit`, `failedJobsHistoryLimit`
5. **Handle concurrency** - `concurrencyPolicy: Forbid/Allow/Replace`
6. **Debug failed CronJobs** - Check job logs, describe cronjob for events

## Tips for CKAD Exam

✅ **DO:**

- Use `kubectl create cronjob` for quick creation, then edit if needed
- Remember `restartPolicy` must be `OnFailure` or `Never` (not `Always`)
- Use `--from=cronjob` to test without waiting for schedule
- Check `kubectl describe cronjob` for last schedule time and events

❌ **DON'T:**

- Forget that CronJob creates Job, which creates Pod (3 levels!)
- Mix up Job and CronJob fields (schedule is CronJob-only)
- Use wrong cron syntax (use crontab.guru online if unsure)
- Forget to set `restartPolicy` in the Pod template

## Additional Practice

Try creating CronJobs for these scenarios:

1. Certificate expiry checker (runs daily)
2. Log rotation (runs weekly on Sunday)
3. Health check reporter (runs every 15 minutes)
4. Database vacuum (runs at 3 AM on first day of month)
5. Backup verification (runs at 4 AM Mon-Fri)

## Concurrency Policies Reference

- `Allow` (default): Multiple jobs can run concurrently
- `Forbid`: Skip new job if previous is still running
- `Replace`: Cancel old job and start new one
