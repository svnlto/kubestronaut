# Exercise 3: Strategic Merge and JSON Patches (★★☆)

Time: 8-10 minutes

## Task

Create a Kustomize setup demonstrating patches:

- Create directory: `~/kustomize-patches/`
- Create a base deployment `api-server` with:
  - Image: `nginx:alpine`
  - 1 replica
  - Container port 80
  - No resource limits
- Create a `kustomization.yaml` that applies patches to:
  - Add memory request of 128Mi and limit of 256Mi
  - Add cpu request of 100m and limit of 200m
  - Add an environment variable `ENV=production`
  - Change replicas to 3
  - Add a label `version: v1.0`
- Use either `patchesStrategicMerge` or `patches` (JSON6902 format)
- Deploy the patched configuration

## Hint

- Strategic merge patches are partial YAML files that get merged with the base
- JSON patches allow precise modifications using RFC 6902 operations (add, remove, replace)
- For strategic merge: create a patch file like `patch-resources.yaml` with same apiVersion/kind/name
- For JSON patch: use `patches` field with `target` and `patch` in kustomization.yaml
- `kubectl explain deployment.spec.template.spec.containers.resources` shows the structure

## Verification

Check that:

- Deployment `api-server` has 3 replicas running
- Pods have resource requests: 128Mi memory, 100m CPU
- Pods have resource limits: 256Mi memory, 200m CPU
- Pods have environment variable `ENV=production`
- Deployment has label `version: v1.0`

**Useful commands:** `kubectl describe deploy api-server | grep -A8 Limits`, `kubectl get deploy api-server -o jsonpath='{.spec.template.spec.containers[0].env}'`
