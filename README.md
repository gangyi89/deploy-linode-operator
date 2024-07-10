# Deploy Linode Firewall Operator

This repository contains a script to deploy the Linode Firewall Operator to a specified Kubernetes namespace.

## Prerequisites

1. Linode Kubernetes Cluster
2. Dedicated Linode Firewall for the cluster
   - The firewall should only be used for the cluster
   - Operator will compare the worker nodes against the firewall device list and remove any devices that are not cluster nodes
3. Linode PAT Token with "Firewalls Read/Write" permissions

## Usage

1. Deploy the required CRD and Operator:

   ```bash
   curl -s https://raw.githubusercontent.com/gangyi89/deploy-linode-operator/main/deploy-linode-fw-operator.sh | bash -s -- <MY_NAMESPACE>
   ```

   > Note: Specify the desired namespace for the operator. If not specified, the default namespace will be used.

2. Deploy the firewall object:

   a. Copy the sample `cluster-firewall.yaml` file
   b. Populate the Firewall ID and Linode API Key
   c. Deploy the firewall object to the same namespace:

   ```bash
   kubectl apply -f cluster-firewall.yaml -n <MY_NAMESPACE>
   ```