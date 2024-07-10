# Deploy Linode Operator

This repository contains a script to deploy the Linode Operator to a specified Kubernetes namespace.

## Prerequisites

- Kubernetes cluster set up and configured
- `kubectl` installed and configured to interact with your cluster
- `curl` installed on your system

## Usage

Run the following command with the desired namespace
```
curl -s https://raw.githubusercontent.com/gangyi89/deploy-linode-operator/main/deploy-linode-operator.sh | bash -s -- my-namespace
```
