#!/bin/bash

function install_docker() {
 echo "Installing Docker..." ; \
 apt-get update; \
 apt-get install -y docker.io && \
 cat << EOF > /etc/docker/daemon.json
 {
   "exec-opts": ["native.cgroupdriver=cgroupfs"]
 }
EOF
}

function install_kube_tools {
 echo "Installing Kubeadm tools..."
 apt-get update && apt-get install -y apt-transport-https
 curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
 echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
 apt-get update
 apt-get install -y kubelet=${kube_version} kubeadm=${kube_version} kubectl=${kube_version}
}

function init_cluster {
    echo "Initializing cluster..." && \
    kubeadm init --token "${kube_token}" && \
    sysctl net.bridge.bridge-nf-call-iptables=1; \
    kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl --kubeconfig=/etc/kubernetes/admin.conf version | base64 | tr -d '\n')"
}

function gen_encryption_config {
  echo "Generating EncryptionConfig for cluster..." && \
  export BASE64_STRING=$(head -c 32 /dev/urandom | base64) && \
  cat << EOF > /etc/kubernetes/secrets.conf
apiVersion: v1
kind: EncryptionConfig
resources:
- providers:
  - aescbc:
      keys:
      - name: key1
        secret: $BASE64_STRING
  resources:
  - secrets
EOF
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

function modify_encryption_config {
#Validate Encrypted Secret:
# ETCDCTL_API=3 etcdctl --cert="/etc/kubernetes/pki/etcd/server.crt" --key="/etc/kubernetes/pki/etcd/server.key" --c
acert="/etc/kubernetes/pki/etcd/ca.crt" get /registry/secrets/default/personal-secret | hexdump -C
  echo "Updating Kube APIServer Configuration for At-Rest Secret Encryption..." && \
  sed -i 's|- kube-apiserver|- kube-apiserver\n    - --experimental-encryption-provider-config=/etc/kubernetes/secrets.conf|g' /etc/kubernetes/manifests/kube-apiserver.yaml && \
  sed -i 's|  volumes:|  volumes:\n  - hostPath:\n      path: /etc/kubernetes/secrets.conf\n      type: FileOrCreate\n    name: secretconfig|g' /etc/kubernetes/manifests/kube-apiserver.yaml  && \
  sed -i 's|    volumeMounts:|    volumeMounts:\n    - mountPath: /etc/kubernetes/secrets.conf\n      name: secretconfig\n      readOnly: true|g' /etc/kubernetes/manifests/kube-apiserver.yaml 
}

function configure_openstack_cloud_config {
  echo "Updating Kube APIServer Configuration for OpenStack Cloud Configuration..." && \
  sed -i 's|- kube-apiserver|- kube-apiserver\n    - --cloud-config=/etc/kubernetes/cloud.conf|g' /etc/kubernetes/manifests/kube-apiserver.yaml && \
  sed -i 's|- kube-apiserver|- kube-apiserver\n    - --cloud-provider=openstack|g' /etc/kubernetes/manifests/kube-apiserver.yaml && \
  sed -i 's|  volumes:|  volumes:\n  - hostPath:\n      path: /etc/kubernetes/cloud.conf\n      type: FileOrCreate\n    name: oscloudconfig|g' /etc/kubernetes/manifests/kube-apiserver.yaml  && \
  sed -i 's|    volumeMounts:|    volumeMounts:\n    - mountPath: /etc/kubernetes/cloud.conf\n      name: oscloudconfig\n      readOnly: true|g' /etc/kubernetes/manifests/kube-apiserver.yaml && \
  echo "Updating Kube Controller Manager Configuration for OpenStack Cloud Configuration..." && \
  sed -i 's|- kube-controller-manager|- kube-controller-manager\n    - --cloud-config=/etc/kubernetes/cloud.conf|g' /etc/kubernetes/manifests/kube-controller-manager.yaml && \
  sed -i 's|- kube-controller-manager|- kube-controller-manager\n    - --cloud-provider=openstack|g' /etc/kubernetes/manifests/kube-controller-manager.yaml && \
  sed -i 's|  volumes:|  volumes:\n  - hostPath:\n      path: /etc/kubernetes/cloud.conf\n      type: FileOrCreate\n    name: oscloudconfig|g' /etc/kubernetes/manifests/kube-controller-manager.yaml  && \
  sed -i 's|    volumeMounts:|    volumeMounts:\n    - mountPath: /etc/kubernetes/cloud.conf\n      name: oscloudconfig\n      readOnly: true|g' /etc/kubernetes/manifests/kube-controller-manager.yaml && \
  echo "Update Kubelet config..."
  sed -i 's|Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"|Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml --cloud-provider=openstack --cloud-config=/etc/kubernetes.cloud.conf"|g' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf && \
  systemctl daemon-reload && \
  systemctl restart kubelet
}

function apply_workloads {
  echo "Applying workloads..." && \
	cd /root/kube && \
	kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f *.yaml
}

install_docker && \
install_kube_tools && \
sleep 30 && \
init_cluster && \
gen_openstack_cloud_conf && \
configure_openstack_cloud_config && \
sleep 180 && \
apply_workloads && \
if [ "${secrets_encryption}" = "yes" ]; then
  echo "Secrets Encrypted selected...configuring..." && \
  gen_encryption_config && \
  sleep 60 && \
  modify_encryption_config
else
  echo "Secrets Encryption not selected...finishing..."
fi

