#!/bin/zsh
set -euo pipefail
echo "[Verify] Checking GuardDuty detector, Security Hub standards, and EC2 instances..."
DET=$(aws guardduty list-detectors --query 'DetectorIds[0]' --output text)
echo "GuardDuty Detector: $DET"
aws securityhub get-enabled-standards --query 'StandardsSubscriptions[].StandardsArn' --output table | cat
aws ec2 describe-instances --query 'Reservations[].Instances[].{ID:InstanceId,State:State.Name,Name:Tags[?Key==`Name`].Value|[0],Priv:PrivateIpAddress}' --output table | cat
if [ "$DET" != "None" ]; then
  aws guardduty list-findings --detector-id "$DET" --query 'FindingIds[0:5]' --output json | cat
fi
echo "[Verify] Done. Optional: run ./05_logs_insights.sh"
