#!/bin/bash

if [ $# -lt 1 ]; then
  echo "USAGE: ./setup-cluster.sh ACTION"
  echo "ACTION: {provision}"
  exit 1
fi

set -euo pipefail

NODES=("master" "worker1" "worker2") 
KUBERNETES_VERSION="1.31"

create_k8s_profile() {
  echo "==================================================="
  echo "Creating k8s profile for lxc if it does not exists"
  echo "==================================================="

  if ! lxc profile list | grep -q "k8s"; then
    echo "🪪 Creating k8s profile"
    echo "==================================================="
    lxc profile create k8s
    lxc profile edit k8s < lxd.profile
  else
    echo "❌ Profile already exists"
  fi
}

create_cluster_nodes() {
  local node=$1

  echo "==================================================="
  echo "🏗️ Bringing up $node"
  echo "==================================================="
  if ! lxc info "$node" &> /dev/null; then
    lxc launch --profile k8s ubuntu:24.04 "$node"
  else
    echo "❌ Node $node already exists"
  fi
}

install_container_runtime() {
  local node=$1

  echo "==================================================="
  echo "📲 Installing container runtime in $node"
  echo "==================================================="

  lxc exec $node bash <<EOF
  apt-get update
  apt-get install --assume-yes net-tools curl software-properties-common apt-transport-https ca-certificates gnupg lsb-release

  mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

  apt-get update
  apt-get install containerd.io

  containerd config default > /etc/containerd/config.toml
  sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
  systemctl restart containerd
  systemctl enable containerd

  curl -fsSL https://pkgs.k8s.io/core:/stable:/v${KUBERNETES_VERSION}/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${KUBERNETES_VERSION}/deb/ /" > /etc/apt/sources.list.d/kubernetes.list

  apt-get update
  apt-get install --assume-yes kubeadm kubelet kubectl

  echo 'KUBELET_EXTRA_ARGS="--fail-swap-on=false"' > /etc/default/kubelet
  systemctl restart kubelet
EOF
}

create_control_plane() {
  echo "==================================================="
  echo "🛜 Creating control plane in master node"
  echo "==================================================="
}

case "$1" in
  provision)
    create_k8s_profile

    for node in "${NODES[@]}"; do
      create_cluster_nodes $node
      install_container_runtime $node
      if [[ $node =~ .*master.* ]]; then
        create_control_plane
      fi
    done
  ;;
esac

