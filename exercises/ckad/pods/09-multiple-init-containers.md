# Exercise 9: Pod with Multiple Init Containers (★★☆)

Time: 6-8 minutes

## Task

Create a pod that uses multiple init containers to perform sequential setup tasks:

- Create a pod named `startup-pod` using the `nginx:alpine` image
- Add three init containers that run in sequence:
  1. `init-check-dns` - Uses `busybox:1.36` image, runs command `nslookup kubernetes.default` to verify DNS
  2. `init-wait-service` - Uses `busybox:1.36` image, runs command
     `sh -c "until nslookup kubernetes.default; do echo waiting for dns; sleep 2; done"` to wait for DNS
  3. `init-create-file` - Uses `busybox:1.36` image, runs command
     `sh -c "echo 'Initialization complete' > /work-dir/ready.txt"` and mounts an emptyDir volume at `/work-dir`
- Mount the same emptyDir volume to the main container at `/usr/share/nginx/html`
- Name the volume `workdir`

## Hint

Init containers are defined in `spec.initContainers` and run in the order they are listed.
Each must complete successfully before the next one starts. Use `kubectl explain pod.spec.initContainers` for reference.

## Verification

Check that:

- All three init containers completed successfully
- Main container is running
- The file created by init container is accessible in the main container

**Useful commands:** `kubectl describe pod startup-pod`, `kubectl logs startup-pod -c init-check-dns`,
`kubectl logs startup-pod -c init-wait-service`, `kubectl logs startup-pod -c init-create-file`,
`kubectl exec startup-pod -- cat /usr/share/nginx/html/ready.txt`
