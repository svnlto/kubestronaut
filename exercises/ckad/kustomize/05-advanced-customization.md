# Exercise 5: Advanced Kustomize Features (★★★)

Time: 10-12 minutes

## Task

Create an advanced Kustomize configuration demonstrating multiple features:

- Create directory structure:

  ```text
  ~/kustomize-advanced/
  ├── base/
  │   ├── deployment.yaml (webapp, nginx:alpine, 1 replica)
  │   ├── service.yaml (ClusterIP, port 80)
  │   └── kustomization.yaml
  └── production/
      └── kustomization.yaml
  ```

- The production overlay should:
  - Reference the base
  - Set namespace to `production` (create namespace first)
  - Add namePrefix `prod-`
  - Add nameSuffix `-v2`
  - Add common labels: `env: production`, `team: platform`
  - Add common annotations: `managed-by: kustomize`, `version: 2.0.0`
  - Replace the nginx image with `nginx:1.23-alpine`
  - Scale to 4 replicas
  - Generate a ConfigMap from literal values: `LOG_LEVEL=info`, `DEBUG=false`
  - Add the ConfigMap as environment variables to the deployment
- Deploy to the production namespace

## Hint

- Create namespace first: `kubectl create namespace production`
- Use `namespace` field in kustomization.yaml to set target namespace
- Use `namePrefix` and `nameSuffix` together for complex naming
- Use `commonLabels` and `commonAnnotations` for metadata
- Use `images` field with `newName` and `newTag` to replace images
- Use `replicas` field with name selector to change replica count
- Use `configMapGenerator` and then reference it in a patch or directly in base
- You may need to patch the deployment to add the configMap as envFrom

## Verification

Check that:

- Namespace `production` exists
- Deployment named `prod-webapp-v2` exists in production namespace with 4 replicas
- Service named `prod-webapp-v2` exists in production namespace
- All resources have labels `env: production` and `team: platform`
- All resources have annotations `managed-by: kustomize` and `version: 2.0.0`
- Deployment uses image `nginx:1.23-alpine`
- ConfigMap exists with hash suffix containing LOG_LEVEL and DEBUG
- Pods have environment variables from the ConfigMap

**Useful commands:** `kubectl get all -n production -o wide`,
`kubectl describe deploy prod-webapp-v2 -n production | grep -A10 Annotations`,
`kubectl get cm -n production`
