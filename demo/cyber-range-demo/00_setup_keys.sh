#!/bin/zsh
set -euo pipefail

echo "[Setup] Creating SSH keys for demo..."

# Find terraform directory and create SSH keys
if [ -d "p2w12-quantum-shield/terraform" ]; then
    mkdir -p p2w12-quantum-shield/terraform/modules/ec2/ssh
    KEY_PATH="p2w12-quantum-shield/terraform/modules/ec2/ssh/lab-key"
elif [ -d "../../p2w12-quantum-shield/terraform" ]; then
    mkdir -p ../../p2w12-quantum-shield/terraform/modules/ec2/ssh
    KEY_PATH="../../p2w12-quantum-shield/terraform/modules/ec2/ssh/lab-key"
elif [ -d "terraform" ]; then
    mkdir -p terraform/modules/ec2/ssh
    KEY_PATH="terraform/modules/ec2/ssh/lab-key"
else
    echo "Error: Cannot find terraform directory (looking for p2w12-quantum-shield/terraform or terraform)"
    exit 1
fi

if [ ! -f "$KEY_PATH" ]; then
    echo "[Setup] Generating new SSH key pair..."
    ssh-keygen -t rsa -b 2048 -f "$KEY_PATH" -N ""
    echo "[Setup] SSH key pair created at: $KEY_PATH"
else
    echo "[Setup] SSH key pair already exists at: $KEY_PATH"
fi
echo "[Setup] Done. Next: run ./01_init.sh"