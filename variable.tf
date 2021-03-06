variable "cluster_name" {
  type = string
  description = "The name which is used as resource name prefix."
}

variable "cluster_vnet_name" {
  type = string
  description = "The name of the network."
}

# Bastion
variable "number_of_bastions" {
  type    = number
  description = "A number of bastion hosts."
}
variable "bastion_flavor_name" {
  type    = string
  default = "eo1.xsmall"
  description = "The name of the desired flavor for the bastion host."
}
variable "bastion_image_name" {
  type = string
  description = "The name of the desired image for the bastion host."
}
variable "bastion_volume_size" {
  type    = number
  default = 0
  description = "The size of the bastion volume to create (in gigabytes). Leave 0 to create an instance with a cache volume with the default size for flavor."
}
variable "bastion_ssh_key" {
  type = string
  description = "The name of the ssh key to be added to bastion host."
}

# Master
variable "number_of_masters" {
  type = number
  description = "A number of masters."

  validation {
    condition     = var.number_of_masters > 0
    error_message = "A number of masters must be greater than 0."
  }
}
variable "master_flavor_name" {
  type    = string
  default = "eo1.small"
  description = "The name of the desired flavor for the master."
}
variable "master_image_name" {
  type = string
  description = "The name of the desired image for the master."
}
variable "master_volume_size" {
  type    = number
  default = 0
  description = "The size of the master volume to create (in gigabytes). Leave 0 to create an instance with a cache volume with the default size for flavor."
}
variable "master_with_floating_ip" {
  type = bool
  description = "Set true to associate floating IP addresses to masters."
}
variable "master_ssh_key" {
  type = string
  description = "The name of the ssh key to be added to master."
}

# Node
variable "number_of_nodes" {
  type = number
  description = "A number of nodes."

  validation {
    condition     = var.number_of_nodes > 0
    error_message = "A number of nodes must be greater than 0."
  }
}
variable "node_flavor_name" {
  type    = string
  default = "eo1.small"
  description = "The name of the desired flavor for the node."
}
variable "node_image_name" {
  type = string
  description = "The name of the desired image for the node."
}
variable "node_volume_size" {
  type    = number
  default = 0
  description = "The size of the node volume to create (in gigabytes). Leave 0 to create an instance with a cache volume with the default size for flavor."
}
variable "node_with_floating_ip" {
  type = bool
  description = "Set true to associate floating IP addresses to nodes."
}
variable "node_ssh_key" {
  type = string
  description = "The name of the ssh key to be added to node."
}
variable "node_with_eodata" {
  type = bool
  description = "Set true to attach eodata network to nodes."
}

# Network
variable "external_network_name" {
  type = string
  description = "The name of the pool from which to obtain the floating IP."
}
