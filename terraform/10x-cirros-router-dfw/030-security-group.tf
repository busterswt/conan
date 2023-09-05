# Security Groups

resource "openstack_networking_secgroup_v2" "secgrp-demo-dfw3" {
  provider    = openstack.dfw3
  name        = "secgrp-demo"
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

