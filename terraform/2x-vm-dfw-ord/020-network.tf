#### NETWORK CONFIGURATION ####

#################
#### ROUTERS ####
#################

# These routers will act as the edge device for any VMs deployed in
# customer Virtual Routing Domain (VRD).

resource "openstack_networking_router_v2" "dfw3_tenant_router_1" {
  provider            = openstack.dfw3
  name                = "${join("-",["${random_pet.pet_name.id}","${var.dfw3_tenant_router_1.name}"])}"
  admin_state_up      = true
  external_network_id = var.dfw3_external_network["uuid"]
  enable_snat         = true
}

resource "openstack_networking_router_v2" "ord1_tenant_router_1" {
  provider            = openstack.ord1
  name                = "${join("-",["${random_pet.pet_name.id}","${var.ord1_tenant_router_1.name}"])}"
  admin_state_up      = true
  external_network_id = var.ord1_external_network["uuid"]
  enable_snat         = true
}

##########################
#### TENANT NETWORKS  ####
##########################

# DFW

resource "openstack_networking_network_v2" "dfw3_tenant_network_1" {
  provider = openstack.dfw3
  name = "${join("-",["${random_pet.pet_name.id}","dfw3-tenant-network-1"])}"
}

resource "openstack_networking_network_v2" "dfw3_tenant_network_2" {
  provider = openstack.dfw3
  name = "${join("-",["${random_pet.pet_name.id}","dfw3-tenant-network-2"])}"
}

resource "openstack_networking_subnet_v2" "dfw3_tenant_network_1" {
  provider        = openstack.dfw3
  name            = "${join("-",["${random_pet.pet_name.id}","${var.dfw3_tenant_network_1["subnet_name"]}"])}"
  network_id      = openstack_networking_network_v2.dfw3_tenant_network_1.id
  cidr            = var.dfw3_tenant_network_1["cidr"]
  dns_nameservers = var.dns_ip
}

resource "openstack_networking_subnet_v2" "dfw3_tenant_network_2" {
  provider        = openstack.dfw3
  name            = "${join("-",["${random_pet.pet_name.id}","${var.dfw3_tenant_network_2["subnet_name"]}"])}"
  network_id      = openstack_networking_network_v2.dfw3_tenant_network_2.id
  cidr            = var.dfw3_tenant_network_2["cidr"]
  dns_nameservers = var.dns_ip
}

resource "openstack_networking_router_interface_v2" "dfw3-tenant-router-interface-1" {
  provider = openstack.dfw3
  router_id = "${openstack_networking_router_v2.dfw3_tenant_router_1.id}"
  subnet_id = "${openstack_networking_subnet_v2.dfw3_tenant_network_1.id}"
}

resource "openstack_networking_router_interface_v2" "dfw3-tenant-router-interface-2" {
  provider = openstack.dfw3
  router_id = "${openstack_networking_router_v2.dfw3_tenant_router_1.id}"
  subnet_id = "${openstack_networking_subnet_v2.dfw3_tenant_network_2.id}"
}

# ORD

resource "openstack_networking_network_v2" "ord1_tenant_network_1" {
  provider = openstack.ord1
  name = "${join("-",["${random_pet.pet_name.id}","ord1-tenant-network-1"])}"
}

resource "openstack_networking_subnet_v2" "ord1_tenant_network_1" {
  provider        = openstack.ord1
  name            = "${join("-",["${random_pet.pet_name.id}","${var.ord1_tenant_network_1["subnet_name"]}"])}"
  network_id      = openstack_networking_network_v2.ord1_tenant_network_1.id
  cidr            = var.ord1_tenant_network_1["cidr"]
  dns_nameservers = var.dns_ip
}

resource "openstack_networking_router_interface_v2" "ord1-tenant-router-interface-1" {
  provider = openstack.ord1
  router_id = "${openstack_networking_router_v2.ord1_tenant_router_1.id}"
  subnet_id = "${openstack_networking_subnet_v2.ord1_tenant_network_1.id}"
}
