
Ping all hosts : `for x in {0..2} ; do ping -c1 node$x ; done`{{execute}}

Look at the default **inventory** : `cat /etc/ansible/hosts`{{execute}}

Look at the default **configuration file** : : `cat /etc/ansible/ansible.cfg`{{execute}}

Execute Ansible on all hosts with the `ping` module : `ansible -m ping all`{{execute}}
