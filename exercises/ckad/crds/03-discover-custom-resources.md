# Exercise 3: Discover and Inspect Custom Resources (★☆☆)

Time: 4-5 minutes

## Task

Your cluster has several CRDs already installed (from operators or other tools). Perform these discovery tasks:

1. List all CustomResourceDefinitions in the cluster
2. Find any CRDs that are in the `apiextensions.k8s.io` group
3. Check if there are any custom resources of type `Website` in the default namespace
4. Get detailed information about the `websites.stable.example.com` CRD including its versions and scope
5. List all API resources and identify which ones are custom (not built-in Kubernetes resources)

## Hint

- Use `kubectl get crd` to list CustomResourceDefinitions
- Use `kubectl api-resources` to see all available resource types (including custom ones)
- Custom resources typically have API groups that are not `apps`, `v1`, `batch`, etc.
- The `-o wide` flag often shows additional useful information
- `kubectl explain <resource>` works for custom resources too

## Verification

Check that you can:

- List all CRDs: `kubectl get crd`
- Show the Website CRD details: `kubectl get crd websites.stable.example.com -o yaml`
- View the API group and version: `kubectl api-resources | grep website`
- Explain the custom resource structure: `kubectl explain website`
- List all instances of the custom resource: `kubectl get websites --all-namespaces`

**Useful commands:** `kubectl get crd`, `kubectl api-resources`, `kubectl explain <custom-resource>`,
`kubectl get <custom-resource> -A`
