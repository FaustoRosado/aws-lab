#!/bin/zsh
set -euo pipefail
echo "[Destroy] Moving into Terraform directory..."
cd "$(dirname "$0")/../../terraform"
echo "[Destroy] Running: terraform destroy -auto-approve"
terraform destroy -auto-approve
echo "[Destroy] Environment torn down. Demo complete."
