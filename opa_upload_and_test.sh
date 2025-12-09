#!/usr/bin/env bash
set -euo pipefail

OPA_URL="https://opa.local/v1"

echo "=== Uploading Rego Policies ==="

# Policy 1: Allow Alice to read
curl -sk -X PUT "${OPA_URL}/policies/policy1" --data-binary @- <<'EOF'
package example

allow {
    input.user == "alice"
    input.action == "read"
}
EOF
echo "Uploaded policy1"

# Policy 2: Admins can access servers
curl -sk -X PUT "${OPA_URL}/policies/policy2" --data-binary @- <<'EOF'
package example

decision {
    input.role == "admin"
    input.resource
}
EOF
echo "Uploaded policy2"

# Policy 3: IP-based enforcement
curl -sk -X PUT "${OPA_URL}/policies/policy3" --data-binary @- <<'EOF'
package example

enforce {
    input.ip == "10.0.0.5"
    input.operation == "connect"
}
EOF
echo "Uploaded policy3"

echo
echo "=== Running Tests Against Policies ==="

echo "--- Test 1: Query policy1 allow ---"
curl -sk -X POST "${OPA_URL}/data/example/allow" \
    -H "Content-Type: application/json" \
    -d '{"input": {"user": "alice", "action": "read"}}'
echo
echo

echo "--- Test 2: Query policy2 decision ---"
curl -sk -X POST "${OPA_URL}/data/example/decision" \
    -H "Content-Type: application/json" \
    -d '{"input": {"resource": "server1", "role": "admin"}}'
echo
echo

echo "--- Test 3: Query policy3 enforce ---"
curl -sk -X POST "${OPA_URL}/data/example/enforce" \
    -H "Content-Type: application/json" \
    -d '{"input": {"ip": "10.0.0.5", "operation": "connect"}}'
echo
echo "=== Done ==="
