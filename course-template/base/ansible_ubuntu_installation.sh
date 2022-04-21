#! /bin/bash

apt update
add-apt-repository --yes --update ppa:ansible/ansible
apt install -y ansible
