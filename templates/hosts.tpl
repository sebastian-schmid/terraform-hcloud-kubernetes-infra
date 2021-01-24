[control_plane_nodes]
%{ for server in control_plane_nodes ~}
${server.name} ansible_host=${server.ipv4_address}
%{ endfor ~}

[worker_nodes]
%{ for server in worker_nodes ~}
${server.name} ansible_host=${server.ipv4_address}
%{ endfor ~}