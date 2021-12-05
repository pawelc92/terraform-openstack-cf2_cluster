resource "openstack_networking_secgroup_v2" "internal" {
  name        = "${var.cluster_name}_internal"
  description = "Cluster internal security group"
}

resource "openstack_networking_secgroup_rule_v2" "internal" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_group_id   = openstack_networking_secgroup_v2.internal.id
  security_group_id = openstack_networking_secgroup_v2.internal.id
}

resource "openstack_compute_keypair_v2" "bastion" {
  name = "${var.cluster_name}-key"
}