#!/bin/zsh
set -euo pipefail
cd "$(dirname "$0")/../../terraform"
terraform apply -auto-approve tfplan
