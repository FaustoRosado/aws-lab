#!/bin/zsh
set -euo pipefail
echo "[Plan] Moving into Terraform directory..."
cd "$(dirname "$0")/../../terraform"
echo "[Plan] Running: terraform plan -out=tfplan"
terraform plan -out=tfplan
echo "[Plan] Done. Next: run ./03_apply.sh"
