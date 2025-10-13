# Exercise 6: CronJob Time Zones (★★☆)

Time: 5 minutes

## Task

Create a CronJob that:

- Name: `timezone-test`
- Schedule: Every day at 9:00 AM
- Container: `busybox:1.35`
- Command: Print current time
- Set timezone to America/New_York using environment variable `TZ`

**Note:** If your K8s version is 1.25+, try using the `timeZone` field in the CronJob spec.

## Verification

Check that:

- Schedule is `0 9 * * *` (9:00 AM daily)
- Environment variable `TZ=America/New_York` is set
- Manual job shows time in New York timezone
- (Optional) `timeZone: America/New_York` field is set if using K8s 1.25+

**Useful commands:** `kubectl get cronjob -o yaml`, `kubectl create job --from=cronjob`, `kubectl logs`
