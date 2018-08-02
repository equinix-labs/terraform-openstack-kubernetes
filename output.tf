output "primary-ip" {
  value = "${digitalocean_droplet.k8s_primary.ipv4_address}"
}
