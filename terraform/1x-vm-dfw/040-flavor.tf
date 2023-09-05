#### Flavors ####

# DFW

resource "openstack_compute_flavor_v2" "t2-small-dfw" {
  provider    = openstack.dfw3
  name  = "t2.small"
  ram   = "2048"
  vcpus = "1"
  disk  = "20"
  is_public = true
}

resource "openstack_compute_flavor_v2" "t2-medium-dfw" {
  provider    = openstack.dfw3
  name  = "t2.medium"
  ram   = "4096"
  vcpus = "2"
  disk  = "20"
  is_public = true
}

resource "openstack_compute_flavor_v2" "t2-large-dfw" {
  provider    = openstack.dfw3
  name  = "t2.large"
  ram   = "8192"
  vcpus = "2"
  disk  = "20"
  is_public = true
}

resource "openstack_compute_flavor_v2" "t2-xlarge-dfw" {
  provider    = openstack.dfw3
  name  = "t2.xlarge"
  ram   = "16384"
  vcpus = "4"
  disk  = "20"
  is_public = true
}

