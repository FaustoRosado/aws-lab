#!/bin/zsh
set -euo pipefail
DET=$(aws guardduty list-detectors --query 'DetectorIds[0]' --output text)
echo "GuardDuty Detector: $DET"
aws securityhub get-enabled-standards --query 'StandardsSubscriptions[].StandardsArn' --output table | cat
aws ec2 describe-instances --query 'Reservations[].Instances[].{ID:InstanceId,State:State.Name,Name:Tags[?Key==`Name`].Value|[0],Priv:PrivateIpAddress}' --output table | cat
if [ "$DET" != "None" ]; then
  aws guardduty list-findings --detector-id "$DET" --query 'FindingIds[0:5]' --output json | cat
fi
