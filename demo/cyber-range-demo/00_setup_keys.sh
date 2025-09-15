#!/bin/zsh
set -euo pipefail

echo "[Setup] Creating SSH keys for demo..."

# Find terraform directory and create SSH keys
if [ -d "terraform" ]; then
    mkdir -p terraform/modules/ec2/ssh
    KEY_PATH="terraform/modules/ec2/ssh/lab-key"
elif [ -d "../../terraform" ]; then
    mkdir -p ../../terraform/modules/ec2/ssh
    KEY_PATH="../../terraform/modules/ec2/ssh/lab-key"
elif [ -d "../terraform" ]; then
    mkdir -p ../terraform/modules/ec2/ssh
    KEY_PATH="../terraform/modules/ec2/ssh/lab-key"
else
    echo "Error: Cannot find terraform directory"
    exit 1
fi

if [ ! -f "$KEY_PATH" ]; then
    echo "[Setup] Generating new SSH key pair..."
    ssh-keygen -t rsa -b 2048 -f "$KEY_PATH" -N ""
    echo "[Setup] SSH key pair created"
else
    echo "[Setup] SSH key pair already exists"
fi
echo "[Setup] Done. Next: run ./01_init.sh"