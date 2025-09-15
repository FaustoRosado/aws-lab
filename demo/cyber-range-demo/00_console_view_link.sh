#!/bin/zsh
set -euo pipefail

echo "[Console Link] Ensure AWS_PROFILE is set (read-only viewer link)."
: ${AWS_PROFILE:?Set AWS_PROFILE}; : ${AWS_REGION:=us-east-1}
echo "[Console Link] Region: ${AWS_REGION}"

SESSION="qs-view-$(date +%Y%m%d-%H%M)"
POLICY='{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Action":["ec2:Describe*","vpc:Describe*","logs:Describe*","logs:Get*","logs:FilterLogEvents","cloudwatch:Describe*","cloudwatch:Get*","cloudwatch:List*","guardduty:Get*","guardduty:List*","securityhub:Get*","securityhub:List*","s3:ListAllMyBuckets","s3:Get*","iam:ListAccountAliases"],"Resource":"*"}]}'

echo "[Console Link] Requesting federation token (12h)..."
CREDS=$(aws sts get-federation-token --name "$SESSION" --duration-seconds 43200 --policy "$POLICY" --query 'Credentials' --output json)

# Create session JSON for federation
SESS=$(echo "$CREDS" | jq -c '{sessionId:.AccessKeyId,sessionKey:.SecretAccessKey,sessionToken:.SessionToken}')

# URL encode the session
SESS_ENC=$(python3 -c 'import sys,urllib.parse as u; print(u.quote(sys.stdin.read().strip(), safe=""))' <<< "$SESS")

# Get signin token
echo "[Console Link] Getting signin token..."
TOKEN=$(curl -fsS "https://signin.aws.amazon.com/federation?Action=getSigninToken&SessionType=json&Session=${SESS_ENC}" | jq -r .SigninToken)

# Create destination URL
DEST=$(python3 -c "import os,urllib.parse as u; print(u.quote(f'https://console.aws.amazon.com/console/home?region={os.environ.get(\"AWS_REGION\",\"us-east-1\")}', safe=''))")

# Final federation URL
echo ""
echo "[Console Link] Share this read-only console URL (valid up to 12h):"
echo "https://signin.aws.amazon.com/federation?Action=login&Issuer=QS-Demo&Destination=${DEST}&SigninToken=${TOKEN}"
echo ""
echo "[Console Link] Copy the URL above, shorten it at is.gd, then paste in Zoom chat"