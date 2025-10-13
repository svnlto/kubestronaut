# Exercise 4: Headless Service (★★☆)

Time: 5-7 minutes

## Task

1. Create a deployment named `stateful-app` with image `nginx:alpine`, 3 replicas, label `app=stateful`
2. Create a headless service named `stateful-service` by setting `clusterIP: None`
3. The service should expose port 80
4. Verify that DNS returns individual pod IPs instead of a single service IP

## Hint

A headless service (clusterIP: None) doesn't allocate a cluster IP. Instead, DNS returns the IPs of all matching pods.
Create with `kubectl create service clusterip <name> --clusterip=None` or set `clusterIP: None` in YAML.

## Verification

Check that:

- Service is created: `kubectl get svc stateful-service`
- Service has no ClusterIP (shows "None"): `kubectl get svc stateful-service -o jsonpath='{.spec.clusterIP}'`
- Endpoints are populated: `kubectl get endpoints stateful-service`
- DNS returns pod IPs: `kubectl run test --image=busybox --rm -it --restart=Never -- nslookup stateful-service`
- All 3 pod IPs are in endpoints: `kubectl get endpoints stateful-service -o jsonpath='{.subsets[0].addresses[*].ip}'`

**Useful commands:** `kubectl create service`, `kubectl get endpoints`, `nslookup` from test pod
