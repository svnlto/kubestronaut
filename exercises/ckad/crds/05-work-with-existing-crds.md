# Exercise 5: Working with Existing CRDs (★★★)

Time: 8-10 minutes

## Task

In the CKAD exam, you'll often work with clusters that already have CRDs installed (e.g., from operators like
Prometheus, Istio, cert-manager). Practice discovering and using them:

1. List all CRDs in the cluster and identify their API groups
2. Find the CRD for `websites.stable.example.com` and determine:
   - What versions are available?
   - Is it namespaced or cluster-scoped?
   - What shortnames can you use?
3. Create a new custom resource named `test-site` using the Website CRD with:
   - Namespace: `default`
   - Spec fields: `gitRepo: "https://github.com/test/site"` and `replicas: 1`
4. Update the `test-site` resource to change replicas to `5`
5. Delete the custom resource `test-site`
6. Export the Website CRD definition to a file named `website-crd-backup.yaml`

## Hint

- Use `kubectl get crd <name> -o yaml` to see full CRD structure
- Look at `spec.versions` to see available versions
- Look at `spec.scope` for namespaced vs cluster-scoped
- Look at `spec.names.shortNames` for shortcuts
- Custom resources can be updated with `kubectl edit`, `kubectl patch`, or `kubectl apply`
- Use `kubectl get crd <name> -o yaml > file.yaml` to export

## Verification

Check that:

- You listed all CRDs: `kubectl get crd`
- You found the Website CRD details: `kubectl get crd websites.stable.example.com -o yaml`
- The test-site was created: `kubectl get website test-site`
- The test-site was updated to 5 replicas: `kubectl get website test-site -o jsonpath='{.spec.replicas}'`
- The test-site is deleted: `kubectl get website test-site` should show not found
- The CRD is exported to file: `cat website-crd-backup.yaml` shows the CRD definition

**Useful commands:** `kubectl get crd`, `kubectl edit website <name>`, `kubectl delete website <name>`,
`kubectl get crd <name> -o yaml`
