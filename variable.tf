# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
# variable "name_prefix" {
#   type        = string
#   default     = "k8s-lab"
#   description = "Name of project and prefix for resource names"
# }

variable "cluster_name" {
  type = string
}

variable "cluster_vnet_name" {
  type = string
}

variable "ssh_key_name" {
  type = string
}

# Bastion
variable "number_of_bastions" {
  type    = number
  default = 1
}
variable "bastion_flavor_name" {
  type    = string
  default = "eo1.xsmall"
}
variable "bastion_image_name" {
  type = string
}
variable "bastion_volume_size" {
  type    = number
  default = 10
}

# Master
variable "number_of_masters" {
  type = number
}
variable "master_flavor_name" {
  type    = string
  default = "eo1.small"
}
variable "master_image_name" {
  type = string
}
variable "master_volume_size" {
  type    = number
  default = 10
}
variable "master_with_floating_ip" {
  type = bool
}

# Node
variable "number_of_nodes" {
  type = number
}
variable "node_flavor_name" {
  type    = string
  default = "eo1.small"
}
variable "node_image_name" {
  type = string
}
variable "node_volume_size" {
  type    = number
  default = 10
}
variable "node_with_floating_ip" {
  type = bool
}
variable "node_with_eodata" {
  type = bool
}

# Network
variable "external_network_name" {
  type = string
}