#!/bin/bash

function install_docker() {
 apt-get update; \
 apt-get install -y docker.io

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
 apt-get install -y kubelet kubeadm kubectl
}

function init_cluster() {
    kubeadm init --token "${kube_token}" && \
    sysctl net.bridge.bridge-nf-call-iptables=1; \
    kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl --kubeconfig=/etc/kubernetes/admin.conf version | base64 | tr -d '\n')"
}

install_docker && \
install_kube_tools && \
init_cluster