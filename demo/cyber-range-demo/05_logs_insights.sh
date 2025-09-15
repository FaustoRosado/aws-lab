#!/bin/zsh
set -euo pipefail
echo "[Logs] Finding recent log groups..."

# Look for common log group patterns in cyber range
LG=$(aws logs describe-log-groups --query "logGroups[?contains(logGroupName, 'vpcflow') || contains(logGroupName,'access') || contains(logGroupName,'target') || contains(logGroupName,'lab')].logGroupName | [0]" --output text)

if [ "$LG" = "None" ] || [ -z "$LG" ]; then
  echo "[Logs] No suitable log group found for demo"
  echo "[Logs] Available log groups:"
  aws logs describe-log-groups --query "logGroups[].logGroupName" --output table
  exit 0
fi

echo "[Logs] Querying log group: $LG"

# Query for network activity in VPC Flow Logs (more relevant for cyber range)
if [[ "$LG" == *"vpcflow"* ]]; then
  echo "[Logs] Searching VPC Flow Logs for network activity..."
  QID=$(aws logs start-query --log-group-name "$LG" \
    --start-time $(($(date +%s)-900)) --end-time $(date +%s) \
    --query-string 'fields @timestamp, @message | filter @message like /ACCEPT/ or @message like /REJECT/ | sort @timestamp desc | limit 20' \
    --query 'queryId' --output text)
else
  echo "[Logs] Searching application logs for security events..."
  QID=$(aws logs start-query --log-group-name "$LG" \
    --start-time $(($(date +%s)-900)) --end-time $(date +%s) \
    --query-string 'fields @timestamp, @message | filter @message like /<script>/ or @message like /union select/ or @message like /;whoami/ | sort @timestamp desc | limit 20' \
    --query 'queryId' --output text)
fi

sleep 4
aws logs get-query-results --query-id "$QID"
echo "[Logs] Done. Next: run ./06_destroy.sh when finished demo"