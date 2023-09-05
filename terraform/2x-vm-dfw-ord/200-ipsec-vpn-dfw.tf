# Create ikepolicy

resource "openstack_vpnaas_ike_policy_v2" "ike-policy-dfw" {
  provider    = openstack.dfw3
  name        = "${join("-",["${random_pet.pet_name.id}","ike-policy"])}"
}

# Create ipsec policy

resource "openstack_vpnaas_ipsec_policy_v2" "ipsec-policy-dfw" {
  provider    = openstack.dfw3
  name        = "${join("-",["${random_pet.pet_name.id}","ipsec-policy"])}"
}

# Create VPN service

resource "openstack_vpnaas_service_v2" "ipsec-vpn-service-dfw" {
  provider       = openstack.dfw3
  name           = "${join("-",["${random_pet.pet_name.id}","vpn-service"])}"
  router_id      = "${openstack_networking_router_v2.dfw3_tenant_router_1.id}"
  admin_state_up = "true"
}

# Local encryption domain (endpoint group)

resource "openstack_vpnaas_endpoint_group_v2" "ipsec-epg-dfw-local" {
  provider       = openstack.dfw3
  name = "${join("-",["${random_pet.pet_name.id}","epg-local"])}"
  type = "subnet"
  endpoints = ["${openstack_networking_subnet_v2.dfw3_tenant_network_1.id}",
               "${openstack_networking_subnet_v2.dfw3_tenant_network_2.id}", ]
}

# Remote encryption domain (endpoint group)

resource "openstack_vpnaas_endpoint_group_v2" "ipsec-epg-dfw-remote" {
  provider       = openstack.dfw3
  name = "${join("-",["${random_pet.pet_name.id}","epg-remote"])}"
  type = "cidr"
  endpoints = [ var.ord1_tenant_network_1["cidr"], ]
}

# IPSec Connection

resource "openstack_vpnaas_site_connection_v2" "ipsec-connection-dfw" {
  provider       = openstack.dfw3
  name              = "${join("-",["${random_pet.pet_name.id}","ipsec-dfw-to-ord"])}"
  ikepolicy_id      = openstack_vpnaas_ike_policy_v2.ike-policy-dfw.id
  ipsecpolicy_id    = openstack_vpnaas_ipsec_policy_v2.ipsec-policy-dfw.id
  vpnservice_id     = openstack_vpnaas_service_v2.ipsec-vpn-service-dfw.id
  psk               = "secret"
  peer_address      = openstack_networking_router_v2.ord1_tenant_router_1.external_fixed_ip[0].ip_address
  peer_id           = openstack_networking_router_v2.ord1_tenant_router_1.external_fixed_ip[0].ip_address
  local_ep_group_id = openstack_vpnaas_endpoint_group_v2.ipsec-epg-dfw-local.id
  peer_ep_group_id  = openstack_vpnaas_endpoint_group_v2.ipsec-epg-dfw-remote.id
  dpd {
    action   = "restart"
    timeout  = 42
    interval = 21
  }

  depends_on = [ openstack_networking_router_v2.dfw3_tenant_router_1,
                 openstack_networking_router_interface_v2.dfw3-tenant-router-interface-1,
                 openstack_networking_router_interface_v2.dfw3-tenant-router-interface-2, ]
}
