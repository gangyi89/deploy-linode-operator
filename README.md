# Deploy Linode Operator

This repository contains a script to deploy the Linode Operator to a specified Kubernetes namespace.

## Prerequisites

- Kubernetes cluster set up and configured
- `kubectl` installed and configured to interact with your cluster
- `curl` installed on your system

## Usage

1. Run the following command to deploy the required CRD and Operator
```
//specify the desired namespace for operator to be deployed in. 
// Omitted blank for default namespace
curl -s https://raw.githubusercontent.com/gangyi89/deploy-linode-operator/main/deploy-linode-operator.sh | bash -s -- <MY_NAMESPACE>
```

2. Copy sample cluster-firewall.yaml and populate Firewall ID and Linode API Key
```
//Deploy to the same namespace as the operator
kubectl apply -f cluster-firewall.yaml -n <MY_NAMESPACE>
```
