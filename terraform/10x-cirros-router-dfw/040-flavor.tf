#### Flavors ####

# DFW

resource "openstack_compute_flavor_v2" "t2-tiny-dfw" {
  provider    = openstack.dfw3
  name  = "t2.tiny"
  ram   = "1024"
  vcpus = "1"
  disk  = "2"
  is_public = true
}
