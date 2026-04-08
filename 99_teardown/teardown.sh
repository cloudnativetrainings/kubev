#!/usr/bin/env bash

set -euo pipefail

kubeadm reset -f 
apt remove -y --allow-change-held-packages kubeadm
apt remove -y --allow-change-held-packages kubelet
apt remove -y --allow-change-held-packages kubectl
apt remove -y --allow-change-held-packages containerd.io

rm -rf /etc/kubernetes/
rm -rf /var/lib/etcd/
rm -rf /var/lib/kubelet/
rm -rf /etc/cni/

apt-mark unhold $(apt-mark showhold)

apt update && apt-get upgrade -y && apt auto-remove

