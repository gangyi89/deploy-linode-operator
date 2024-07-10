#!/bin/bash

# Set default namespace
NAMESPACE="default"

# Check if namespace is provided
if [ -n "$1" ]; then
    NAMESPACE=$1
fi

# Apply the YAML, replacing the namespace placeholder
kubectl apply -f <(curl -s https://raw.githubusercontent.com/gangyi89/deploy-linode-operator/main/linode-fw-operator.yaml | sed "s/\${NAMESPACE}/$NAMESPACE/") --namespace $NAMESPACE

echo "Linode FirewallOperator deployed to namespace: $NAMESPACE"