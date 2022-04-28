[all:vars]
ansible_host_key_checking=False
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
ansible_connection=ssh
ansible_user=ec2-user

[master]
%{ for masterIp in master ~}
locust-master ansible_ssh_host=${masterIp}
%{ endfor ~}

[nodes]
%{ for nodeIp in nodes ~}
locust-node1 ansible_ssh_host=${nodeIp}
%{ endfor ~}





