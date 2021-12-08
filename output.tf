output "bastion" {
  value = toset([
    for bastion in (var.bastion_volume_size > 0 ? openstack_compute_instance_v2.bastion_with_volume : openstack_compute_instance_v2.bastion) : tomap({
        "name" = bastion.name,
        "id"   = bastion.id
    })
  ])
}

output "master" {
  value = toset([
    for master in (var.master_volume_size > 0 ? openstack_compute_instance_v2.master_with_volume : openstack_compute_instance_v2.master) : tomap({
        "name" = master.name,
        "id"   = master.id
    })
  ])
}

output "node" {
  value = toset([
    for node in (var.node_volume_size > 0 ? openstack_compute_instance_v2.node_with_volume : openstack_compute_instance_v2.node) : tomap({
        "name" = node.name,
        "id"   = node.id
    })
  ])
}