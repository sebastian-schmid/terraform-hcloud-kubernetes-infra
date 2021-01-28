# display control plane IPs
output "control_plane_public_ipv4" {
  value = {
    for control_plane in hcloud_server.control_plane :
    control_plane.name => control_plane.ipv4_address
  }
  description = "Show public IPv4 addresses of all control plane nodes."
}
output "control_plane_private_ipv4" {
  value = {
    for control_plane in hcloud_server.control_plane :
    control_plane.name => control_plane.network.*.ip
  }
  description = "Show private IPv4 addresses of all control plane nodes."
}
output "control_plane_public_ipv6" {
  value = {
    for control_plane in hcloud_server.control_plane :
    control_plane.name => control_plane.ipv6_address
  }
  description = "Show public IPv6 addresses of all control plane nodes."
}

# display worker IPs
output "worker_public_ipv4" {
  value = {
    for worker in hcloud_server.worker :
    worker.name => worker.ipv4_address
  }
  description = "Show public IPv4 addresses of all worker nodes."
}
output "worker_private_ipv4" {
  value = {
    for worker in hcloud_server.worker :
    worker.name => worker.network.*.ip
  }
  description = "Show private IPv4 addresses of all worker nodes."
}
output "worker_public_ipv6" {
  value = {
    for worker in hcloud_server.worker :
    worker.name => worker.ipv6_address
  }
  description = "Show public IPv6 addresses of all worker nodes."
}

# display load balancer IPs
output "load_balancer_public_ipv4" {
  value = hcloud_load_balancer.load_balancer.ipv4
  description = "Show public IPv4 address of the load balancer."
}
output "load_balancer_public_ipv6" {
  value = hcloud_load_balancer.load_balancer.ipv6
  description = "Show public IPv6 address of the load balancer."
}
