# Exercise 4: Egress Network Policy (★★★)

Time: 7-9 minutes

## Task

1. Create pod `restricted` (busybox, label `app=restricted`)
2. Create NetworkPolicy that:
   - Applies to `app=restricted`
   - Allows egress only to pods with `app=allowed`
   - Allows DNS (UDP port 53)
3. Verify restricted egress

## Hint

Egress policies control outbound traffic. Must allow DNS for name resolution. Use `policyTypes: [Egress]` and `egress` section.

## Verification

Check that:

- Pod running: `kubectl get pod restricted`
- NetworkPolicy exists: `kubectl get networkpolicy`
- Cannot reach external: `kubectl exec restricted -- wget -O- google.com --timeout=2` (fails)
- DNS works: `kubectl exec restricted -- nslookup kubernetes.default`
- Can reach allowed pods only

**Useful commands:** `kubectl exec`, `kubectl get networkpolicy`, `kubectl describe networkpolicy`
