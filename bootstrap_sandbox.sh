
#!/bin/bash

set -euxo pipefail

export DEBIAN_FRONTEND=noninteractive

# ========================================
# System packages
# ========================================

apt-get update -y

apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  apt-transport-https

# ========================================
# Docker
# ========================================

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc

chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  > /etc/apt/sources.list.d/docker.list

apt-get update -y

apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin

systemctl enable docker
systemctl start docker

# Allow Ubuntu user to run Docker without sudo
usermod -aG docker ubuntu

# ========================================
# Kind
# ========================================

KIND_VERSION="v0.30.0"

curl -Lo /usr/local/bin/kind \
  "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64"

chmod +x /usr/local/bin/kind

# ========================================
# kubectl
# ========================================

KUBECTL_VERSION="$(curl -L -s https://dl.k8s.io/release/stable.txt)"

curl -Lo /usr/local/bin/kubectl \
  "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

chmod +x /usr/local/bin/kubectl

# ========================================
# Verify
# ========================================

docker --version
kind --version
kubectl version --client

echo "========================================"
echo "Docker installed successfully"
echo "Kind installed successfully"
echo "kubectl installed successfully"
echo "========================================"

