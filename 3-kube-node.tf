data "template_file" "node" {
  template = "${file("${path.module}/node.tpl")}"

  vars {
    kube_token          = "${random_string.kube_init_token_a.result}.${random_string.kube_init_token_b.result}"
    primary_node_ip     = "${digitalocean_droplet.k8s_primary.ipv4_address}"
    kube_version        = "${var.kubernetes_version}"
    user_name           = "${var.user_name}"
    tenant_name         = "${var.tenant_name}"
    password            = "${var.password}"
    auth_url            = "${var.auth_url}"
    lb_subnet_id        = "${var.lb_subnet_id}"
    floating_network_id = "${var.floating_network_id}"
  }
}

resource "openstack_compute_instance_v2" "k8s_primary" {
  name            = "${format("${var.cluster_name}-node-%02d", count.index)}"
  image_id        = "${var.image_id}"
  count           = "${var.count}"
  flavor_id       = "${var.flavor_id_node}"
  key_pair        = "${var.ssh_key_name}"
  security_groups = ["default"]
  user_data       = "${data.template_file.node.rendered}"

  network {
    name = "${var.network_id}"
  }
}

resource "digitalocean_droplet" "k8s_node" {
  name               = "${format("${var.cluster_name}-node-%02d", count.index)}"
  image              = "ubuntu-16-04-x64"
  count              = "${var.count}"
  size               = "${var.primary_size}"
  region             = "${var.region}"
  private_networking = "true"
  ssh_keys           = "${var.ssh_key_fingerprints}"
  user_data          = "${data.template_file.node.rendered}"
}
