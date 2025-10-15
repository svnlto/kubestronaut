# Exercise 1: Create a Basic CustomResourceDefinition (★★☆)

Time: 5-7 minutes

## Task

Create a CustomResourceDefinition (CRD) that:

- Is named `websites.stable.example.com`
- Has a group of `stable.example.com`
- Has a version `v1` that is both served and stored
- Has a kind of `Website`
- Is namespaced (not cluster-scoped)
- Uses the singular name `website` and plural name `websites`
- Has a shortname `ws`

After creating the CRD, verify that the new custom resource type is available in the cluster.

## Hint

- Use `kubectl explain crd` or `kubectl explain customresourcedefinition` to see the structure
- The spec requires: `group`, `names`, `scope`, and `versions` fields
- Each version needs `name`, `served`, and `storage` properties
- You'll need to write YAML for this one - CRDs can't be created imperatively

## Verification

Check that:

- The CRD is created and available: `kubectl get crd websites.stable.example.com`
- The new resource type appears in API resources: `kubectl api-resources | grep website`
- You can list (empty) websites: `kubectl get websites` or `kubectl get ws`
- The CRD shows correct scope as Namespaced: `kubectl get crd websites.stable.example.com -o jsonpath='{.spec.scope}'`

**Useful commands:** `kubectl get crd`, `kubectl api-resources`, `kubectl explain crd.spec`
