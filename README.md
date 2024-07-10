# Deploy Linode Firewall Operator

This repository contains a script to deploy the Linode Firewall Operator to a specified Kubernetes namespace.

---

## Prerequisites

1. Linode Kubernetes Cluster
2. Dedicated Linode Firewall for the cluster
   - The firewall should only be used for the cluster
   - Operator will compare the worker nodes against the firewall device list and remove any devices that are not cluster nodes
3. Linode PAT Token with "Firewalls Read/Write" permissions

---

## Usage

1. Deploy required CRD and Operator:

   ```bash
   curl -s https://raw.githubusercontent.com/gangyi89/deploy-linode-operator/main/deploy-linode-fw-operator.sh | bash -s -- <MY_NAMESPACE>
   ```

   > Note: Specify the desired namespace for the operator. If not specified, the default namespace will be used.

2. Deploy firewall object:

   a. Copy the sample `cluster-firewall.yaml` file
   b. Populate the Firewall ID and Linode API Key
   c. Deploy the firewall object to the same namespace:

   ```bash
   kubectl apply -f cluster-firewall.yaml -n <MY_NAMESPACE>
   ```
---

# Q&A:

1. **What does this operator do?**
This operator automatically creates and remove worker node instances from a dedicated Linode Firewall based on the node events emmitted by the kubernetes cluster. When a node creation / removal is emmited, the operator reconciles the current list of nodes against the firewall device list and updates the firewall accordingly.
    - Current design assumes a 1 : 1 relationship between a Cluster and a Firewall instance.
    - It current has no awareness of node pool, and will treat all nodes as the same.

2. **Can I provision the operator as 2 replica instead of the default single replica instance**
Yes you can, but its really not neccessary. In the event if the node containing the operator is removed, the operator will be rescheduled to another node and performs reconciliation at start-up.

3. **How do I secure my Linode API Key?**
The operator is designed to consume the API Key from a Secret object. Hence you can apply a consistent kubernetes secrets management strategy to secure the API Key.

1. **Can it handle LKE cluster autoscale, upgrades, recycle pool and delete pool?**
Of course! To the operator, the above operations are nothing but create and delete node events. The operator will handle all of the above.
