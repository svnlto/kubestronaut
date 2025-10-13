# Exercise 5: Multi-Container CronJob (★★★)

Time: 8-10 minutes

## Task

Create a CronJob that:

- Name: `data-processor`
- Schedule: Every 5 minutes
- Two containers:
  1. `fetcher`: Downloads data (simulate with `busybox`, create file in shared volume)
  2. `processor`: Processes data (reads file from shared volume, transforms it)
- Shared emptyDir volume at `/data`
- Both containers should complete successfully
- restartPolicy: OnFailure

Manually trigger a job and verify both containers' logs.

## Verification

Check that:

- Pod has 2 containers (fetcher and processor)
- Both containers complete successfully
- Fetcher logs show data file creation
- Processor logs show data being read and processed
- Shared volume at `/data` is accessible to both

**Useful commands:** `kubectl create job --from=cronjob`, `kubectl logs <pod> -c <container>`
