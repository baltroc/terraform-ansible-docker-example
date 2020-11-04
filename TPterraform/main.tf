
# Configure the OpenStack Provider
provider "openstack" {
  user_name   = "nicolas.inati.etu" #set user name
  tenant_name = "nicolas.inati.etu" #set project name
  password    = "password" #set password
  auth_url    = "http://cloud.univ-lille.fr:5000/v3/"
}

resource "openstack_compute_keypair_v2" "test-keypair" {
  name = "my-keypair"
}

variable "instances_names" {
  type    = set(string)
  default = ["ubuntu-1",
             "ubuntu-2",
             "ubuntu-3",
             "ubuntu-4"]
}

resource "openstack_compute_instance_v2" "ubuntu-basic" {
  for_each        = var.instances_names
  name            = each.key
  image_id        = "bf420b24-7df0-485f-ae29-1f778c3d1df4"
  flavor_name       = "moyenne"
  key_pair        = openstack_compute_keypair_v2.test-keypair.name
}
