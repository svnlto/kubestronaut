# Exercise 5: Job with TTL After Finished (★★★)

Time: 6-8 minutes

## Task

Create a Job named `cleanup-job` that:

- Uses image `busybox:1.35`
- Runs command: `echo "Job completed, will be cleaned up"`
- Has ttlSecondsAfterFinished: 30 (auto-deletes 30 seconds after completion)
- Verify the job deletes itself automatically after 30 seconds

## Hint

Add `spec.ttlSecondsAfterFinished: 30` to automatically clean up completed jobs.
This helps prevent accumulation of completed job objects.

## Verification

Check that:

- Job created: `kubectl get job cleanup-job`
- TTL configured: `kubectl get job cleanup-job -o jsonpath='{.spec.ttlSecondsAfterFinished}'`
- Job completes: `kubectl get job cleanup-job`
- Wait 30+ seconds and verify job is deleted: `kubectl get job cleanup-job` (should show not found)
- Pods also cleaned up: `kubectl get pods -l job-name=cleanup-job`

**Useful commands:** `kubectl get job -w`, `kubectl describe job`, `watch kubectl get job`
