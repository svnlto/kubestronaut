# Exercise 1: Basic CronJob (★☆☆)

Time: 3-5 minutes

## Task

Create a CronJob that:

- Name: `hello-cron`
- Schedule: Every 2 minutes
- Container: `busybox:1.35`
- Command: Print "Hello from CronJob at $(date)"
- restartPolicy: OnFailure

Verify it creates Jobs and check the logs.

## Verification

Check that:

- CronJob exists with correct schedule (every 2 minutes)
- Jobs are being created every 2 minutes
- Pods complete successfully
- Logs show "Hello from CronJob at [timestamp]"

**Useful commands:** `kubectl get cronjob`, `kubectl get jobs --watch`, `kubectl logs`
