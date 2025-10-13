---
description: Validate that a CKAD exercise has been completed correctly by checking the Kubernetes resources
argument-hint: <exercise-name>
---

You are validating a CKAD exercise completion. Follow these steps:

1. **Find the exercise file**:
   - Search for files in `exercises/` directory matching the pattern `*$1*.md`
   - If multiple matches, ask the user which one they mean
   - If no matches, list available exercises in the relevant topic directory

2. **Read the exercise file**: Once found, read the exercise file
   - Extract all requirements from the "## Task" section
   - Note the resource name, type, and all specifications
   - Review the "## Verification" section for what to check

3. **Check the current Kubernetes context**:
   Run `kubectl config current-context` to verify which cluster is active.

4. **Validate each requirement**:
   For each requirement in the exercise, run the appropriate kubectl commands to verify:
   - Resource exists (kubectl get)
   - Configuration matches specs (kubectl describe, kubectl get -o yaml)
   - Functionality works (kubectl logs, kubectl exec, etc.)

5. **Provide a validation report**:
   Format your response as:

   ```text
   ## Exercise Validation: [Exercise Name]

   **Status**: ✅ PASS | ⚠️ PARTIAL | ❌ FAIL

   ### Requirements Check:
   - [✅|❌] Requirement 1: [Details]
   - [✅|❌] Requirement 2: [Details]
   - [✅|❌] Requirement N: [Details]

   ### Issues Found:
   [List any issues or missing requirements]

   ### Recommendations:
   [Suggest fixes if needed]
   ```

6. **Be specific**:
   - Show actual vs expected values
   - Quote relevant output from kubectl commands
   - Explain why something passed or failed

Example validation workflow:

- For a CronJob exercise: Check schedule, image, command, restartPolicy, history limits
- For a multi-container pod: Check container count, names, images, volumes
- For RBAC exercise: Check ServiceAccount, Role permissions, RoleBinding

Remember: You're checking against the exercise requirements, not best practices beyond what's specified.
