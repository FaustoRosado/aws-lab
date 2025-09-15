#!/bin/zsh
set -euo pipefail
echo "[Plan] Moving into Terraform directory..."

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

echo "[Plan] Running: terraform plan -out=tfplan"
terraform plan -out=tfplan
echo "[Plan] Done. Next: run ./03_apply.sh"