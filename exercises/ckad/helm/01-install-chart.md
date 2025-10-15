# Exercise 1: Install Helm Chart from Repository (★☆☆)

Time: 5-7 minutes

## Task

Install a Bitnami Nginx chart using Helm:

- Add the Bitnami Helm repository with the name `bitnami`
- Install the `bitnami/nginx` chart in the `default` namespace
- Name the release `web-server`
- Verify that the nginx pods are running
- Verify the release is successfully deployed

## Hint

Use `helm repo add` to add repositories and `helm install` to deploy charts. You can search for available
charts with `helm search repo`. The Bitnami repository URL is <https://charts.bitnami.com/bitnami>.

## Verification

Check that:

- The Bitnami repository is added: `helm repo list`
- The release `web-server` exists: `helm list`
- The nginx pods are running: `kubectl get pods -l app.kubernetes.io/instance=web-server`
- The release status is "deployed": `helm status web-server`

**Useful commands:** `helm repo add`, `helm repo list`, `helm install`, `helm list`, `helm status`
