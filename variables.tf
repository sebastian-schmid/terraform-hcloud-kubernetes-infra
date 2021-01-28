# required variables

variable "ssh_private_key" {
  type = string
  description = "Path to your private ssh key file."
}
variable "ssh_public_key" {
  type = string
  description = "Path to your public ssh key file."
}

# optional variables

variable "control_plane_nodes" {
  type = number
  description = "Number of control plane nodes."
  default = 1
}
variable "worker_nodes" {
  type = number
  description = "Number of worker nodes."
  default = 1
}
variable "hcloud_location" {
  type = string
  description = "hcloud location (https://docs.hetzner.cloud/#locations) for the deployment of ressources."
  default = "nbg1"
}
variable "node_image" {
  type = string
  description = "Name of OS image for the servers."
  default = "debian-10"
}
variable "node_backup" {
  type = bool
  description = "Enable or disable backup feature for servers."
  default = false
}
variable "node_keep_disk" {
  type = bool
  description = "If enabled keeps the disk on server upgrade."
  default = false
}
variable "control_plane_node_name" {
  type = string
  description = "Name of the control plane node."
  default = "control-plane"  
}
variable "control_plane_node_server_type" {
  type = string
  description = "Server type (https://docs.hetzner.cloud/#servers-create-a-server) of control plane node."
  default = "cx11"
}
variable "worker_node_name" {
  type = string
  description = "Name of the worker node."
  default = "worker"  
}
variable "worker_node_server_type" {
  type = string
  description = "Server type (https://docs.hetzner.cloud/#servers-create-a-server) of control plane node."
  default = "cx11"
}
variable "ssh_public_key_name" {
  type = string
  description = "Name for your public ssh key that will be used in hcloud."
  default = "default-key"
}
variable "private_network_name" {
  type = string
  description = "The name of the private network."
  default = "private-network"
}
variable "private_ip_range" {
  type = string
  description = "IPv4 range (e.g. 10.0.0.0/16) of RFC1918 of the private network. Minimum size /24, recommended /16"
  default = "10.10.0.0/16"
}
variable "private_network_zone" {
  type = string
  description = "The zone in which the private network will be located in."
  default = "eu-central"
}
variable "load_balancer_name" {
  type = string
  description = "Name of the load balancer."
  default = "load-balancer"
}
variable "load_balancer_type" {
  type = string
  description = "Type (https://docs.hetzner.cloud/#load-balancer-types) of the Loadbalancer."
  default = "lb11"
}
