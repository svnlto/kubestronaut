# Exercise 4: Cluster-Scoped CRD (★★☆)

Time: 6-8 minutes

## Task

Create a cluster-scoped CustomResourceDefinition and custom resource:

1. Create a CRD named `datacenters.infrastructure.example.com` with:
   - Group: `infrastructure.example.com`
   - Version: `v1` (served and stored)
   - Kind: `DataCenter`
   - Scope: `Cluster` (not namespaced)
   - Singular name: `datacenter`
   - Plural name: `datacenters`
   - Short name: `dc`

2. Create a custom resource instance named `us-west-1` of kind `DataCenter` with:
   - API version: `infrastructure.example.com/v1`
   - Spec containing:
     - `region: "us-west"`
     - `capacity: 1000`
     - `provider: "aws"`

## Hint

- The key difference between namespaced and cluster-scoped is the `scope` field in CRD spec
- Cluster-scoped resources don't belong to any namespace (like Nodes, PersistentVolumes)
- When creating cluster-scoped custom resources, don't include `namespace` in metadata
- Use `kubectl get <resource> --all-namespaces` won't work for cluster-scoped resources (they're not in any namespace)

## Verification

Check that:

- The CRD is created with Cluster scope: `kubectl get crd datacenters.infrastructure.example.com -o jsonpath='{.spec.scope}'`
- The DataCenter resource type is available: `kubectl api-resources | grep datacenter`
- The custom resource is created (no namespace): `kubectl get datacenters` or `kubectl get dc`
- The resource shows correct details: `kubectl get datacenter us-west-1 -o yaml`
- You cannot create it in a namespace: `kubectl get datacenter us-west-1 -n default` should show error or empty

**Useful commands:** `kubectl get crd`, `kubectl get datacenters`, `kubectl describe datacenter <name>`
