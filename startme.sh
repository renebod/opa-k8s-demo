#!/usr/bin/env bash

# mkcert -install
# mkcert opa.local

kubectl create namespace opa

# kubectl create secret tls opa-tls \
#   --cert=opa.local.pem \
#   --key=opa.local-key.pem \
#   -n opa

# base64 -b 0 < opa.local.pem
# base64 -b 0 < opa.local-key.pem

kubectl apply -f opa.yaml

kubectl logs deployment/opa -n opa

# kubectl apply -f opa-policies-configmap.yaml
# kubectl rollout restart deployment/opa -n opa

# curl -k https://opa.local


# sed -i '' 's/\r$//' allow-admin.rego
# sed -i '' 's/\r$//' allow-readonly.rego
# sed -i '' 's/\r$//' deny-weekends.rego

# kubectl create configmap opa-policies \
#   --from-file=allow-admin.rego \
#   --from-file=allow-readonly.rego \
#   --from-file=deny-weekends.rego \
#   -n opa \
#   --dry-run=client -o yaml | kubectl apply -f -

# kubectl rollout restart deployment/opa -n opa


curl -k -H "Host: opa.local" https://opa.local/v1/data/myapp/auth/allow/result \
  -d '{"input": {"user": "admin"}}'
# returns {"result":true}

curl -k -H "Host: opa.local" https://opa.local/v1/data/myapp/auth/allow/result \
  -d '{"input": {"user": "bob"}}'
# returns {"result":false}
