[domain_controllers]
%{ for idx, name in domain_controller_hostnames } ${name}     ansible_host=${domain_controller_ips[idx]}
%{ endfor }

[all:vars]
ansible_ssh_user=${ciuser}
ansible_ssh_password=${cipassword}
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
ansible_shell_type=powershell