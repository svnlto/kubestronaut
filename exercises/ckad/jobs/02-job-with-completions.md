# Exercise 2: Job with Multiple Completions (★★☆)

Time: 5-6 minutes

## Task

Create a Job named `multi-complete` that:

- Uses image `busybox:1.35`
- Runs command: `sh -c "echo Processing task $HOSTNAME; sleep 2"`
- Completes 5 times successfully (completions: 5)
- Runs one pod at a time (parallelism: 1)

## Hint

Use `kubectl create job --dry-run=client -o yaml` to generate YAML, then add `spec.completions` and
`spec.parallelism`. The job creates 5 pods sequentially.

## Verification

Check that:

- Job created: `kubectl get job multi-complete`
- Completions set to 5: `kubectl get job multi-complete -o jsonpath='{.spec.completions}'`
- Job shows 5/5 completions: `kubectl get job multi-complete`
- 5 pods completed: `kubectl get pods -l job-name=multi-complete`
- Check logs from all pods: `kubectl logs -l job-name=multi-complete`

**Useful commands:** `kubectl get job`, `kubectl get pods -l job-name=<name>`, `kubectl logs -l job-name=<name>`
