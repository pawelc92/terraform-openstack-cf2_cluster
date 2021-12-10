data "openstack_compute_flavor_v2" "bastion" {
  name = var.bastion_flavor_name
}

data "openstack_images_image_v2" "bastion" {
  name        = var.bastion_image_name
  most_recent = true
}

resource "openstack_compute_instance_v2" "bastion" {
  count     = var.bastion_volume_size > 0 ? 0 : var.number_of_bastions
  name      = "${var.cluster_name}-bastion-${count.index + 1}"
  flavor_id = data.openstack_compute_flavor_v2.bastion.id
  image_id  = data.openstack_images_image_v2.bastion.id
  key_pair  = var.bastion_ssh_key
  security_groups = [
    "default",
    "allow_ping_ssh_rdp",
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

resource "openstack_compute_instance_v2" "bastion_with_volume" {
  count     = var.bastion_volume_size > 0 ? var.number_of_bastions : 0
  name      = "${var.cluster_name}-bastion-${count.index + 1}"
  flavor_id = data.openstack_compute_flavor_v2.bastion.id
  key_pair  = var.bastion_ssh_key
  security_groups = [
    "default",
    "allow_ping_ssh_rdp",
    openstack_networking_secgroup_v2.internal.name
  ]

  block_device {
    uuid                  = data.openstack_images_image_v2.bastion.id
    source_type           = "image"
    boot_index            = 0
    destination_type      = "volume"
    volume_size           = var.bastion_volume_size
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

resource "openstack_networking_floatingip_v2" "bastion" {
  count = var.number_of_bastions
  pool  = var.external_network_name
}

resource "openstack_compute_floatingip_associate_v2" "bastion" {
  count       = var.number_of_bastions
  floating_ip = openstack_networking_floatingip_v2.bastion[count.index].address
  instance_id = var.bastion_volume_size > 0 ? openstack_compute_instance_v2.bastion_with_volume[count.index].id : openstack_compute_instance_v2.bastion[count.index].id
}