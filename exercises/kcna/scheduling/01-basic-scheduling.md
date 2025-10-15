# Exercise 1: Basic Pod Scheduling (★☆☆)

Time: 5-8 minutes

## Task

Understand how the Kubernetes scheduler assigns Pods to nodes and practice using nodeSelector for basic node
placement control.

Requirements:

- Examine the available nodes in your cluster and their labels
- Create a Pod named `nginx-scheduled` with a nodeSelector to target a specific node using the
  `kubernetes.io/hostname` label
- Verify the Pod is running on the targeted node
- Create a second Pod named `nginx-unschedulable` with an impossible nodeSelector constraint
  (e.g., `disktype: ssd-nonexistent`)
- Observe and understand why the second Pod remains in Pending state

## Hint

The Kubernetes scheduler automatically assigns Pods to nodes based on resource availability and constraints.
The `nodeSelector` field is the simplest way to constrain Pods to nodes with specific labels. All nodes have
built-in labels like `kubernetes.io/hostname` that you can use for targeting.

When a Pod's nodeSelector requirements cannot be met, the Pod will remain in "Pending" state and you'll see
FailedScheduling events when you describe the Pod.

## Verification

Check that:

- You can list all nodes and view their labels using `kubectl get nodes --show-labels`
- You created a Pod with nodeSelector that successfully scheduled to the intended node
- You can identify which node a Pod is running on using `kubectl get pods -o wide`
- You created a Pod with an impossible nodeSelector that remains in Pending state
- You can explain why the second Pod cannot be scheduled by examining its events

**Useful commands:** `kubectl get nodes --show-labels`, `kubectl describe pod <pod-name>`,
`kubectl get pods -o wide`, `kubectl explain pod.spec.nodeSelector`
