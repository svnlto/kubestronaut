# Exercise 2: Backup CronJob (★★☆)

Time: 5-7 minutes

## Task

Create a CronJob that simulates a database backup:

- Name: `db-backup`
- Schedule: Every day at 2:30 AM
- Container: `busybox:1.35`
- Command: Create a backup file in `/backup` directory with timestamp
- Mount an emptyDir volume at `/backup`
- restartPolicy: OnFailure
- successfulJobsHistoryLimit: 3
- failedJobsHistoryLimit: 1

Test by manually triggering a job from the CronJob.

## Verification

Check that:

- Schedule is `30 2 * * *` (2:30 AM daily)
- `successfulJobsHistoryLimit: 3` and `failedJobsHistoryLimit: 1` are set
- Volume is mounted at `/backup`
- Manual test job creates backup file with timestamp

**Useful commands:** `kubectl describe cronjob`, `kubectl create job --from=cronjob`, `kubectl logs`
