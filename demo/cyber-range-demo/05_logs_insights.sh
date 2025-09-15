#!/bin/zsh
set -euo pipefail
LG=$(aws logs describe-log-groups --query "logGroups[?contains(logGroupName, 'access') || contains(logGroupName,'target')].logGroupName | [0]" --output text)
if [ "$LG" = "None" ]; then
  echo "No candidate log group found"; exit 0
fi
echo "Querying log group: $LG"
QID=$(aws logs start-query --log-group-name "$LG" \
  --start-time $(($(date +%s)-900)) --end-time $(date +%s) \
  --query-string 'fields @timestamp, @message | filter @message like /<script>/ or @message like /union select/ or @message like /;whoami/ | sort @timestamp desc | limit 20' \
  --query 'queryId' --output text)
sleep 4
aws logs get-query-results --query-id "$QID"
