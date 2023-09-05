resource "random_pet" "pet_name" {
  length = 2
}

variable "image" {
  type    = string
  description = "The short name  of the Glance image to use for the server."
  default = "ospcv2-ubuntu-22.04-jammy-cloud-image"
}

variable "dfw3_external_network" {
  type    = map(string)
  description = "The NAME and UUID of an External Provider Network for Floating IPs (dict)."
  default = {"uuid":"dd2b8693-99d1-451a-9cc2-e8c996ca1e08", "name":"ext_network"}
}

variable "ord1_external_network" {
  type    = map(string)
  description = "The NAME and UUID of an External Provider Network for Floating IPs (dict)."
  default = {"uuid":"1692d064-d011-4589-a39d-0e64b15e88da","name":"ext_network"}
}

variable "dns_ip" {
  type    = list(string)
  default = ["1.1.1.1", "1.0.0.1"]
}

####################
# Networks/Subnets #
####################

# DFW

variable "dfw3_tenant_network_1" {
  type = map(string)
  default = {
    subnet_name = "dfw3-tenant-network-1-192.168.1.0/24"
    cidr        = "192.168.1.0/24"
  }
}

variable "dfw3_tenant_network_2" {
  type = map(string)
  default = {
    subnet_name = "dfw3-tenant-network-2-192.168.2.0/24"
    cidr        = "192.168.2.0/24"
  }
}

# ORD

variable "ord1_tenant_network_1" {
  type = map(string)
  default = {
    subnet_name = "ord1-tenant-network-1-172.16.100.0/24"
    cidr        = "172.16.100.0/24"
  }
}

variable "ord1_tenant_network_2" {
  type = map(string)
  default = {
    subnet_name = "ord1-tenant-network-2-172.16.101.0/24"
    cidr        = "172.16.101.0/24"
  }
}

###########
# Routers #
###########

variable "dfw3_tenant_router_1" {
  type = map(string)
  default = {
    name        = "dfw3-demo-tenant-router"
  }
}

variable "ord1_tenant_router_1" {
  type = map(string)
  default = {
    name        = "ord1-demo-tenant-router"
  }
}
