# Exercise 4: CronJob Suspend and Resume (★☆☆)

Time: 3-5 minutes

## Task

1. Create a CronJob named `minute-tick` that runs every minute and prints the current date
2. Suspend the CronJob
3. Verify no new jobs are created
4. Resume the CronJob
5. Delete the CronJob and all its jobs

## Verification

Check that:

- Initially: Jobs are created every minute
- After suspend: `SUSPEND` column shows `True`, no new jobs created
- After resume: `SUSPEND` shows `False`, jobs start creating again
- After delete: CronJob and all associated jobs are gone

**Useful commands:** `kubectl get cronjob`, `kubectl get jobs --watch`, `kubectl patch`
