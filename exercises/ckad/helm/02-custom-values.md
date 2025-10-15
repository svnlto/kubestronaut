# Exercise 2: Customize Helm Installation with Values (★★☆)

Time: 6-8 minutes

## Task

Install an Apache web server using Helm with custom values:

- Add the Bitnami repository if not already added
- Install the `bitnami/apache` chart with release name `custom-apache` in namespace `default`
- Customize the installation to:
  - Set replica count to 2
  - Set service type to `NodePort`
- Use the `--set` flag for customization (not a values file)
- Verify the configuration is applied correctly

## Hint

Use `helm show values bitnami/apache` to see all available configuration options. The `--set` flag follows
the format `--set key=value,key2=value2`. For nested values, use dot notation like `service.type=NodePort`.

## Verification

Check that:

- The release `custom-apache` is deployed: `helm list`
- There are 2 apache pods running: `kubectl get pods -l app.kubernetes.io/instance=custom-apache`
- The service type is NodePort: `kubectl get svc -l app.kubernetes.io/instance=custom-apache -o jsonpath='{.items[0].spec.type}'`
- You can retrieve the custom values: `helm get values custom-apache`

**Useful commands:** `helm show values`, `helm install --set`, `helm get values`, `kubectl get pods`, `kubectl get svc`
