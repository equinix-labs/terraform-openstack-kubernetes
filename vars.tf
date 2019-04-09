variable "user_name" {
  description = "OpenStack Username"
}

variable "tenant_name" {
  description = "OpenStack Project"
}

variable "password" {
  description = "OpenStack Password"
}

variable "auth_url" {
  description = "OpenStack Auth URL (v2)"
}

variable "region" {
  description = "OpenStack Region"
}

variable "image_id" {
  description = "Openstack Image"
}

variable "flavor_id_node" {
  description = "OpenStack Flavor for Nodes"
}

variable "flavor_id_controller" {
  description = "OpenStack Flavor for Controller"
}

variable "network_name" {
  description = "OpenStack Network name (i.e. private_network) for nodes"
}

variable "floating_network_pool_name" {
  description = "OpenStack name of Floating IP pool. (i.e. public)"
}
variable "floating_network_id" {
  description = "OpenStack Network ID for Floating IP pool"
}

variable "lb_subnet_id" {
  description = "OpenStack LB Subnet ID"
}

variable "cluster_name" {
  description = "Name of your cluster. Alpha-numeric and hyphens only, please."
  default     = "openstack-k8s"
}

variable "count" {
  default     = "3"
  description = "Number of nodes."
}

variable "ssh_key_name" {
  description = "Your public ssh key name"
}

variable "kubernetes_version" {
  description = "Version of Kubeadm to install"
  default     = "1.14.0-00"
}

variable "secrets_encryption" {
  description = "Enable at-rest Secrets encryption"
  default     = "no"
}
