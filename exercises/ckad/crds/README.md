# CustomResourceDefinition (CRD) Exercises for CKAD

CustomResourceDefinitions (CRDs) extend the Kubernetes API with custom resources. Understanding how to discover,
inspect, and work with CRDs is part of the CKAD v1.33 curriculum under "Application Design and Build" -
specifically understanding resources that extend Kubernetes.

## Exercises

1. [Create a Basic CustomResourceDefinition](01-basic-crd.md) (★★☆) - 5-7 minutes
2. [Create Custom Resource Instances](02-create-custom-resources.md) (★★☆) - 5-6 minutes
3. [Discover and Inspect Custom Resources](03-discover-custom-resources.md) (★☆☆) - 4-5 minutes
4. [Cluster-Scoped CRD](04-cluster-scoped-crd.md) (★★☆) - 6-8 minutes
5. [Working with Existing CRDs](05-work-with-existing-crds.md) (★★★) - 8-10 minutes

## Quick Reference

**Essential Commands:**

```bash
# List all CustomResourceDefinitions
kubectl get crd
kubectl get customresourcedefinitions

# Get details about a specific CRD
kubectl get crd <crd-name> -o yaml
kubectl describe crd <crd-name>

# Check if a CRD is namespaced or cluster-scoped
kubectl get crd <crd-name> -o jsonpath='{.spec.scope}'

# List all API resources (including custom resources)
kubectl api-resources
kubectl api-resources | grep <keyword>
kubectl api-resources --api-group=<group>

# Work with custom resources (once CRD is installed)
kubectl get <custom-resource-plural>
kubectl get <custom-resource-plural> -A
kubectl describe <custom-resource-kind> <name>
kubectl get <custom-resource-kind> <name> -o yaml
kubectl delete <custom-resource-kind> <name>

# Use shortnames for custom resources
kubectl get <shortname>  # e.g., kubectl get ws for websites

# Explain custom resource structure
kubectl explain <custom-resource-kind>
kubectl explain <custom-resource-kind>.spec

# Export CRD definition
kubectl get crd <crd-name> -o yaml > crd-backup.yaml

# Create custom resource from YAML
kubectl apply -f custom-resource.yaml
kubectl create -f custom-resource.yaml
```

**Basic CRD Structure:**

```yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: <plural>.<group>  # e.g., websites.stable.example.com
spec:
  group: stable.example.com
  names:
    kind: Website          # CamelCase singular
    plural: websites       # lowercase plural
    singular: website      # lowercase singular
    shortNames:
    - ws                   # optional shorthand
  scope: Namespaced        # or Cluster
  versions:
  - name: v1
    served: true           # is this version served by API server?
    storage: true          # is this the version used for storage?
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              gitRepo:
                type: string
              replicas:
                type: integer
```

**Basic Custom Resource Structure:**

```yaml
apiVersion: stable.example.com/v1  # group/version
kind: Website                       # from CRD
metadata:
  name: my-website
  namespace: default                # only if CRD scope is Namespaced
spec:
  gitRepo: "https://github.com/example/site"
  replicas: 3
```

## CRD Scope: Namespaced vs Cluster

### Namespaced Resources

- Belong to a namespace (like Pods, Services, ConfigMaps)
- Scope: `Namespaced` in CRD spec
- Can be listed per namespace or across all namespaces with `-A`
- Examples: Custom application configs, tenant-specific resources

### Cluster-Scoped Resources

- Don't belong to any namespace (like Nodes, PersistentVolumes, Namespaces)
- Scope: `Cluster` in CRD spec
- Only one instance per name across entire cluster
- Examples: Infrastructure resources, cluster-wide configurations

## Common Exam Scenarios

1. **Discovering what CRDs are installed**
   - Use `kubectl get crd` to list all CRDs
   - Use `kubectl api-resources` to see what custom resources are available
   - Fastest way to check if a resource type exists

2. **Creating a custom resource from an existing CRD**
   - Inspect the CRD first: `kubectl get crd <name> -o yaml`
   - Check the group, version, kind, and scope
   - Create YAML with correct apiVersion (group/version) and kind
   - Include namespace if scope is Namespaced

3. **Listing instances of a custom resource**
   - Use the plural name: `kubectl get <plural>`
   - Or use shortname if available: `kubectl get <shortname>`
   - For namespaced resources: `kubectl get <plural> -A` for all namespaces

4. **Understanding CRD properties**
   - Check versions: which is served, which is storage version
   - Check scope: Namespaced or Cluster
   - Check names: plural, singular, kind, shortNames

5. **Working with operators and their custom resources**
   - Operators install CRDs automatically
   - You need to create custom resources to configure the operator
   - Common examples: Prometheus (ServiceMonitor), Istio (VirtualService), cert-manager (Certificate)

## Tips for CKAD Exam

✅ **DO:**

- Use `kubectl api-resources` to quickly find custom resource types and their shortnames
- Use `kubectl explain <custom-resource>` to understand the structure of custom resources
- Check CRD scope before creating custom resources (namespaced requires namespace)
- Use shortnames when available (saves typing): `kubectl get ws` instead of `kubectl get websites`
- Remember that CRDs themselves are cluster-scoped (no namespace) even if the custom resources they define are namespaced
- Use `kubectl get crd <name> -o yaml` to see the full CRD structure including schema
- Practice creating both namespaced and cluster-scoped CRDs

❌ **DON'T:**

- Don't try to create CRDs imperatively with `kubectl run` or `kubectl create` - you must use YAML
- Don't confuse the CRD (the definition) with custom resources (instances of that definition)
- Don't forget to specify the correct apiVersion format: `<group>/<version>` not just the version
- Don't assume all custom resources are namespaced - check the CRD scope first
- Don't forget that custom resources can't be created until their CRD exists
- Don't spend time writing complex schema validation unless specifically asked - it's optional
- Don't forget that CRD names must be in format `<plural>.<group>` (e.g., `websites.stable.example.com`)

## CRD Versions

### Multiple Versions

- A CRD can support multiple versions (v1alpha1, v1beta1, v1)
- One version must be marked as `storage: true` (the version used for persistence)
- Multiple versions can be marked as `served: true` (available via API)
- Users can specify which version to use in their custom resource's apiVersion

### Version Properties

- `name`: The version identifier (e.g., v1, v1beta1)
- `served`: Boolean - whether this version is served by the API server
- `storage`: Boolean - whether this is the storage version (only one can be true)
- `schema`: OpenAPI v3 schema for validation (optional but recommended)

## Schema Validation (Optional)

CRDs can include OpenAPI v3 schema to validate custom resources:

```yaml
versions:
- name: v1
  served: true
  storage: true
  schema:
    openAPIV3Schema:
      type: object
      properties:
        spec:
          type: object
          required:
          - gitRepo
          properties:
            gitRepo:
              type: string
              pattern: '^https?://'
            replicas:
              type: integer
              minimum: 1
              maximum: 100
```

**For CKAD:** Schema validation is good to understand but rarely required in exam questions. Focus on basic CRD
creation and custom resource manipulation.

## Real-World CRD Examples

In production clusters, you'll commonly see CRDs from:

### Prometheus Operator

- ServiceMonitor, PodMonitor, PrometheusRule
- Used to configure monitoring targets

### Istio

- VirtualService, DestinationRule, Gateway
- Used to configure service mesh routing

### cert-manager

- Certificate, Issuer, ClusterIssuer
- Used to manage TLS certificates

### Ingress Controllers

- IngressRoute (Traefik), HTTPRoute (Gateway API)
- Extended ingress configurations

### Application Operators

- Database, Redis, Kafka (from various operators)
- Declarative application deployment

## Quick Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| `error: the server doesn't have a resource type "<kind>"` | CRD not installed | Check `kubectl get crd`, install CRD first |
| `error: resource name must be specified` | Wrong resource name | Use plural name: `websites` not `website` |
| `error: the server could not find the requested resource` | Wrong API group or version | Check CRD for correct group/version |
| Custom resource not created | Wrong namespace or scope | Check if CRD is Namespaced, ensure `-n` flag if needed |
| `validation failed` | Schema validation error | Check CRD schema, ensure required fields present |

## Time-Saving Shortcuts

```bash
# Quickly check if a resource type exists
kubectl api-resources | grep <keyword>

# Get CRD scope in one command
kubectl get crd <name> -o jsonpath='{.spec.scope}{"\n"}'

# List all custom resources from a specific API group
kubectl api-resources --api-group=stable.example.com

# Get all versions supported by a CRD
kubectl get crd <name> -o jsonpath='{.spec.versions[*].name}{"\n"}'

# Export CRD for backup or migration
kubectl get crd <name> -o yaml > crd-backup.yaml

# Quick describe of custom resource
k describe <kind> <name>
```

## Exam-Realistic Scenarios

### Scenario 1: Operator is pre-installed

You're given a cluster with cert-manager installed. Create a Certificate resource named `app-tls` in the `default` namespace.

**Steps:**

1. Find the CRD: `kubectl get crd | grep certificate`
2. Check API version: `kubectl get crd certificates.cert-manager.io -o yaml | grep -A5 versions`
3. Create custom resource with correct apiVersion and kind

### Scenario 2: Discover custom resources

Find all custom resources of type "ServiceMonitor" in the monitoring namespace.

**Steps:**

1. Find the resource: `kubectl api-resources | grep servicemonitor`
2. List instances: `kubectl get servicemonitor -n monitoring`

### Scenario 3: Create CRD for application config

Create a CRD for storing application configurations. Must be namespaced, named `appconfigs.apps.example.com`.

**Steps:**

1. Write YAML with correct structure (group, names, scope, versions)
2. Apply: `kubectl apply -f crd.yaml`
3. Verify: `kubectl get crd appconfigs.apps.example.com`

## Additional Resources

- **Official Docs:** <https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/>
- **kubectl explain:** Use `kubectl explain crd.spec` to explore CRD structure
- **API resources:** `kubectl api-resources -o wide` shows all available resources
