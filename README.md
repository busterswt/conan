# Netplanner

Proof of concept playbooks and roles to take a simple inventory and generate
a larger inventory that can be leveraged by the ansible-netplan role.

Network configuration can be applied via ansible once a machine is bootstrapped
with bifrost.

## installation

The installation process consists of cloning the 'netplanner' repo and
bringing in a dependency repo: ansible-netplan.

```
git clone https://github.com/busterswt/netplanner/ ~/netplanner
git clone https://github.com/mrlesmithjr/ansible-netplan ~/netplanner/roles/ansible-netplan
```

## inventory

A simple inventory (`simple_inventory`) should be maintained that
contains relevant interface names and IP addresses, routes, etc
to be applied. 

```
---
all:
  hosts:
    935811-controller01-ospcv2-dfw.ohthree.com:
      addresses:
        eno2: [ 192.168.192.16/25 ]
        host: [ 172.28.1.1/24 ]
        mgmt: [ 172.28.2.1/24 ]
        overlay: [ 172.28.3.1/24 ]
      routes:
        eno2:
        - to: 192.168.192.192/26
          via: 192.168.193.1
        br-host:
        - to: default
          via: 172.29.232.1
    935812-controller02-ospcv2-dfw.ohthree.com:
      addresses:
        eno2: [ 192.168.192.17/25 ]
        host: [ 172.28.1.2/24 ]
        mgmt: [ 172.28.2.2/24 ]
        overlay: [ 172.28.3.2/24 ]
      routes:
        eno2:
        - to: 192.168.192.192/26
          via: 192.168.193.1
        br-host:
        - to: default
          via: 172.29.232.1
```

## overrides

Most of the network configuration assumes a homogenous environment, and
those network values can be defined in the `overrides.yml` file. Any
*host specific* changes can be implemented in the respective host_vars
file.

## usage

To apply network configurations to hosts in the inventory, run the following:

```
ansible-playbook -i simple_inventory site.yml -e @overrides.yml
```

## todo (notes to myself)

- Remove existing netplan configuration file(s) before performing `netplan apply`
