# add ssh key to hcloud project to connect to nodes later on
resource "hcloud_ssh_key" "default" {
  name       = var.ssh_public_key_name
  public_key = file(var.ssh_public_key)
}

# create private network
resource "hcloud_network" "default" {
  name     = var.private_network_name
  ip_range = var.private_ip_range
}

# create subnet
resource "hcloud_network_subnet" "default" {
  network_id   = hcloud_network.default.id
  type         = "cloud"
  network_zone = var.private_network_zone
  ip_range     = var.private_ip_range
}

# create load balancer
resource "hcloud_load_balancer" "load_balancer" {
  name               = var.load_balancer_name
  load_balancer_type = var.load_balancer_type
  location           = var.hcloud_location
}

# add load balancer to subnet
resource "hcloud_load_balancer_network" "lbnetwork" {
  load_balancer_id        = hcloud_load_balancer.load_balancer.id
  subnet_id               = hcloud_network_subnet.default.id
  enable_public_interface = true
}

# provision control plane nodes
resource "hcloud_server" "control_plane" {
  count = control_plane_nodes
  
  name        = "${control_plane_node_name}-${count.index}"
  image       = node_image
  server_type = control_plane_node_server_type
  location    = hcloud_location
  backups     = node_backup
  keep_disk   = node_keep_disk
  ssh_keys    = ssh_public_key_name

  provisioner "remote-exec" {
    inline = [var.install_ansible_dependencies ? var.ansible_dependencies_install_command : "sleep 0"]

    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = "root"
      private_key = file(var.ssh_private_key)
    }
  }
}

# provision worker nodes
resource "hcloud_server" "worker" {
  count = worker_nodes
  
  name        = "${worker_node_name}-${count.index}"
  image       = node_image
  server_type = worker_node_server_type
  location    = hcloud_location
  backups     = node_backup
  keep_disk   = node_keep_disk
  ssh_keys    = ssh_public_key_name

  provisioner "remote-exec" {
    inline = [var.install_ansible_dependencies ? var.ansible_dependencies_install_command : "sleep 0"]

    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = "root"
      private_key = file(var.ssh_private_key)
    }
  }
}

# connect control plane nodes to private network
resource "hcloud_server_network" "control_plane_server_network" {
  for_each = var.control_plane_nodes

  network_id = hcloud_network.default.id
  server_id  = hcloud_server.control_plane[each.key].id
  ip         = each.value.private_ip_address
}

# connect worker nodes to private network
resource "hcloud_server_network" "worker_server_network" {
  for_each = var.worker_nodes

  network_id = hcloud_network.default.id
  server_id  = hcloud_server.worker[each.key].id
  ip         = each.value.private_ip_address
}

# generate inventory file for ansible
resource "local_file" "hosts" {
  content = templatefile("${path.module}/templates/hosts.tpl",
    {
      control_plane_nodes = hcloud_server.control_plane
      worker_nodes = hcloud_server.worker
    }
  )
  filename = "./ansible/inventory/hosts"
}
