#!/bin/zsh
set -euo pipefail
echo "[Init] Using AWS profile: ${AWS_PROFILE:-not set}  Region: ${AWS_REGION:-not set}"
echo "[Init] Moving into Terraform directory..."
cd "$(dirname "$0")/../../terraform"
echo "[Init] Running: terraform init"
terraform init
echo "[Init] Running: terraform validate"
terraform validate
echo "[Init] Done. Next: run ./02_plan.sh"
