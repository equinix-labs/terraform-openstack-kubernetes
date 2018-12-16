variable "digitalocean_token" {
  description = "Your DigitalOcean API key"
}

variable "region" {
  description = "DigitalOcean Region"
  default     = "TOR1"
}

variable "node_size" {
  description = "K8s Agent Droplet Size"
  default     = "4GB"
}

variable "primary_size" {
  description = "K8s Primary Droplet Size"
  default     = "4GB"
}

variable "cluster_name" {
  description = "Name of your cluster. Alpha-numeric and hyphens only, please."
  default     = "digitalocean-k8s"
}

variable "count" {
  default     = "3"
  description = "Number of nodes."
}

variable "ssh_key_fingerprints" {
  description = "Your DO public ssh key fingerprints"
  type        = "list"
}
