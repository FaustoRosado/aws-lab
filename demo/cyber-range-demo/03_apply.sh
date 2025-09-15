#!/bin/zsh
set -euo pipefail
echo "[Apply] Moving into Terraform directory..."

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

echo "[Apply] Running: terraform apply -auto-approve tfplan"
terraform apply -auto-approve tfplan
echo "[Apply] Done. Next: run ./04_verify_cli.sh"