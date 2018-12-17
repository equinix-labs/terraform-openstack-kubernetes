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

function install_kube_tools {
 apt-get update && apt-get install -y apt-transport-https
 curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
 echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
 apt-get update
 apt-get install -y kubelet=${kube_version} kubeadm=${kube_version} kubectl=${kube_version}
}

function init_cluster {
    kubeadm init --token "${kube_token}" && \
    sysctl net.bridge.bridge-nf-call-iptables=1; \
    kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl --kubeconfig=/etc/kubernetes/admin.conf version | base64 | tr -d '\n')"
}

function define_ccm {
	mkdir /root/kube && \
	cd /root/kube && \
	wget "https://raw.githubusercontent.com/digitalocean/digitalocean-cloud-controller-manager/master/releases/v${ccm_version}.yml" && \
	cat << EOF > /root/kube/0-ccm.yaml
	apiVersion: v1
	kind: Secret
	metadata:
	  name: digitalocean
	  namespace: kube-system
	stringData:
	  access-token: "${do_token}"
EOF
}

function apply_workloads {
	cd /root/kube && \
	kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f *.yaml
}

install_docker && \
install_kube_tools && \
sleep 30 && \
init_cluster && \
define_ccm && \
sleep 180 && \
apply_workloads