data "openstack_compute_flavor_v2" "master" {
  name = var.master_flavor_name
}

data "openstack_images_image_v2" "master" {
  name        = var.master_image_name
  most_recent = true
}

resource "openstack_compute_instance_v2" "master" {
  count     = var.master_volume_size > 0 ? 0 : var.number_of_masters
  name      = "${var.cluster_name}-master-${count.index + 1}"
  flavor_id = data.openstack_compute_flavor_v2.master.id
  image_id  = data.openstack_images_image_v2.master.id
  key_pair  = var.master_ssh_key
  security_groups = [
    "default",
    openstack_networking_secgroup_v2.internal.name
  ]

  network {
    name = var.cluster_vnet_name
  }

  tags = [
    "master",
    var.cluster_name
  ]

  lifecycle {
    ignore_changes = [
      image_id
    ]
  }
}

resource "openstack_compute_instance_v2" "master_with_volume" {
  count     = var.master_volume_size > 0 ? var.number_of_masters : 0
  name      = "${var.cluster_name}-master-${count.index + 1}"
  flavor_id = data.openstack_compute_flavor_v2.master.id
  key_pair  = var.master_ssh_key
  security_groups = [
    "default",
    openstack_networking_secgroup_v2.internal.name
  ]

  block_device {
    uuid                  = data.openstack_images_image_v2.master.id
    source_type           = "image"
    boot_index            = 0
    destination_type      = "volume"
    volume_size           = var.master_volume_size
    delete_on_termination = true
  }

  network {
    name = var.cluster_vnet_name
  }

  tags = [
    "master",
    var.cluster_name
  ]

  lifecycle {
    ignore_changes = [
      block_device[0].uuid
    ]
  }
}

resource "openstack_networking_floatingip_v2" "master" {
  count = var.master_with_floating_ip ? var.number_of_masters : 0
  pool  = var.external_network_name
}

resource "openstack_compute_floatingip_associate_v2" "master" {
  count       = var.master_with_floating_ip ? var.number_of_masters : 0
  floating_ip = openstack_networking_floatingip_v2.master[count.index].address
  instance_id = var.node_volume_size > 0 ? openstack_compute_instance_v2.master_with_volume[count.index].id : openstack_compute_instance_v2.master[count.index].id
}