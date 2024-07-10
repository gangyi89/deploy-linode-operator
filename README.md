# Deploy Linode Firewall Operator

This repository contains a script to deploy the Linode Firewall Operator to a specified Kubernetes namespace.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [FAQ](#faq)

## Prerequisites

1. Linode Kubernetes Cluster
2. Dedicated Linode Firewall for the cluster
   - The firewall should only be used for the cluster
   - Operator will compare the worker nodes against the firewall device list and remove any devices that are not cluster nodes
3. Linode PAT Token with "Firewalls Read/Write" permissions

## Usage

1. **Deploy required CRD and Operator:**

   ```bash
   curl -s https://raw.githubusercontent.com/gangyi89/deploy-linode-operator/main/deploy-linode-fw-operator.sh | bash -s -- <MY_NAMESPACE>
   ```

   > **Note:** Specify the desired namespace for the operator. If not specified, the default namespace will be used.

2. **Deploy firewall object:**

   1. Copy the sample `cluster-firewall.yaml` file
   2. Populate the Firewall ID and Linode API Key
   3. Deploy the firewall object to the same namespace:

      ```bash
      kubectl apply -f cluster-firewall.yaml -n <MY_NAMESPACE>
      ```

## FAQ

### What does this operator do?

This operator automatically creates and removes worker node instances from a dedicated Linode Firewall based on the node events emitted by the Kubernetes cluster. When a node creation/removal is emitted, the operator reconciles the current list of nodes against the firewall device list and updates the firewall accordingly.

- Current design assumes a 1:1 relationship between a Cluster and a Firewall instance.
- It currently has no awareness of node pools and will treat all nodes the same.

*Note: Linode automatically removes a node from the firewall list when the node is deleted, hence the operator simply verifies and logs the delete activity.*

### Can I provision the operator as 2 replicas instead of the default single replica instance?

Yes, you can, but it's not necessary. In the event that the node containing the operator is removed, the operator will be rescheduled to another node and perform reconciliation at start-up.

### How do I secure my Linode API Key?

The operator is designed to consume the API Key from a Secret object. Hence, you can apply a consistent Kubernetes secrets management strategy to secure the API Key.

### Can it handle LKE cluster autoscale, upgrades, recycle pool, and delete pool?

Yes! To the operator, the above operations are nothing but create and delete node events. The operator will handle all of these scenarios.

#### What happens when a node instance is manually removed from the Linode Firewall Device List?
The node will only be added in when the next reconciliation is triggered. Either due to a node addition or deletion detected by the cluster or after 10hr (default operator reconcile interval).
