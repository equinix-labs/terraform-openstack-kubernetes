data "template_file" "node" {
  template = "${file("${path.module}/node.tpl")}"

  vars {
    kube_token      = "${random_string.kube_init_token_a.result}.${random_string.kube_init_token_b.result}"
    primary_node_ip = "${digitalocean_droplet.k8s_primary.ipv4_address}"
  }
}

resource "digitalocean_droplet" "k8s_node" {
  name      = "${format("${var.cluster_name}-node-%02d", count.index)}"
  image     = "ubuntu-16-04-x64"
  count     = "${var.count}"
  size      = "${var.primary_size}"
  region    = "${var.region}"
  ssh_keys  = "${var.ssh_key_fingerprints}"
  user_data = "${data.template_file.node.rendered}"
}
