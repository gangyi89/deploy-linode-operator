# Deploy Linode Firewall Operator

This repository provides an easy way to deploy Linode Firewall Operator into a kubernetes cluster.
The operator contains 2 features:
1. Cluster Firewall - A dedicated firewall for the cluster. Operator listens to cluster events and dynamically add worker nodes to the designated fireweall instance.
2. External Firewall - A firewall that is protecting a resource that needs to be accessed by the cluster. Operator listens to cluster events and dynamically add worker nodes to the external firewall instance.

# Version History

THe following versioning is aligned with the docker [image](https://hub.docker.com/repository/docker/gangyi89/linode-firewall-operator/general) versioning.
- v1.0.0 - Initial release, contains cluster firewall.
- v2.0.0 - Add support for external firewall.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [FAQ](#faq)
- [Troubleshooting Guide](#troubleshooting-guide)
- [Remarks](#remarks)

## Prerequisites

1. Linode Kubernetes Cluster
   - Have outbound connectivity to https://api.linode.com
2. Linode Firewall ID
3. Linode PAT Token with "Firewalls Read/Write" permissions

## Quick Start

1. **Deploy required CRD and Operator:**

   ```bash
   curl -s https://raw.githubusercontent.com/gangyi89/deploy-linode-operator/main/deploy-linode-fw-operator.sh | bash -s -- <MY_NAMESPACE>
   ```

   > **Note:** Specify the desired namespace for the operator. If not specified, the default namespace will be used.

## Usage

### Cluster Firewall

 **Copy firewall object:**

   1. Copy the `cluster-firewall.yaml` file in samples folder
   2. Populate the Firewall ID and Linode API Key
   3. Deploy the firewall object to the same namespace:

      ```bash
      kubectl apply -f cluster-firewall.yaml -n <MY_NAMESPACE>
      ```
### External Firewall

 **Copy firewall object:**

   1. Copy the sample `external-firewall.yaml` file in samples folder
   2. Populate the Firewall ID and Linode API Key
   3. Populate the rules (sample included)
   4. Deploy the firewall object to the same namespace:

      ```bash
      kubectl apply -f external-firewall.yaml -n <MY_NAMESPACE>
      ```


## FAQ

#### What does this operator do?

This operator automatically creates and removes worker node instances from a dedicated Linode Firewall based on the node events emitted by the Kubernetes cluster. When a node creation/removal is emitted, the operator reconciles the current list of nodes against the firewall device list and updates the firewall accordingly.

** Cluster Firewall **
- Current design assumes a 1:1 relationship between a Cluster and a Firewall instance.
- The firewall should only be used for the cluster. Operator will compare the worker nodes against the firewall device list and remove any devices that are not cluster nodes.
- It currently has no awareness of node pools and will treat all nodes the same.

** External Firewall **
- Include comments here
  

*Note: Linode automatically removes a node from the firewall list when the node is deleted, hence the operator simply verifies and logs the delete activity.*

<p align="center">
  <img src="https://linode-operator.ap-south-1.linodeobjects.com/architecture.jpg" alt="Linode Firewall Operator Architecture" width="800">
</p>

#### What are the parameters available in the cluster firewall?
| Parameter | Type | Mandatory | Description |
|----------|----------|----------|----------|
| firewallId | int | Y | Dedicated FirewallId for the cluster |
| apiKeySecret.name | string | Y | Name of kubernetes Secret |
| apiKeySecret.key | string | Y | Key of kubernetes Secret |
| apiKeySecret.namespace | string | N | If namespace is not specifed, namespace of the operator will be used |
| interval | string | N | Periodically performs reconciliation on top of node events. Format is in s, m, h, d. Default is 10h |

#### What are the parameters available in the external firewall?
| Parameter | Type | Mandatory | Description |
|----------|----------|----------|----------|
| firewallId | int | Y | Dedicated FirewallId for the cluster |
| apiKeySecret.name | string | Y | Name of kubernetes Secret |
| apiKeySecret.key | string | Y | Key of kubernetes Secret |
| apiKeySecret.namespace | string | N | If namespace is not specifed, namespace of the operator will be used |
| interval | string | N | Periodically performs reconciliation on top of node events. Format is in s, m, h, d. Default is 10h |


#### Can I provision the operator as 2 replicas instead of the default single replica instance?

Yes, you can, but it's not necessary. In the event that the node containing the operator is removed, the operator will be rescheduled to another node and perform reconciliation at start-up.

#### How do I secure my Linode API Key?

The operator is designed to consume the API Key from a Secret object. Hence, you can apply a consistent Kubernetes secrets management strategy to secure the API Key.

#### Can cluster firewall handle LKE cluster autoscale, upgrades, recycle pool, and delete pool?

Yes! To the operator, the above operations are nothing but create and delete node events. The operator will handle all of these scenarios.

#### What happens when a node instance is manually removed from the Linode Firewall Device List?
The node will only be added in when the next reconciliation is triggered. Either due to a node add/delete detected by the cluster or after 10hr (default operator reconcile interval).
Alternatively, specify the interval parameter to control the frequency of the reconciliation - on top of event triggered reconciliation.

## Troubleshooting Guide
This section discribe some of the places that can be looked into to identify issues with the operator.

1. Describe the cluster firewall object and verify the status and events:
```
kubectl describe clusterfirewall -n <MY_NAMESPACE>
```
<p align="center">
  <img src="https://linode-operator.ap-south-1.linodeobjects.com/describe.jpg" alt="Cluster Firewall Events" width="800">
</p>

   - Verify the status currently contains all the nodes in the cluster (no less and no more). The status is updated everytime reconcilation happens.
   - Look for any error messages under the events section. All errors are logged as events and can be used to debug the issue.

1. Check the logs of the operator pod:
```
kubectl logs linode-fw-operator-xxxxxxxx-xxxxx -n <MY_NAMESPACE>
```
<p align="center">
  <img src="https://linode-operator.ap-south-1.linodeobjects.com/logs.jpg" alt="Cluster Firewall Events" width="800">
</p>

Reconcilation Started and Reconcilation Completed depics 1 cycle of reconcilation. From there, you will be able to identify what time was the last run reconciliation and also identify any errors that might have occurred.

## Remarks
This project is of the work of an individual and is not affiliated with Linode in any way.