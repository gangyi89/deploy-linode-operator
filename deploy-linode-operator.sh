#!/bin/bash

# Check if namespace is provided
if [ -z "$1" ]; then
    echo "Usage: ./deploy-linode-operator.sh <namespace>"
    exit 1
fi

NAMESPACE=$1

# Apply the YAML, replacing the namespace placeholder
kubectl apply -f <(curl -s https://raw.githubusercontent.com/gangyi89/deploy-linode-operator/main/linode-operator.yaml | sed "s/\${NAMESPACE}/$NAMESPACE/") --namespace $NAMESPACE

echo "Linode Operator deployed to namespace: $NAMESPACE"