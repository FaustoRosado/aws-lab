#!/bin/zsh
set -euo pipefail
cd "$(dirname "$0")/../../terraform"
terraform plan -out=tfplan
