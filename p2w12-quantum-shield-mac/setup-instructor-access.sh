#!/bin/bash
# setup-instructor-access.sh
# Advanced Cyber Range - Instructor Access Setup (Mac Bash Optimized)

set -e

echo "Advanced Cyber Range - Instructor Access Setup (Mac Bash)"
echo "========================================================"

# Check if Homebrew is available (Mac package manager)
if ! command -v brew &> /dev/null; then
    echo "Warning: Homebrew not found. Please install from https://brew.sh/"
    echo "This will ensure all required tools are available."
fi

# Check if Terraform is available
if ! command -v terraform &> /dev/null; then
    echo "Error: Terraform is not installed or not in PATH"
    echo "Install with: brew install terraform"
    exit 1
fi

# Check if AWS CLI is available
if ! command -v aws &> /dev/null; then
    echo "Error: AWS CLI is not installed or not in PATH"
    echo "Install with: brew install awscli"
    exit 1
fi

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Installing with Homebrew..."
    if command -v brew &> /dev/null; then
        brew install jq
    else
        echo "Please install jq manually or install Homebrew first"
        exit 1
    fi
fi

# Navigate to terraform directory
cd "$(dirname "$0")/terraform" || {
    echo "Error: Could not navigate to terraform directory"
    exit 1
}

# Check if terraform is initialized
if [ ! -d ".terraform" ]; then
    echo "Error: Terraform not initialized. Please run 'terraform init' first."
    exit 1
fi

# Get the role ARN from Terraform output
echo "Retrieving instructor role ARN..."
ROLE_ARN=$(terraform output -raw instructor_role_arn 2>/dev/null || {
    echo "Error: Could not retrieve instructor_role_arn from Terraform output"
    echo "Please ensure the infrastructure is deployed and the role exists."
    exit 1
})

echo "Role ARN: $ROLE_ARN"

# Create .aws directory if it doesn't exist (Mac standard location)
mkdir -p ~/.aws

# Assume the role and get temporary credentials
echo "Requesting temporary credentials..."
aws sts assume-role \
  --role-arn "$ROLE_ARN" \
  --role-session-name "InstructorDemo-$(date +%Y%m%d-%H%M%S)" \
  --duration-seconds 86400 \
  --output json > ~/.aws/instructor-creds.json

# Extract credentials
export AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' ~/.aws/instructor-creds.json)
export AWS_SECRET_ACCESS_KEY=$(jq -r '.Credentials.SecretAccessKey' ~/.aws/instructor-creds.json)
export AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken' ~/.aws/instructor-creds.json)

# Store in AWS CLI profile
echo "Configuring AWS CLI profile..."
aws configure set aws_access_key_id "$AWS_ACCESS_KEY_ID" --profile instructor-temp
aws configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY" --profile instructor-temp
aws configure set aws_session_token "$AWS_SESSION_TOKEN" --profile instructor-temp

# Set expiration time (24 hours from now) - Mac date command
EXPIRATION=$(date -v+24H -u +%Y-%m-%dT%H:%M:%SZ)
aws configure set expiration "$EXPIRATION" --profile instructor-temp

# Set region (use default or specify)
DEFAULT_REGION=$(aws configure get region --profile default 2>/dev/null || echo "us-east-1")
aws configure set region "$DEFAULT_REGION" --profile instructor-temp

echo ""
echo "Temporary credentials configured successfully!"
echo "============================================"
echo "Profile: instructor-temp"
echo "Region: $DEFAULT_REGION"
echo "Expires: $EXPIRATION"
echo ""
echo "Next Steps:"
echo "1. Use AWS CLI with profile: aws ec2 describe-instances --profile instructor-temp"
echo "2. Access AWS Console with credentials from ~/.aws/instructor-creds.json"
echo "3. Credentials will automatically expire in 24 hours"
echo ""
echo "To check available profiles: aws configure list-profiles"
echo "To view credentials: cat ~/.aws/instructor-creds.json"
echo ""
echo "Mac-specific Notes:"
echo "- Credentials stored in ~/.aws/ (standard Mac location)"
echo "- Use Terminal.app or iTerm2 for best experience"
echo "- Consider adding to your shell profile: export AWS_PROFILE=instructor-temp"
