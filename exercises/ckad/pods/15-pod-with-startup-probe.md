# Exercise 15: Pod with Startup, Liveness, and Readiness Probes (★★★)

Time: 8-10 minutes

## Task

Create a pod with all three types of health probes for an application with slow startup:

- Create a pod named `slow-startup-app` using the `nginx:alpine` image
- Configure a **startup probe** that:
  - Uses HTTP GET on path `/` and port `80`
  - Checks every `3` seconds (periodSeconds)
  - Allows up to `10` failures (failureThreshold) - giving 30 seconds total for startup
  - No initial delay needed
- Configure a **liveness probe** that:
  - Uses HTTP GET on path `/` and port `80`
  - Starts checking after `5` seconds (initialDelaySeconds)
  - Checks every `10` seconds (periodSeconds)
  - Allows `3` failures before restart
- Configure a **readiness probe** that:
  - Uses HTTP GET on path `/` and port `80`
  - Starts checking after `5` seconds (initialDelaySeconds)
  - Checks every `5` seconds (periodSeconds)
  - Allows `2` failures before marking unready
- Add labels: `app=web`, `probe-demo=true`

## Hint

Startup probes disable liveness and readiness checks until the app is started, preventing premature restarts for
slow-starting applications. Once startup probe succeeds, liveness and readiness probes take over.
All three probes can coexist.

## Verification

Check that:

- Pod is running with all three probes configured
- Startup probe completes successfully
- Liveness and readiness probes are functioning
- Pod shows READY status

**Useful commands:** `kubectl describe pod slow-startup-app | grep -A 5 "Startup:"`,
`kubectl describe pod slow-startup-app | grep -A 5 "Liveness:"`,
`kubectl describe pod slow-startup-app | grep -A 5 "Readiness:"`, `kubectl get pod slow-startup-app -w`
