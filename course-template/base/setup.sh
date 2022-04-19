#!/bin/bash

echo "++++ Update Ansible version"
sudo apt -qq update
sudo add-apt-repository --yes --update ppa:ansible/ansible &>/dev/null
sudo DEBIAN_FRONTEND=noninteractive apt install -qq ansible
docker network create lan
image=ghcr.io/goffinet/nodelab:master
echo "++++ Pull Docker image"
docker pull $image &>/dev/null
mkdir /share
ssh-keygen -b 4096 -t rsa -f /root/.ssh/id_rsa_ansible -q -N ""
cat /root/.ssh/id_rsa_ansible.pub > /share/authorized_keys
docker run --name node0 -v /share:/share --network lan --rm --privileged -d ${image}
node0=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' node0)
docker exec node0 /bin/bash -c 'cp -r /share/authorized_keys /home/user/.ssh/ ; chown user /home/user/.ssh/authorized_keys'
docker run --name node1 -v /share:/share --network lan --rm --privileged -d ${image}
node1=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' node1)
docker exec node1 /bin/bash -c 'cp -r /share/authorized_keys /home/user/.ssh/ ; chown user /home/user/.ssh/authorized_keys'
docker run --name node2 -v /share:/share --network lan --rm --privileged -d ${image}
node2=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' node2)
docker exec node2 /bin/bash -c 'cp -r /share/authorized_keys /home/user/.ssh/ ; chown user /home/user/.ssh/authorized_keys'
cat << EOF > /etc/ansible/hosts
node0 ansible_host=$node0
node1 ansible_host=$node1
node2 ansible_host=$node2
[all:vars]
ansible_ssh_user=user
ansible_become=true
ansible_connection=ssh
EOF
cat << EOF > /etc/ansible/ansible.cfg
[defaults]
inventory = /etc/ansible/hosts
host_key_checking = False
private_key_file = /root/.ssh/id_rsa_ansible
become = True
callback_whitelist = profile_tasks
[callback_profile_tasks ]
task_output_limit = 100
EOF
sudo su -c "echo $node0 node0 >> /etc/hosts"
sudo su -c "echo $node1 node1 >> /etc/hosts"
sudo su -c "echo $node2 node2 >> /etc/hosts"
clear
