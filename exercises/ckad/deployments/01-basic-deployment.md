# Exercise 1: Basic Deployment Creation (★☆☆)

Time: 3-4 minutes

## Task

Create a deployment that:

- Is named `web-app`
- Uses the image `nginx:1.21`
- Has 3 replicas
- Has labels `app=web` and `tier=frontend`
- Is created in the `default` namespace

## Hint

Use `kubectl create deployment` with the `--image` and `--replicas` flags. You can add labels after creation or
use `--dry-run=client -o yaml` to modify the YAML before applying.

## Verification

Check that:

- Deployment is created: `kubectl get deployment web-app`
- Correct number of replicas: `kubectl get deployment web-app -o jsonpath='{.spec.replicas}'`
- All pods are running: `kubectl get pods -l app=web`
- Deployment has correct image: `kubectl describe deployment web-app | grep Image`

**Useful commands:** `kubectl create deployment`, `kubectl get deployment`, `kubectl get pods`
