#!/bin/zsh
set -euo pipefail
echo "[Plan] Moving into Terraform directory..."

# Find terraform directory from current location
if [ -d "p2w12-quantum-shield/terraform" ]; then
    cd p2w12-quantum-shield/terraform
elif [ -d "../../p2w12-quantum-shield/terraform" ]; then
    cd "../../p2w12-quantum-shield/terraform"
elif [ -d "terraform" ]; then
    cd terraform
else
    echo "Error: Cannot find terraform directory (looking for p2w12-quantum-shield/terraform or terraform)"
    exit 1
fi

echo "[Plan] Running: terraform plan -out=tfplan"
terraform plan -out=tfplan
echo "[Plan] Done. Next: run ./03_apply.sh"