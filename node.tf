data "openstack_compute_flavor_v2" "node" {
  name = var.node_flavor_name
}

data "openstack_images_image_v2" "node" {
  name        = var.node_image_name
  most_recent = true
}

data "openstack_networking_network_v2" "eodata" {
  name = "eodata"
}

resource "openstack_compute_instance_v2" "node" {
  count     = var.node_volume_size > 0 ? 0 : var.number_of_nodes
  name      = "${var.cluster_name}-node-${count.index + 1}"
  flavor_id = data.openstack_compute_flavor_v2.node.id
  image_id  = data.openstack_images_image_v2.node.id
  key_pair  = openstack_compute_keypair_v2.bastion.name
  security_groups = [
    "default",
    openstack_networking_secgroup_v2.internal.name
  ]

  network {
    name = var.cluster_vnet_name
  }

  lifecycle {
    ignore_changes = [
      image_id
    ]
  }
}

resource "openstack_compute_instance_v2" "node_with_volume" {
  count     = var.node_volume_size > 0 ? var.number_of_nodes : 0
  name      = "${var.cluster_name}-node-${count.index + 1}"
  flavor_id = data.openstack_compute_flavor_v2.node.id
  key_pair  = openstack_compute_keypair_v2.bastion.name
  security_groups = [
    "default",
    openstack_networking_secgroup_v2.internal.name
  ]

  block_device {
    uuid                  = data.openstack_images_image_v2.node.id
    source_type           = "image"
    boot_index            = 0
    destination_type      = "volume"
    volume_size           = var.node_volume_size
    delete_on_termination = true
  }

  network {
    name = var.cluster_vnet_name
  }

  lifecycle {
    ignore_changes = [
      block_device[0].uuid
    ]
  }
}
# ?
resource "openstack_networking_floatingip_v2" "node" {
  count = var.node_with_floating_ip ? var.number_of_nodes : 0
  pool  = var.external_network_name
}

resource "openstack_compute_floatingip_associate_v2" "node" {
  count       = var.node_with_floating_ip ? var.number_of_nodes : 0
  floating_ip = openstack_networking_floatingip_v2.node[count.index].address
  instance_id = var.node_volume_size > 0 ? openstack_compute_instance_v2.node_with_volume[count.index].id : openstack_compute_instance_v2.node[count.index].id
}

resource "openstack_compute_interface_attach_v2" "eodata" {
  count       = var.node_with_eodata ? var.number_of_nodes : 0
  instance_id = var.node_volume_size > 0 ? openstack_compute_instance_v2.node_with_volume[count.index].id : openstack_compute_instance_v2.node[count.index].id
  network_id  = data.openstack_networking_network_v2.eodata.id
}