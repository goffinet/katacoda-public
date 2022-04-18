## Action 1: Ping

Ping all hosts : `for x in {0..2} ; do ping -c1 node$x ; done`{{execute}}

## Action 2: Ansible inventory

Look at the default **inventory** : `cat /etc/ansible/hosts`{{execute}}

## Action 3: Ansible configuration

Look at the default **configuration file** : `cat /etc/ansible/ansible.cfg`{{execute}}

## Action 4: Ansible binary

Execute Ansible on all hosts with the `ping` module : `ansible -m ping all`{{execute}}
