# Exercise 1: Basic Container Logging (★☆☆)

Time: 5-8 minutes

## Task

Understand how to view and analyze container logs in Kubernetes to diagnose application behavior and troubleshoot issues.

Requirements:

- Create a single-container Pod that writes logs to stdout
- View the Pod's logs using kubectl
- Create a multi-container Pod with at least two containers
- View logs from a specific container in the multi-container Pod
- Understand how to follow logs in real-time
- View logs from a previously crashed container

## Hint

Container logs in Kubernetes capture stdout and stderr streams from applications. The `kubectl logs`
command retrieves these logs through the API server. For multi-container Pods, you must specify which
container's logs to view using the `-c` flag.

Logs are ephemeral and stored on the node - they disappear when Pods are deleted. This is why production
systems use centralized logging solutions (like Fluentd or Loki) to aggregate and persist logs from all
containers.

## Verification

Check that:

- You can create a Pod that outputs logs continuously
- You can view current logs from the Pod
- You can follow logs in real-time using the `-f` flag
- You can specify a container name when viewing logs from multi-container Pods
- You understand the `--previous` flag to view logs from crashed containers
- You can explain why applications should log to stdout/stderr instead of files

**Useful commands:** `kubectl logs <pod-name>`, `kubectl logs <pod-name> -c <container-name>`,
`kubectl logs -f <pod-name>`, `kubectl logs --previous <pod-name>`,
`kubectl logs --tail=<number> <pod-name>`
