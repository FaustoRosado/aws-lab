#!/bin/zsh
set -euo pipefail
echo "[Apply] Moving into Terraform directory..."
cd "$(dirname "$0")/../../terraform"
echo "[Apply] Running: terraform apply -auto-approve tfplan"
terraform apply -auto-approve tfplan
echo "[Apply] Done. Next: run ./04_verify_cli.sh"
