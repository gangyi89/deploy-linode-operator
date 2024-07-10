#!/bin/bash

# Set default namespace
NAMESPACE="default"

# Check if namespace is provided
if [ -n "$1" ]; then
    NAMESPACE=$1
fi

# Apply the YAML, replacing the namespace placeholder
kubectl apply -f <(curl -s https://raw.githubusercontent.com/gangyi89/deploy-linode-operator/main/linode-operator.yaml | sed "s/\${NAMESPACE}/$NAMESPACE/") --namespace $NAMESPACE

echo "Linode Operator deployed to namespace: $NAMESPACE"