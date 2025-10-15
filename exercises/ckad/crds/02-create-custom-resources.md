# Exercise 2: Create Custom Resource Instances (★★☆)

Time: 5-6 minutes

## Task

Using the `Website` CRD from the previous exercise (or create it if needed):

1. Create a custom resource instance named `company-site` in the default namespace with this specification:
   - Kind: `Website`
   - API version: `stable.example.com/v1`
   - Add a spec section with:
     - `gitRepo: "https://github.com/example/company-site"`
     - `replicas: 3`

2. Create another custom resource named `blog-site` in the default namespace with:
   - Kind: `Website`
   - API version: `stable.example.com/v1`
   - Add a spec section with:
     - `gitRepo: "https://github.com/example/blog"`
     - `replicas: 2`

## Hint

- Custom resources are created like any other Kubernetes resource using YAML
- The `apiVersion` should be `{group}/{version}` format: `stable.example.com/v1`
- CRDs don't validate spec content unless you define schema validation (not required for CKAD)
- You can use `kubectl apply -f` or `kubectl create -f` for custom resources

## Verification

Check that:

- Both custom resources are created: `kubectl get websites` or `kubectl get ws`
- The company-site shows correct gitRepo: `kubectl get website company-site -o jsonpath='{.spec.gitRepo}'`
- The blog-site shows correct replicas: `kubectl get website blog-site -o jsonpath='{.spec.replicas}'`
- You can describe the custom resource: `kubectl describe website company-site`

**Useful commands:** `kubectl get websites`, `kubectl describe website <name>`, `kubectl get ws -o yaml`
