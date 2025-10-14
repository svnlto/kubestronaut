# Exercise 10: Pod with Liveness and Readiness Probes (★★☆)

Time: 6-8 minutes

## Task

Create a pod with health checks to ensure reliability:

- Create a pod named `healthy-app` using the `nginx:alpine` image
- Configure a **readiness probe** that:
  - Uses HTTP GET on path `/` and port `80`
  - Starts checking after `5` seconds (initialDelaySeconds)
  - Checks every `5` seconds (periodSeconds)
- Configure a **liveness probe** that:
  - Uses HTTP GET on path `/` and port `80`
  - Starts checking after `10` seconds (initialDelaySeconds)
  - Checks every `10` seconds (periodSeconds)
  - Allows `3` consecutive failures before restarting (failureThreshold)
- Add a label `app=healthy`

## Hint

Readiness probes determine when a pod is ready to receive traffic, while liveness probes determine when to restart
a container. Both are defined under the container spec using `readinessProbe` and `livenessProbe`.
Use `kubectl explain pod.spec.containers.livenessProbe` for syntax.

## Verification

Check that:

- Pod is running and ready
- Readiness probe is configured correctly
- Liveness probe is configured correctly
- Pod shows 1/1 READY status (indicating readiness probe passed)

**Useful commands:** `kubectl describe pod healthy-app | grep -A 10 Liveness`,
`kubectl describe pod healthy-app | grep -A 10 Readiness`,
`kubectl get pod healthy-app -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}'`
