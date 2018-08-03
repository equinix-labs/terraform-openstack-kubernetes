output "Kubernetes_Cluster_Info" {
  value = "\n\n Run: \n\n\t `ssh root@${digitalocean_droplet.k8s_primary.ipv4_address} kubectl --kubeconfig=/etc/kubernetes/admin.conf get nodes -w` \n\n to track progress of cluster spin-up.\n\n If the primary node Kube APIserver is inaccessible, or nodes do not begin checking-in within a few minutes, check status of spin-up in /var/log/cloud-init-output.log on the failing droplet."
}
