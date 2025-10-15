# Exercise 4: ConfigMaps and Secrets with Kustomize (★★☆)

Time: 6-8 minutes

## Task

Create a Kustomize configuration that generates ConfigMaps and Secrets:

- Create directory: `~/kustomize-config/`
- Create a file `app.properties` with content:

  ```properties
  database.host=localhost
  database.port=5432
  app.name=MyApp
  ```

- Create a file `.env` with content:

  ```text
  DB_USER=admin
  DB_PASSWORD=secretpass123
  ```

- Create a `kustomization.yaml` that:
  - Generates a ConfigMap named `app-config` from `app.properties` file
  - Generates a Secret named `app-secret` from `.env` file (literal values)
  - Creates a deployment `myapp` that uses both
- The deployment should mount the ConfigMap as environment variables
- The deployment should mount the Secret as environment variables
- Deploy using `kubectl apply -k`

## Hint

- Use `configMapGenerator` with `files` field to create ConfigMap from file
- Use `secretGenerator` with `envs` or `literals` field to create Secret
- Kustomize automatically adds a hash suffix to generated ConfigMaps/Secrets
- In deployment, reference ConfigMap/Secret without the hash - Kustomize updates it automatically
- Use `envFrom` in pod spec to load all keys as environment variables

## Verification

Check that:

- ConfigMap exists with a hash suffix (e.g., `app-config-abc123xyz`)
- Secret exists with a hash suffix (e.g., `app-secret-xyz789abc`)
- Deployment `myapp` is running
- Pod has environment variables from both ConfigMap and Secret
- Running `kubectl exec` to check env vars shows all values

**Useful commands:** `kubectl get cm,secret`, `kubectl describe deploy myapp`,
`kubectl exec <pod-name> -- env | grep -E 'DB_|database|app'`
