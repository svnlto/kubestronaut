# Exercise 4: Inspect and List Helm Releases (★☆☆)

Time: 5-6 minutes

## Task

Practice inspecting Helm releases and charts:

- Install the `bitnami/redis` chart with release name `cache-db` in namespace `default`
- List all Helm releases in the current namespace
- Get the full manifest (all Kubernetes resources) that were deployed for `cache-db`
- View the values that were used for the `cache-db` installation
- Get the status and notes for the `cache-db` release
- Clean up by uninstalling the release

## Hint

Use `helm get` subcommands to inspect releases: `helm get manifest`, `helm get values`, `helm get notes`.
The `helm list` command shows all releases, and `helm status` shows release information including status and notes.

## Verification

Check that:

- You can list the release: `helm list` shows `cache-db`
- You can view the Kubernetes manifest: `helm get manifest cache-db` returns YAML output
- You can see the values used: `helm get values cache-db` returns configuration
- You can check the status: `helm status cache-db` shows deployment status and notes
- After uninstall: `helm list` no longer shows `cache-db`
- After uninstall: `kubectl get all -l app.kubernetes.io/instance=cache-db` returns no resources

**Useful commands:** `helm list`, `helm get manifest`, `helm get values`, `helm get notes`, `helm status`, `helm uninstall`
