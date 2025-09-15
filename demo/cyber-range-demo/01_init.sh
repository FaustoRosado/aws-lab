#!/bin/zsh
set -euo pipefail
echo "[Init] Using AWS profile: ${AWS_PROFILE:-not set}  Region: ${AWS_REGION:-not set}"
echo "[Init] Moving into Terraform directory..."

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

echo "[Init] Running: terraform init"
terraform init
echo "[Init] Running: terraform validate"
terraform validate
echo "[Init] Done. Next: run ./02_plan.sh"