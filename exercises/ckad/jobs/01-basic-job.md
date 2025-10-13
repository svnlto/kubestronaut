# Exercise 1: Basic Job (★☆☆)

Time: 3-4 minutes

## Task

1. Create a Job named `hello-job` that:
   - Uses image `busybox:1.35`
   - Runs command: `echo "Hello from Job"`
   - Completes successfully once
2. Verify the job completed successfully
3. View the job output logs

## Hint

Use `kubectl create job` command. Jobs run to completion and don't restart by default.
The restartPolicy for jobs must be `Never` or `OnFailure`.

## Verification

Check that:

- Job is created: `kubectl get job hello-job`
- Job completed (1/1): `kubectl get job hello-job`
- Pod ran to completion: `kubectl get pods -l job-name=hello-job`
- Check logs: `kubectl logs job/hello-job`
- Job status: `kubectl describe job hello-job`

**Useful commands:** `kubectl create job`, `kubectl get job`, `kubectl logs job/<name>`
