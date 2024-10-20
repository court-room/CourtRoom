#!/bin/bash

if [ $# -lt 1 ]; then
  echo "USAGE: ./setup-cluster.sh ACTION"
  echo "ACTION: {provision}"
  exit 1
fi

set -euo pipefail

NODES=("master", "worker1", "worker2") 
LXC_PROFILE="k8s"

create_k8s_profile() {
  echo "==================================================="
  echo "Creating k8s profile for lxc if it does not exists"
  echo "==================================================="

  if ! lxc profile list | grep -q "k8s"; then
    echo "💡 Creating k8s profile"
    echo "==================================================="
    lxc profile create k8s
    lxc profile edit k8s < lxd.profile
  else
    echo "❌ Profile already exists"
  fi
}

case "$1" in
  provision)
    create_k8s_profile
  ;;
esac

