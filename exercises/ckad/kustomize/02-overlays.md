# Exercise 2: Base and Overlay Pattern (★★☆)

Time: 7-9 minutes

## Task

Create a Kustomize structure with base and overlays:

- Create directory structure:

  ```text
  ~/kustomize-app/
  ├── base/
  │   ├── deployment.yaml (app=myapp, image=nginx:1.21, replicas=1)
  │   ├── service.yaml (ClusterIP, port 80)
  │   └── kustomization.yaml
  ├── overlays/
  │   ├── dev/
  │   │   └── kustomization.yaml (replicas=2, namePrefix=dev-)
  │   └── prod/
  │       └── kustomization.yaml (replicas=5, namePrefix=prod-, image=nginx:1.23)
  ```

- Deploy both dev and prod environments
- Dev should have 2 replicas with original image
- Prod should have 5 replicas with updated image nginx:1.23

## Hint

- Use `bases` or `resources` in overlay kustomization.yaml to reference `../../base`
- Use `replicas` field to override replica count
- Use `images` field to override container images in prod overlay
- Deploy each with: `kubectl apply -k overlays/dev` and `kubectl apply -k overlays/prod`

## Verification

Check that:

- Dev deployment `dev-myapp` exists with 2 replicas running nginx:1.21
- Prod deployment `prod-myapp` exists with 5 replicas running nginx:1.23
- Both deployments have corresponding services
- Both environments run simultaneously without conflicts

**Useful commands:** `kubectl get deploy -o wide`, `kubectl get deploy dev-myapp -o jsonpath='{.spec.template.spec.containers[0].image}'`
