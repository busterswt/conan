# Create instance
resource "openstack_compute_instance_v2" "node01-dfw" {
  provider    = openstack.dfw3
  name        = "${join("-",["${random_pet.pet_name.id}","node01-dfw"])}"
  image_name  = var.image
  flavor_id   = openstack_compute_flavor_v2.t2-tiny-dfw.id
  key_pair    = openstack_compute_keypair_v2.dfw_user_key.name
  user_data   = file("scripts/cloud-init.yaml")
  config_drive = true
  network {
    port = openstack_networking_port_v2.node01-dfw-port-1.id
  }
}

# Create network port
resource "openstack_networking_port_v2" "node01-dfw-port-1" {
  provider    = openstack.dfw3
  name           = "${join("-",["${random_pet.pet_name.id}","node01-dfw-1"])}"
  network_id     = openstack_networking_network_v2.dfw3_tenant_network_1.id
  admin_state_up = true
  security_group_ids = [openstack_networking_secgroup_v2.secgrp-demo-dfw3.id]
  port_security_enabled = true
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.dfw3_tenant_network_1.id
  }
}

#### Floating IPs ####

resource "openstack_networking_floatingip_v2" "node01-dfw-float" {
  provider    = openstack.dfw3
  pool         = var.dfw3_external_network["name"]
}

resource "openstack_compute_floatingip_associate_v2" "node01-dfw-float-associate" {
  provider    = openstack.dfw3
  instance_id     = openstack_compute_instance_v2.node01-dfw.id
  floating_ip     = "${openstack_networking_floatingip_v2.node01-dfw-float.address}"
  fixed_ip        = "${openstack_compute_instance_v2.node01-dfw.network.0.fixed_ip_v4}"

  depends_on = [ openstack_networking_router_interface_v2.dfw3-tenant-router-interface-1 ]
}
