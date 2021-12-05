data "openstack_compute_flavor_v2" "master" {
  name = var.master_flavor_name
}

data "openstack_images_image_v2" "master" {
  name        = var.master_image_name
  most_recent = true
}

resource "openstack_compute_instance_v2" "master" {
  count     = var.number_of_masters
  name      = "${var.cluster_name}-master-${count.index + 1}"
  flavor_id = data.openstack_compute_flavor_v2.master.id
  key_pair  = openstack_compute_keypair_v2.bastion.name
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
  instance_id = openstack_compute_instance_v2.master[count.index].id
}