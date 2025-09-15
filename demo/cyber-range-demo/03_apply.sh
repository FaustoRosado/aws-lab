#!/bin/zsh
set -euo pipefail
echo "[Apply] Moving into Terraform directory..."

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

echo "[Apply] Running: terraform apply -auto-approve tfplan"
terraform apply -auto-approve tfplan
echo "[Apply] Done. Next: run ./04_verify_cli.sh"