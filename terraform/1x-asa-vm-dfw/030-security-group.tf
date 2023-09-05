# Security Groups

resource "openstack_networking_secgroup_v2" "secgrp-demo-ord1" {
  provider    = openstack.ord1
  name        = "decgrp-demo"
  description = "Security Group for Demo"
}

# Security Group Rules

resource "openstack_networking_secgroup_rule_v2" "all-icmp-ord1" {
  provider  = openstack.ord1
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "icmp"
  remote_ip_prefix = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.secgrp-demo-ord1.id}"
}
