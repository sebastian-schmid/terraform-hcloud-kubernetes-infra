# hetzner cloud kubernetes infrastructure

This terraform module provisions servers with private network and a loadbalancer on hetzner cloud. It will also install ansible dependencies to make sure you can run ansible playbooks right after infrastructure provisioning.

## Quick Start

Following minimal config will provision one control plane node (cx11) and one worker node (cx11) and one load balancer (lb11) by default which will cost you about 12€ per month if you let it run:

```terraform
module "hcloud" {
  source = "git::https://gitlab.com/sebastian-terraform-modules/hcloud-kubernetes-infra"

  ssh_private_key = "~/.ssh/id_rsa"
  ssh_public_key  = "~/.ssh/id_rsa.pub"
}
```

## Common Customization

Following example config shows some available variables which can be customized to your needs:

```terraform
module "hcloud" {
  source = "git::https://gitlab.com/sebastian-terraform-modules/hcloud-kubernetes-infra"

  ssh_private_key = "~/.ssh/id_rsa"
  ssh_public_key  = "~/.ssh/id_rsa.pub"
  ssh_public_key_name = "default-key"

  # number of nodes of each type
  control_plane_nodes = 1
  worker_nodes = 2

  # hcloud location to provision ressources in
  hcloud_location = "nbg1"

  # OS image for all nodes
  node_image = "debian-10"

  # Name prefix for control plane nodes
  control_plane_node_name = "control-plane"

  # Server type of control plane node
  control_plane_node_server_type = "cx11"

  # Name prefix for worker nodes
  worker_node_name = "worker"

  # Server type of worker node
  worker_node_server_type = "cx11"

  # Private network name
  private_network_name = "private-network"

  # CIDR of private network
  privat_ip_range = "10.10.0.0/16"

  # Name for the load balancer
  load_balancer_name = "load-balancer"

  # Load balancer type
  load_balancer_type = "lb11"

  # ansible related variables
  install_ansible_dependencies = true
  ansible_dependencies_install_command = "sudo apt install -y python3"
}
```

## All available variables

You can find all available variables in variables.tf.
