# Exercise 11: Pod with Node Affinity and Node Selector (★★☆)

Time: 5-7 minutes

## Task

Create pods that demonstrate node scheduling constraints:

- First, label one of your cluster nodes with `disktype=ssd`
- Create a pod named `fast-storage` using `nginx:alpine` image that:
  - Uses a **nodeSelector** to run only on nodes with label `disktype=ssd`
  - Has label `tier=cache`
- Create a second pod named `preferred-storage` using `redis:alpine` image that:
  - Uses **node affinity** with a `preferredDuringSchedulingIgnoredDuringExecution` rule
  - Prefers nodes with label `disktype=ssd` with weight `100`
  - Has label `tier=database`

## Hint

Use `kubectl get nodes` to see available nodes, then `kubectl label node <node-name> disktype=ssd`.
NodeSelector is simple but rigid; node affinity provides more flexibility.
Use `kubectl explain pod.spec.affinity.nodeAffinity` for syntax.

## Verification

Check that:

- Node has the `disktype=ssd` label
- Pod `fast-storage` is scheduled on the labeled node
- Pod `fast-storage` uses nodeSelector correctly
- Pod `preferred-storage` has node affinity configured
- Both pods are running

**Useful commands:** `kubectl get nodes --show-labels | grep disktype`, `kubectl get pod fast-storage -o wide`,
`kubectl get pod preferred-storage -o jsonpath='{.spec.affinity}'`,
`kubectl describe pod fast-storage | grep "Node-Selectors"`
