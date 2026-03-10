#!/usr/bin/env bash
set -euo pipefail
mkdir /tmp/shon #Test
echo "==> Waiting for cloud-init to finish..."
sudo cloud-init status --wait || true

echo "==> Updating package list..."
sudo apt-get update -qq

echo "==> Installing common packages..."
sudo apt-get install -y -qq \
  qemu-guest-agent \
  curl \
  wget \
  git \
  vim \
  htop \
  jq \
  unzip \
  ca-certificates \
  gnupg \
  net-tools

echo "==> Enabling qemu-guest-agent..."
sudo systemctl enable qemu-guest-agent
sudo systemctl start qemu-guest-agent || true

echo "==> Common packages installed."