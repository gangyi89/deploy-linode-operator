# Deploy Linode Firewall Operator

This repository contains a script to deploy the Linode Operator to a specified Kubernetes namespace.

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
