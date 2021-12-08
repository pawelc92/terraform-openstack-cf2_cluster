# CF2 Cluster

This Terraform module deploys a cluster of masters and nodes prepared for the installation and configuration of kubernetes.

## Example Usage

### Cluster of one master and three nodes with one bastion host

```hcl
module "cf2_cluster" {
  source = "pawelc92/cf2_cluster/openstack"

  cluster_name          = "cf2-cluster"
  cluster_vnet_name     = "private_network"
  ssh_key_name          = "my_ssh"
  external_network_name = "external3"

  number_of_bastions  = 1
  bastion_flavor_name = "eo1.xsmall"
  bastion_image_name  = "Ubuntu 18.04 LTS"
  bastion_volume_size = 0

  number_of_masters       = 1
  master_flavor_name      = "eo1.small"
  master_image_name       = "Ubuntu 18.04 LTS"
  master_volume_size      = 0
  master_with_floating_ip = false

  number_of_nodes       = 3
  node_flavor_name      = "eo1.small"
  node_image_name       = "Ubuntu 18.04 LTS"
  node_volume_size      = 0
  node_with_floating_ip = false
  node_with_eodata      = false
}

output "cf2_cluster" {
  value = module.cf2_cluster.*
}
```