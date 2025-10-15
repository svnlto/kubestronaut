# Exercise 5: Use Values File for Complex Configuration (★★★)

Time: 8-10 minutes

## Task

Deploy a customized application using a Helm values file:

- Create a values file named `custom-values.yaml` with the following configuration for nginx:
  - Set `replicaCount: 2`
  - Set `service.type: ClusterIP`
  - Set `service.port: 8080`
  - Set resource limits: `resources.limits.memory: 256Mi` and `resources.limits.cpu: 500m`
- Install `bitnami/nginx` with release name `configured-web` using the values file
- Verify all customizations are applied correctly
- Update the values file to change replicas to 3
- Upgrade the release using the updated values file

## Hint

Create a YAML file with your custom values matching the chart's value structure. Use
`helm install <name> <chart> -f values-file.yaml` to install with a values file. For upgrades, use
`helm upgrade <name> <chart> -f values-file.yaml`. You can check the chart's default values structure with
`helm show values bitnami/nginx`.

## Verification

Check that:

- The values file exists and contains correct YAML syntax
- The release `configured-web` is installed: `helm list`
- Initial deployment has 2 replicas: `kubectl get pods -l app.kubernetes.io/instance=configured-web | grep -c Running`
- Service is ClusterIP type on port 8080:
  `kubectl get svc -l app.kubernetes.io/instance=configured-web -o jsonpath='{.items[0].spec.type}:{.items[0].spec.ports[0].port}'`
- Resource limits are set: `kubectl get deployment -l app.kubernetes.io/instance=configured-web -o jsonpath='{.items[0].spec.template.spec.containers[0].resources.limits}'`
- After upgrade: 3 replicas are running: `kubectl get pods -l app.kubernetes.io/instance=configured-web | grep -c Running`
- The values used match your file: `helm get values configured-web`

**Useful commands:** `helm show values`, `helm install -f`, `helm upgrade -f`, `helm get values`,
`kubectl get deployment`, `kubectl get svc`
