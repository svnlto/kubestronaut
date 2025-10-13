# Exercise 2: ConfigMap from File (★☆☆)

Time: 4-5 minutes

## Task

1. Create a file named `app.properties` with the following content:

   ```text
   database.host=localhost
   database.port=5432
   database.name=myapp
   ```

2. Create a ConfigMap named `db-config` from this file
3. Create another file named `logging.conf` with:

   ```text
   level=debug
   format=json
   ```

4. Add this file to the same ConfigMap with key name `logging.conf`
5. Verify both files are in the ConfigMap

## Hint

Use `kubectl create configmap --from-file=<filename>`. The file name becomes the key,
and file contents become the value. You can use multiple `--from-file` flags.

## Verification

Check that:

- ConfigMap exists: `kubectl get configmap db-config`
- Contains both files: `kubectl describe configmap db-config`
- File contents are correct: `kubectl get configmap db-config -o yaml`
- Specific file content: `kubectl get configmap db-config -o jsonpath='{.data.app\.properties}'`

**Useful commands:** `kubectl create configmap --from-file`, `kubectl describe configmap`
