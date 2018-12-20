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

variable "digitalocean_ccm_release" {
  description = "Version of DigitalOcean Cloud Controller Manager to run (https://github.com/digitalocean/digitalocean-cloud-controller-manager/tree/master/releases)"
  default     = "0.1.8"
}

variable "kubernetes_version" {
  description = "Version of Kubeadm to install"
  default     = "1.12.3-00"
}

variable "secrets_encryption" {
  description = "Enable at-rest Secrets encryption"
  default     = "no"
}
