# display control plane IPs
output "control_plane_ipv4" {
  value = {
    for control_plane in hcloud_server.control_plane :
    control_plane.name => control_plane.ipv4_address
  }
}
output "control_plane_ipv6" {
  value = {
    for control_plane in hcloud_server.control_plane :
    control_plane.name => control_plane.ipv6_address
  }
}

# display worker IPs
output "worker_ipv4" {
  value = {
    for worker in hcloud_server.worker :
    worker.name => worker.ipv4_address
  }
}
output "worker_ipv6" {
  value = {
    for worker in hcloud_server.worker :
    worker.name => worker.ipv6_address
  }
}

# display load balancer IPs
output "load_balancer_ipv4" {
  value = {
    for load_balancer in hcloud_load_balancer.load_balancer :
    load_balancer.name => load_balancer.ipv4
  }
}
output "load_balancer_ipv6" {
  value = {
    for load_balancer in hcloud_load_balancer.load_balancer :
    load_balancer.name => load_balancer.ipv6
  }
}