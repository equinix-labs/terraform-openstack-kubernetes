data "template_file" "controller" {
  template = "${file("${path.module}/controller.tpl")}"

  vars {
    kube_token         = "${random_string.kube_init_token_a.result}.${random_string.kube_init_token_b.result}"
    kube_version       = "${var.kubernetes_version}"
    secrets_encryption = "${var.secrets_encryption}"
    user_name   = "${var.user_name}"
    tenant_name = "${var.tenant_name}"
    password    = "${var.password}"
    auth_url    = "${var.auth_url}"
    lb_subnet_id = "${var.lb_subnet_id}"
    floating_network_id = "${var.floating_network_id}"
  }
}

resource "openstack_compute_instance_v2" "k8s_primary" {
  name            = "${var.cluster_name}-controller"
  image_id        = "${var.image_id}"
  flavor_id       = "${var.flavor_id_controller}"
  key_pair        = "${var.ssh_key_name}"
  security_groups = ["default"]
  user_data          = "${data.template_file.controller.rendered}"

  network {
    name = "${var.network_id}"
  }
}
