# Security Groups

resource "openstack_networking_secgroup_v2" "secgrp-demo-dfw3" {
  provider    = openstack.dfw3
  name        = "secgrp-demo"
  description = "Security Group for Demo"
}

resource "openstack_networking_secgroup_v2" "secgrp-demo-ord1" {
  provider    = openstack.ord1
  name        = "decgrp-demo"
  description = "Security Group for Demo"
}

# Security Group Rules

resource "openstack_networking_secgroup_rule_v2" "all-icmp-dfw3" {
  provider  = openstack.dfw3
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "icmp"
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgrp-demo-dfw3.id}"
}

resource "openstack_networking_secgroup_rule_v2" "all-icmp-ord1" {
  provider  = openstack.ord1
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "icmp"
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgrp-demo-ord1.id}"
}

# VPN (delete)

resource "openstack_networking_secgroup_rule_v2" "all-udp-500-dfw3" {
  provider  = openstack.dfw3
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "udp"
  port_range_min = "500"
  port_range_max = "500"
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgrp-demo-dfw3.id}"
}

resource "openstack_networking_secgroup_rule_v2" "all-udp-500-ord1" {
  provider  = openstack.ord1
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "udp"
  port_range_min = "500"
  port_range_max = "500"
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgrp-demo-ord1.id}"
}

resource "openstack_networking_secgroup_rule_v2" "all-udp-4500-dfw3" {
  provider  = openstack.dfw3
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "udp"
  port_range_min = "4500"
  port_range_max = "4500"
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgrp-demo-dfw3.id}"
}

resource "openstack_networking_secgroup_rule_v2" "all-udp-4500-ord1" {
  provider  = openstack.ord1
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "udp"
  port_range_min = "4500"
  port_range_max = "4500"
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgrp-demo-ord1.id}"
}

# SSH

resource "openstack_networking_secgroup_rule_v2" "all-tcp-22-dfw3" {
  provider  = openstack.dfw3
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = "22"
  port_range_max = "22"
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgrp-demo-dfw3.id}"
}

resource "openstack_networking_secgroup_rule_v2" "all-tcp-22-ord1" {
  provider  = openstack.ord1
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = "22"
  port_range_max = "22"
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgrp-demo-ord1.id}"
}
