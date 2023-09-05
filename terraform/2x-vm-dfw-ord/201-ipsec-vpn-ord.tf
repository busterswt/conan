# Create ikepolicy

resource "openstack_vpnaas_ike_policy_v2" "ike-policy-ord" {
  provider    = openstack.ord1
  name        = "${join("-",["${random_pet.pet_name.id}","ike-policy"])}"
}

# Create ipsec policy

resource "openstack_vpnaas_ipsec_policy_v2" "ipsec-policy-ord" {
  provider    = openstack.ord1
  name        = "${join("-",["${random_pet.pet_name.id}","ipsec-policy"])}"
}

# Create VPN service

resource "openstack_vpnaas_service_v2" "ipsec-vpn-service-ord" {
  provider       = openstack.ord1
  name           = "${join("-",["${random_pet.pet_name.id}","vpn-service"])}"
  router_id      = "${openstack_networking_router_v2.ord1_tenant_router_1.id}"
  admin_state_up = "true"
}

# Local encryption domain (endpoint group)

resource "openstack_vpnaas_endpoint_group_v2" "ipsec-epg-ord-local" {
  provider    = openstack.ord1
  name = "${join("-",["${random_pet.pet_name.id}","epg-local"])}"
  type = "subnet"
  endpoints = ["${openstack_networking_subnet_v2.ord1_tenant_network_1.id}", ]
}

# Remote encryption domain (endpoint group)

resource "openstack_vpnaas_endpoint_group_v2" "ipsec-epg-ord-remote" {
  provider    = openstack.ord1
  name = "${join("-",["${random_pet.pet_name.id}","epg-remote"])}"
  type = "cidr"
  endpoints = [ var.dfw3_tenant_network_1["cidr"], 
                var.dfw3_tenant_network_2["cidr"], ]
}

# IPSec Connection

resource "openstack_vpnaas_site_connection_v2" "ipsec-connection-ord" {
  provider    = openstack.ord1
  name              = "${join("-",["${random_pet.pet_name.id}","ipsec-ord-to-dfw"])}"
  ikepolicy_id      = openstack_vpnaas_ike_policy_v2.ike-policy-ord.id
  ipsecpolicy_id    = openstack_vpnaas_ipsec_policy_v2.ipsec-policy-ord.id
  vpnservice_id     = openstack_vpnaas_service_v2.ipsec-vpn-service-ord.id
  psk               = "secret"
  peer_address      = openstack_networking_router_v2.dfw3_tenant_router_1.external_fixed_ip[0].ip_address
  peer_id           = openstack_networking_router_v2.dfw3_tenant_router_1.external_fixed_ip[0].ip_address
  local_ep_group_id = openstack_vpnaas_endpoint_group_v2.ipsec-epg-ord-local.id
  peer_ep_group_id  = openstack_vpnaas_endpoint_group_v2.ipsec-epg-ord-remote.id
  dpd {
    action   = "restart"
    timeout  = 42
    interval = 21
  }

  depends_on = [ openstack_networking_router_v2.ord1_tenant_router_1,
                 openstack_networking_router_interface_v2.ord1-tenant-router-interface-1, ]
}
