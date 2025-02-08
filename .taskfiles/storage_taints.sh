#!/usr/bin/env bash

NODES=$1
ROOTDIR=$2

_nodeHostnames=()

cd $ROOTDIR

# Get the hostnames of the nodes by ip
IFS=',' read -ra _nodesArr <<< "$NODES"
for _item in "${_nodesArr[@]}"; do
  _hostname=$(kubectl get nodes -o jsonpath='{range .items[*]}{.status.addresses[?(@.type=="InternalIP")].address}{" "}{.metadata.name}{"\n"}{end}' | grep -i $_item | awk '{print $2}')

  if [[ -n "${_hostname// /}" ]]; then
    _nodeHostnames+=("$_hostname")
  fi
done

# Add labels and taints
for item in "${_nodeHostnames[@]}"; do
  echo "Adding labels and taints to node ${item}.."
  kubectl label nodes $item "node-type=storage" --overwrite
  kubectl taint nodes $item "storage-only=true:NoSchedule" --overwrite
done
