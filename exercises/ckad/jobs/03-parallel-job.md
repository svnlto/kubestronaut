# Exercise 3: Parallel Job (★★☆)

Time: 5-7 minutes

## Task

Create a Job named `parallel-job` that:

- Uses image `perl:5.34`
- Runs command: `perl -Mbignum=bpi -wle 'print bpi(2000)'` (calculates pi)
- Completes 6 times total
- Runs 2 pods in parallel at any time

## Hint

Set `spec.completions: 6` and `spec.parallelism: 2`. This creates 6 successful completions but only 2 pods run concurrently.

## Verification

Check that:

- Job created: `kubectl get job parallel-job`
- Completions: 6, Parallelism: 2
- Eventually shows 6/6: `kubectl get job parallel-job`
- Multiple pods ran: `kubectl get pods -l job-name=parallel-job`
- All completed successfully: `kubectl get pods -l job-name=parallel-job --field-selector=status.phase=Succeeded`

**Useful commands:** `kubectl get job -w`, `kubectl get pods -l job-name=<name>`, `kubectl describe job`
