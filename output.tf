output "Kubernetes_Cluster_Info" {
  value = "\n\n Run: \n\n\t `ssh ubuntu@${openstack_compute_instance_v2.k8s_primary.network.0.fixed_ip_v4} KUBECONFIG=/etc/kubernetes/admin.conf kubectl get nodes -w` \n\n To troubleshoot (or monitor) spin-up, check the cloud-init output:\n\n\t `ssh ubuntu@${openstack_compute_instance_v2.k8s_primary.network.0.fixed_ip_v4} tail -f /var/log/cloud-init-output.log` \n\n The initialization and spin-up process may take 5-7 minutes to complete."
}
