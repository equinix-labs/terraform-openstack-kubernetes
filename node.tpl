#!/bin/bash

function install_docker() {
 apt-get update; \
 apt-get install -y docker.io && \
 cat << EOF > /etc/docker/daemon.json
 {
   "exec-opts": ["native.cgroupdriver=cgroupfs"]
 }
EOF
}

function install_kube_tools() {
 apt-get update && apt-get install -y apt-transport-https
 curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
 echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
 apt-get update
 apt-get install -y kubelet=${kube_version} kubeadm=${kube_version} kubectl=${kube_version}
 echo "Waiting 180s to attempt to join cluster..."
}

function join_cluster() {
	echo "Attempting to join cluster" && \
    kubeadm join "${primary_node_ip}:6443" --token "${kube_token}" --discovery-token-unsafe-skip-ca-verification
}

function gen_openstack_cloud_conf {
  echo "Generating cloud.conf..." && \
  export AUTH_URL = $(echo ${auth_url} | sed -e 's|\/v2|\/v3|g')
  cat << EOF > /etc/kubernetes/cloud.conf
[Global]
username=${user_name}
tenant-id=${tenant_id}
password=${password}
auth-url=$AUTH_URL
[LoadBalancer]
subnet-id=${lb_subnet_id}
floating-network-id=${floating_network_id}
lb-method=ROUND_ROBIN
lb-provider=amphora
[BlockStorage]
bs-version=auto
EOF
}

function update_kubelet() {
  echo "Updating Kubelet config..." && \
  sed -i 's|Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"|Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml --cloud-provider=openstack --cloud-config=/etc/kubernetes.cloud.conf"|g' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf && \
  systemctl daemon-reload && \
  systemctl restart kubelet
}

install_docker && \
install_kube_tools && \
sudo service docker restart && \
gen_openstack_cloud_conf && \
update_kubelet && \
sleep 180 && \
join_cluster