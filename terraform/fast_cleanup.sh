#!/bin/bash

# Fast Cleanup Script for AWS Security Lab
# Use this if terraform destroy gets stuck or takes too long
# Designed for cybersecurity professionals who need speed!

echo "🚀 FAST CLEANUP: AWS Security Lab"
echo "====================================="

# Check if AWS CLI is configured
if ! aws sts get-caller-identity --query 'Account' --output text >/dev/null 2>&1; then
    echo "❌ AWS CLI not configured. Run 'aws configure' first."
    exit 1
fi

ACCOUNT=$(aws sts get-caller-identity --query 'Account' --output text)
echo "✅ AWS Account: $ACCOUNT"

echo ""
echo "🔍 Finding lab resources..."

# Find and terminate EC2 instances
echo ""
echo "🖥️  Terminating EC2 instances..."
INSTANCES=$(aws ec2 describe-instances --filters "Name=tag:Project,Values=EC2-Compromise-Lab" --query 'Reservations[*].Instances[*].[InstanceId,State.Name]' --output text 2>/dev/null)

if [ -n "$INSTANCES" ]; then
    INSTANCE_IDS=$(echo "$INSTANCES" | grep 'i-' | awk '{print $1}' | tr '\n' ' ')
    if [ -n "$INSTANCE_IDS" ]; then
        echo "Found instances: $INSTANCE_IDS"
        aws ec2 terminate-instances --instance-ids $INSTANCE_IDS
        echo "✅ EC2 instances terminated"
    fi
else
    echo "No EC2 instances found"
fi

# Find and delete S3 bucket
echo ""
echo "🪣 Deleting S3 bucket..."
BUCKET_NAME="ec2-compromise-lab-threat-intel"

# Force delete all objects and bucket
aws s3 rm "s3://$BUCKET_NAME" --recursive 2>/dev/null
aws s3 rb "s3://$BUCKET_NAME" --force 2>/dev/null
echo "✅ S3 bucket deleted"

# Find and delete VPC
echo ""
echo "🌐 Deleting VPC..."
VPCS=$(aws ec2 describe-vpcs --filters "Name=tag:Project,Values=EC2-Compromise-Lab" --query 'Vpcs[*].[VpcId]' --output text 2>/dev/null)

if [ -n "$VPCS" ]; then
    VPC_ID=$(echo "$VPCS" | tr -d ' ')
    echo "Found VPC: $VPC_ID"
    
    # Delete VPC endpoints, subnets, route tables, internet gateway
    aws ec2 delete-vpc --vpc-id "$VPC_ID" --force 2>/dev/null
    echo "✅ VPC deleted"
else
    echo "No VPC found"
fi

# Clean up IAM roles
echo ""
echo "🔐 Cleaning up IAM roles..."
ROLES=("lab-ec2-role" "lab-lambda-role")

for ROLE in "${ROLES[@]}"; do
    # Detach policies and delete role
    POLICIES=$(aws iam list-attached-role-policies --role-name "$ROLE" --query 'AttachedPolicies[*].PolicyArn' --output text 2>/dev/null)
    if [ -n "$POLICIES" ]; then
        for POLICY in $POLICIES; do
            aws iam detach-role-policy --role-name "$ROLE" --policy-arn "$POLICY" 2>/dev/null
        done
    fi
    aws iam delete-role --role-name "$ROLE" 2>/dev/null
    echo "✅ IAM role $ROLE deleted"
done

# Clean up CloudWatch resources
echo ""
echo "📊 Cleaning up CloudWatch resources..."
aws cloudwatch delete-dashboard --dashboard-name "lab-security-dashboard" 2>/dev/null
echo "✅ CloudWatch dashboard deleted"

echo ""
echo "🎯 FAST CLEANUP COMPLETE!"
echo "====================================="
echo "All lab resources have been cleaned up."
echo "You can now run 'terraform apply' again for a fresh deployment."
echo ""
echo "💡 Pro tip: Use 'terraform destroy -auto-approve' for future cleanups!"
