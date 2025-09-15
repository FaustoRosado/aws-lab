#!/bin/zsh
set -euo pipefail

echo "[Setup] Creating SSH keys for demo..."
mkdir -p terraform/modules/ec2/ssh
if [ ! -f terraform/modules/ec2/ssh/lab-key ]; then
    echo "[Setup] Generating new SSH key pair..."
    ssh-keygen -t rsa -b 2048 -f terraform/modules/ec2/ssh/lab-key -N ""
    echo "[Setup] SSH key pair created"
else
    echo "[Setup] SSH key pair already exists"
fi
echo "[Setup] Done. Next: run ./01_init.sh"
