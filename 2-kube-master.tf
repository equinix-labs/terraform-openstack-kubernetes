data "template_file" "master" {
  template = "${file("${path.module}/master.tpl")}"

  vars {
    kube_token = "${random_string.kube_init_token_a.result}.${random_string.kube_init_token_b.result}"
  }
}

resource "digitalocean_droplet" "k8s_primary" {
  name      = "${var.cluster_name}-primary"
  image     = "ubuntu-16-04-x64"
  size      = "${var.primary_size}"
  region    = "${var.region}"
  ssh_keys  = ["${var.ssh_key_fingerprint}"]
  user_data = "${data.template_file.master.rendered}"
}
