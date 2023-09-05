# Define ssh to config in instance

resource "openstack_compute_keypair_v2" "dfw_user_key" {
  provider    = openstack.dfw3
  name       = "${join("-",["${random_pet.pet_name.id}","user-key"])}"
}

resource "openstack_compute_keypair_v2" "ord_user_key" {
  provider    = openstack.ord1
  name       = "${join("-",["${random_pet.pet_name.id}","user-key"])}"
}
