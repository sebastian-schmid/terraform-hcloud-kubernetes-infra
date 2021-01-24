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
  
  depends_on = [
    hcloud_network_subnet.default
  ]
}

# provision control plane nodes
resource "hcloud_server" "control_plane" {
  count = var.control_plane_nodes
  
  name        = "${var.control_plane_node_name}-${count.index}"
  image       = var.node_image
  server_type = var.control_plane_node_server_type
  location    = var.hcloud_location
  backups     = var.node_backup
  keep_disk   = var.node_keep_disk
  ssh_keys    = [var.ssh_public_key_name]

  network {
    network_id = hcloud_network.default.id
  }

  provisioner "remote-exec" {
    inline = [var.install_ansible_dependencies ? var.ansible_dependencies_install_command : "sleep 0"]

    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = "root"
      private_key = file(var.ssh_private_key)
    }
  }
  
  depends_on = [
    hcloud_network_subnet.default
  ]
}

# provision worker nodes
resource "hcloud_server" "worker" {
  count = var.worker_nodes
  
  name        = "${var.worker_node_name}-${count.index}"
  image       = var.node_image
  server_type = var.worker_node_server_type
  location    = var.hcloud_location
  backups     = var.node_backup
  keep_disk   = var.node_keep_disk
  ssh_keys    = [var.ssh_public_key_name]

  network {
    network_id = hcloud_network.default.id
  }

  provisioner "remote-exec" {
    inline = [var.install_ansible_dependencies ? var.ansible_dependencies_install_command : "sleep 0"]

    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = "root"
      private_key = file(var.ssh_private_key)
    }
  }

  depends_on = [
    hcloud_network_subnet.default
  ]
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
