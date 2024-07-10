# Deploy Linode Firewall Operator

This repository contains a script to deploy the Linode Firewall Operator to a specified Kubernetes namespace.

## Pre-requisite

1. Linode Kubernetes Cluster
2. Dedicated Linode Firewall for the cluster - The firewall should only be used for the cluster. Operator will compare the worker nodes against the firewall device list and remove any devices that are not the cluster nodes.
3. Linode PAT Token - Firewalls "Read/Write" only

## Usage

1. Run the following command to deploy the required CRD and Operator. 

Specify the desired namespace for operator. Default namespace will be used when not specified.
```
curl -s https://raw.githubusercontent.com/gangyi89/deploy-linode-operator/main/deploy-linode-fw-operator.sh | bash -s -- <MY_NAMESPACE>
```

2. Copy sample cluster-firewall.yaml and populate Firewall ID and Linode API Key. 

Deploy firewall object to the same namespace.
```
kubectl apply -f cluster-firewall.yaml -n <MY_NAMESPACE>
```
