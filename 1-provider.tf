provider "openstack" {
  user_name   = "${var.user_name}"
  tenant_name = "${var.tenant_name}"
  password    = "${var.password}"
  auth_url    = "${var.auth_url}"
  region      = "${var.region}"
}

resource "random_string" "kube_init_token_a" {
  length  = 6
  special = false
  upper   = false
}

resource "random_string" "kube_init_token_b" {
  length      = 16
  special     = false
  upper       = false
  min_lower   = 6
  min_numeric = 6
}
