# Exercise 4: Job with Backoff Limit (★★★)

Time: 6-8 minutes

## Task

1. Create a Job named `failing-job` that:
   - Uses image `busybox:1.35`
   - Runs command that fails: `sh -c "exit 1"`
   - Has backoffLimit of 3 (retries 3 times before giving up)
   - Has restartPolicy: Never
2. Watch it fail and retry
3. Verify it stops after 3 failures

## Hint

Set `spec.backoffLimit: 3` and `spec.template.spec.restartPolicy: Never`. The job will retry 3 times then mark as
failed. With restartPolicy Never, each retry creates a new pod.

## Verification

Check that:

- Job created: `kubectl get job failing-job`
- Backoff limit is 3: `kubectl get job failing-job -o jsonpath='{.spec.backoffLimit}'`
- Job shows 0/1 completions and eventually fails
- 4 pods created total (initial + 3 retries): `kubectl get pods -l job-name=failing-job`
- Job status shows failure: `kubectl describe job failing-job | grep -i failed`

**Useful commands:** `kubectl get job -w`, `kubectl get pods -l job-name=<name>`, `kubectl describe job`
