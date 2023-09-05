resource "local_file" "ord_private_key" {
  content = templatefile("${path.module}/templates/id_rsa_mnaio.key.tmpl",
    {
      keypair = openstack_compute_keypair_v2.ord_user_key
    }
  )
  file_permission = 0600
  filename = "${path.module}/../ord_id_rsa_mnaio.key"
}
