# Exercise 3: CronJob with Concurrency Control (★★☆)

Time: 5-7 minutes

## Task

Create a CronJob that:

- Name: `report-generator`
- Schedule: Every 3 minutes
- Container: `busybox:1.35`
- Command: Sleep for 5 minutes (simulating long-running task)
- concurrencyPolicy: `Forbid` (don't allow overlapping jobs)
- startingDeadlineSeconds: 60
- successfulJobsHistoryLimit: 2

Test what happens when jobs would overlap.

## Hint

Watch `kubectl get jobs --watch` to see jobs being skipped.

## Verification

Check that:

- `concurrencyPolicy: Forbid` is set
- First job runs for ~5 minutes
- Second job at 3-minute mark is skipped (not created)
- Events show "FailedNeedsStart" or similar message about skipped job

**Useful commands:** `kubectl get jobs --watch`, `kubectl describe cronjob`
