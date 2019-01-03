output "Kubernetes_Cluster_Info" {
  value = "\n\n Run: \n\n\t `ssh ubuntu@${openstack_networking_floatingip_v2.controller_fip.address} kubectl --kubeconfig=/etc/kubernetes/admin.conf get nodes -w` \n\n To troubleshoot (or monitor) spin-up, check the cloud-init output:\n\n\t `ssh ubuntu@${openstack_networking_floatingip_v2.controller_fip.address} tail -f /var/log/cloud-init-output.log` \n\n The initialization and spin-up process may take 5-7 minutes to complete."
}
