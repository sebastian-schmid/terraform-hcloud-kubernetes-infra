## This hosts file is ready to use with https://kubespray.io
## Configure 'ip' variable to bind kubernetes services on a
## different ip than the default iface
[all]
%{ for server in control_plane_nodes ~}
${server.name} ansible_host=${server.ipv4_address} ip=${element(server.network.*.ip, 0)}
%{ endfor ~}
%{ for server in worker_nodes ~}
${server.name} ansible_host=${server.ipv4_address} ip=${element(server.network.*.ip, 0)}
%{ endfor ~}

[kube-master]
%{ for server in control_plane_nodes ~}
${server.name}
%{ endfor ~}

[etcd]
%{ for server in control_plane_nodes ~}
${server.name}
%{ endfor ~}

[kube-node]
%{ for server in worker_nodes ~}
${server.name}
%{ endfor ~}

[k8s-cluster:children]
kube-master
kube-node