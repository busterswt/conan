# Create instance
resource "openstack_compute_instance_v2" "node01-ord" {
  provider    = openstack.ord1
  name        = "${join("-",["${random_pet.pet_name.id}","node01-ord"])}"
  image_name  = var.image
  flavor_id   = openstack_compute_flavor_v2.t2-medium-ord.id
  key_pair    = openstack_compute_keypair_v2.ord_user_key.name
  user_data   = file("scripts/cloud-init.yaml")
  config_drive = true
  network {
    port = openstack_networking_port_v2.node01-ord-port-1.id
  }
}

# Create network port
resource "openstack_networking_port_v2" "node01-ord-port-1" {
  provider    = openstack.ord1
  name           = "${join("-",["${random_pet.pet_name.id}","node01-ord-1"])}"
  network_id     = openstack_networking_network_v2.ord1_tenant_network_1.id
  admin_state_up = true
  security_group_ids = [openstack_networking_secgroup_v2.secgrp-demo-ord1.id]
  port_security_enabled = true
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.ord1_tenant_network_1.id
  }
}

#### Floating IPs ####

resource "openstack_networking_floatingip_v2" "node01-ord-float" {
  provider    = openstack.ord1
  pool         = var.ord1_external_network["name"]
}

resource "openstack_compute_floatingip_associate_v2" "node01-ord-float-associate" {
  provider    = openstack.ord1
  instance_id     = openstack_compute_instance_v2.node01-ord.id
  floating_ip     = "${openstack_networking_floatingip_v2.node01-ord-float.address}"
  fixed_ip        = "${openstack_compute_instance_v2.node01-ord.network.0.fixed_ip_v4}"

  depends_on = [ openstack_networking_router_interface_v2.ord1-tenant-router-interface-1 ]
}
