#!/usr/bin/env bash
set -euo pipefail

echo "==> Waiting for cloud-init to finish..."
sudo cloud-init status --wait || true

echo "==> Updating package list..."
sudo dnf update -y -q

echo "==> Installing common packages..."
sudo dnf install -y \
  qemu-guest-agent \
  curl \
  wget \
  git \
  vim \
  htop \
  jq \
  unzip \
  ca-certificates \
  gnupg2 \
  net-tools

echo "==> Enabling qemu-guest-agent..."
sudo systemctl enable qemu-guest-agent
sudo systemctl start qemu-guest-agent || true

echo "==> Common packages installed."
