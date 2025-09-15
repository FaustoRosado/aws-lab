#!/bin/zsh
set -euo pipefail
: ${AWS_PROFILE:?Set AWS_PROFILE}; : ${AWS_REGION:=us-east-1}
SESSION="qs-view-$(date +%Y%m%d-%H%M)"
read -r -d '' POLICY <<'JSON'
{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Action":["ec2:Describe*","vpc:Describe*","logs:Describe*","logs:Get*","logs:FilterLogEvents","cloudwatch:Describe*","cloudwatch:Get*","cloudwatch:List*","guardduty:Get*","guardduty:List*","securityhub:Get*","securityhub:List*","s3:ListAllMyBuckets","s3:Get*","iam:ListAccountAliases"],"Resource":"*"}]}
JSON
CREDS=$(aws sts get-federation-token --name "$SESSION" --duration-seconds 43200 --policy "$POLICY" --query 'Credentials' --output json)
urlenc() { python3 - <<PY "$1"
import sys, urllib.parse as u; print(u.quote(sys.argv[1], safe=''))
PY
}
SESS=$(python3 - <<PY "$CREDS"
import json,sys; c=json.loads(sys.argv[1]); print(json.dumps({"sessionId":c["AccessKeyId"],"sessionKey":c["SecretAccessKey"],"sessionToken":c["SessionToken"]}))
PY
)
SESS_ENC=$(urlenc "$SESS")
TOKEN=$(curl -fsS "https://signin.aws.amazon.com/federation?Action=getSigninToken&SessionType=json&Session=${SESS_ENC}" | jq -r .SigninToken)
DEST=$(urlenc "https://console.aws.amazon.com/console/home?region=${AWS_REGION}")
echo "Share this read-only console URL (valid up to 12h):"
echo "https://signin.aws.amazon.com/federation?Action=login&Issuer=QS-Demo&Destination=${DEST}&SigninToken=${TOKEN}"
