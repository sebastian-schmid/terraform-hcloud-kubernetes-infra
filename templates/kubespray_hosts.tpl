# ## Configure 'ip' variable to bind kubernetes services on a
# ## different ip than the default iface
# ## We should set etcd_member_name for etcd cluster. The node that is not a etcd member do not need to set the value, or can set the empty string value.
[all]
%{ for server in control_plane_nodes ~}
${server.name} ansible_host=${server.ipv4_address} ip=${element(server.network.*.ip, 0)} etcd_member_name=etcd-${index(control_plane_nodes, server)}
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

[calico-rr]

[k8s-cluster:children]
kube-master
kube-node
calico-rr
