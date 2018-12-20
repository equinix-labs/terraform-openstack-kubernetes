data "template_file" "controller" {
  template = "${file("${path.module}/controller.tpl")}"

  vars {
    kube_token         = "${random_string.kube_init_token_a.result}.${random_string.kube_init_token_b.result}"
    do_token           = "${var.digitalocean_token}"
    ccm_version        = "${var.digitalocean_ccm_release}"
    kube_version       = "${var.kubernetes_version}"
    secrets_encryption = "${var.secrets_encryption}"
  }
}

resource "digitalocean_droplet" "k8s_primary" {
  name               = "${var.cluster_name}-primary"
  image              = "ubuntu-16-04-x64"
  size               = "${var.primary_size}"
  region             = "${var.region}"
  backups            = "true"
  private_networking = "true"
  ssh_keys           = "${var.ssh_key_fingerprints}"
  user_data          = "${data.template_file.controller.rendered}"
}
