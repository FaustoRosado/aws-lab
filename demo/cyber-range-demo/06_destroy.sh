#!/bin/zsh
set -euo pipefail
echo "[Destroy] Moving into Terraform directory..."

# Find terraform directory from current location
if [ -d "terraform" ]; then
    cd terraform
elif [ -d "../../terraform" ]; then
    cd "../../terraform"
elif [ -d "../terraform" ]; then
    cd "../terraform"
else
    echo "Error: Cannot find terraform directory"
    exit 1
fi

echo "[Destroy] Running: terraform destroy -auto-approve"
terraform destroy -auto-approve
echo "[Destroy] Environment torn down. Demo complete."