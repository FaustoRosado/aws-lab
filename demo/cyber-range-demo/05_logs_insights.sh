#!/bin/zsh
set -euo pipefail
echo "[Logs] Finding a recent log group (access/target)..."
LG=$(aws logs describe-log-groups --query "logGroups[?contains(logGroupName, 'access') || contains(logGroupName,'target')].logGroupName | [0]" --output text)
if [ "$LG" = "None" ]; then
  echo "[Logs] No candidate log group found"; exit 0
fi
echo "[Logs] Querying log group: $LG"
QID=$(aws logs start-query --log-group-name "$LG" \
  --start-time $(($(date +%s)-900)) --end-time $(date +%s) \
  --query-string 'fields @timestamp, @message | filter @message like /<script>/ or @message like /union select/ or @message like /;whoami/ | sort @timestamp desc | limit 20' \
  --query 'queryId' --output text)
sleep 4
aws logs get-query-results --query-id "$QID"
echo "[Logs] Done. Next: run ./06_destroy.sh when finished demo"
