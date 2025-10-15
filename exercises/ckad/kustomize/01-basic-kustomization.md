# Exercise 1: Basic Kustomization (★☆☆)

Time: 5-7 minutes

## Task

Create a basic Kustomize structure that:

- Creates a directory structure: `~/kustomize-basic/`
- Creates a deployment named `web-app` using `nginx:1.21` image with 2 replicas
- Creates a service named `web-app` of type ClusterIP exposing port 80
- Creates a `kustomization.yaml` file that references both resources
- Sets a common label `env: dev` on all resources
- Adds a namePrefix of `dev-` to all resources
- Deploys the resources using `kubectl apply -k`

## Hint

- Use `kubectl create deployment` and `kubectl expose` with `--dry-run=client -o yaml` to generate base manifests
- The `kustomization.yaml` file should include `resources`, `commonLabels`, and `namePrefix` fields
- Deploy with `kubectl apply -k <directory>` instead of `-f`

## Verification

Check that:

- The deployment exists with name `dev-web-app` and has 2 replicas running
- The service exists with name `dev-web-app` and is type ClusterIP
- Both resources have the label `env: dev`
- Resources were created using Kustomize (check for `kustomize.config.k8s.io` annotations)

**Useful commands:** `kubectl get deploy,svc -l env=dev`, `kubectl describe deploy dev-web-app | grep -A5 Labels`
