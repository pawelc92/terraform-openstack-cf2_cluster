output "bastion" {
  value = toset([
    for bastion in openstack_compute_instance_v2.bastion : tomap({
        "name" = bastion.name,
        "id"   = bastion.id
    })
  ])
}

output "master" {
  value = toset([
    for master in openstack_compute_instance_v2.master : tomap({
        "name" = master.name,
        "id"   = master.id
    })
  ])
}

output "node" {
  value = toset([
    for node in openstack_compute_instance_v2.node : tomap({
        "name" = node.name,
        "id"   = node.id
    })
  ])
}