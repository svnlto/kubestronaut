# Exercise 1: Basic Pod Scheduling (★☆☆)

Time: 5-8 minutes

## Task

Understand how the Kubernetes scheduler assigns Pods to nodes and practice using nodeSelector for basic node
placement control.

Requirements:

- Examine the available nodes in your cluster and their labels
- Create a Pod with a nodeSelector to target a specific node
- Understand how the scheduler makes placement decisions
- Observe what happens when nodeSelector constraints cannot be satisfied

## Hint

The Kubernetes scheduler automatically assigns Pods to nodes based on resource availability and constraints.
The `nodeSelector` field is the simplest way to constrain Pods to nodes with specific labels.
All nodes have built-in labels like `kubernetes.io/hostname` that you can use for targeting.

Use `kubectl get nodes --show-labels` to see all available node labels, and `kubectl describe pod` to see
scheduling events and decisions.

## Verification

Check that:

- You can list all nodes and view their labels
- You created a Pod with a nodeSelector that successfully scheduled
- You understand why a Pod might remain in "Pending" state if nodeSelector requirements aren't met
- You can identify which node a Pod is running on using `kubectl get pods -o wide`

**Useful commands:** `kubectl get nodes --show-labels`, `kubectl describe pod <pod-name>`,
`kubectl get pods -o wide`, `kubectl explain pod.spec.nodeSelector`

## Deep Dive Questions

- What is the role of the kube-scheduler component?
- What happens if no nodes match the nodeSelector criteria?
- What are the differences between nodeSelector, node affinity, and taints/tolerations?
- How does the scheduler evaluate resource requests when placing Pods?

## Solution Example

1. **View available nodes and labels:**

```bash
kubectl get nodes --show-labels
kubectl get nodes -o json | jq '.items[].metadata.labels'
```

1. **Create a Pod with nodeSelector:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-scheduled
spec:
  nodeSelector:
    kubernetes.io/hostname: <node-name>
  containers:
  - name: nginx
    image: nginx:1.25
    resources:
      requests:
        memory: "64Mi"
        cpu: "250m"
```

1. **Verify scheduling:**

```bash
kubectl get pods -o wide
kubectl describe pod nginx-scheduled
```

1. **Test with impossible constraint:**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-unschedulable
spec:
  nodeSelector:
    disktype: ssd-nonexistent
  containers:
  - name: nginx
    image: nginx:1.25
```

Check events:

```bash
kubectl describe pod nginx-unschedulable
# Look for "FailedScheduling" events
```

## Key Concepts for KCNA

- **Scheduler**: Control plane component that watches for newly created Pods and assigns them to nodes
- **nodeSelector**: Simplest form of node selection constraint using label matching
- **Pending state**: Pod is accepted but cannot be scheduled (check events for reason)
- **Node labels**: Key-value pairs used to organize and select nodes
- **Resource requests**: Help scheduler find nodes with sufficient capacity

## Cleanup

```bash
kubectl delete pod nginx-scheduled nginx-unschedulable
```
