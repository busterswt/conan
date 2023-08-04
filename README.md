# Netplanner

Proof of concept playbooks and roles to take a simple inventory and generate
a larger inventory that can be leveraged by the ansible-netplan role.

Network configuration can be applied via ansible once a machine is bootstrapped
with bifrost.

## installation

The installation process consists of cloning the 'netplanner' repo and
bringing in a dependency repo: ansible-netplan.

git clone https://github.com/busterswt/netplanner/ ~/netplanner
git clone https://github.com/mrlesmithjr/ansible-netplan ~/netplanner/roles/ansible-netplan

## todo (notes to myself)

- Remove existing netplan configuration file(s) before performing `netplan apply`
