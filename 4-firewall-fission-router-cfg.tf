# resource "digitalocean_firewall" "k8s_primary" {
#   name = "kubernetes-primary-ports"
#   droplet_ids = ["${digitalocean_droplet.k8s_primary.id}"]
#   inbound_rule = [
#     {
#       protocol         = "tcp"
#       port_range       = "6443"
#       source_addresses = ["${join(",", digitalocean_droplet.k8s_node.*.ipv4_address)}"]
#     },
#     {
#       protocol         = "tcp"
#       port_range       = "2379"
#       source_addresses = ["${join(",", digitalocean_droplet.k8s_node.*.ipv4_address)}"]
#     },
#     {
#       protocol         = "tcp"
#       port_range       = "2380"
#       source_addresses = ["${join(",", digitalocean_droplet.k8s_node.*.ipv4_address)}"]
#     },
#     {
#       protocol         = "tcp"
#       port_range       = "10250"
#       source_addresses = ["${join(",", digitalocean_droplet.k8s_node.*.ipv4_address)}"]
#     },
#     {
#       protocol         = "tcp"
#       port_range       = "10251"
#       source_addresses = ["${join(",", digitalocean_droplet.k8s_node.*.ipv4_address)}"]
#     },
#     {
#       protocol         = "tcp"
#       port_range       = "10252"
#       source_addresses = ["${join(",", digitalocean_droplet.k8s_node.*.ipv4_address)}"]
#     },
#     {
#       protocol         = "tcp"
#       port_range       = "10255"
#       source_addresses = ["${join(",", digitalocean_droplet.k8s_node.*.ipv4_address)}"]
#     },
#   ]
# }
# resource "digitalocean_firewall" "k8s_node" {
#   name = "kubernetes-node-ports"
#   droplet_ids = ["${join(",", digitalocean_droplet.k8s_node.*.ipv4_address)}"]
#   inbound_rule = [
#     {
#       protocol         = "tcp"
#       port_range       = "10250"
#       source_addresses = ["${join(",", digitalocean_droplet.k8s_node.*.ipv4_address)}"]
#     },
#     {
#       protocol         = "tcp"
#       port_range       = "10255"
#       source_addresses = ["${join(",", digitalocean_droplet.k8s_node.*.ipv4_address)}"]
#     },
#   ]
# }
# resource "digitalocean_loadbalancer" "fission-router" {
#   name   = "fission-router"
#   region = "${var.region}"
#   forwarding_rule {
#     entry_port     = 80
#     entry_protocol = "http"
#     target_port     = 31314
#     target_protocol = "http"
#   }
#   healthcheck {
#     port     = 31314
#     protocol = "tcp"
#   }
#   droplet_ids = ["${digitalocean_droplet.k8s_primary.id}"]
# }
# resource "digitalocean_loadbalancer" "fission-controller" {
#   name   = "fission-router"
#   region = "${var.region}"
#   forwarding_rule {
#     entry_port     = 80
#     entry_protocol = "http"
#     target_port     = 31313
#     target_protocol = "http"
#   }
#   healthcheck {
#     port     = 31313
#     protocol = "tcp"
#   }
#   droplet_ids = ["${digitalocean_droplet.k8s_primary.id}"]
# }

