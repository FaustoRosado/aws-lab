# AWS Lab Setup Guide

## Prerequisites
- AWS Account with appropriate permissions
- AWS Access Key ID and Secret Access Key
- Windows 10/11 with PowerShell

## Tools Installed
✅ Terraform v1.12.2  
✅ AWS CLI v2.28.11  

## Step 1: Configure AWS Credentials

### Option A: Manual Configuration (Recommended for first-time setup)
1. Open the file: `C:\Users\[YourUsername]\.aws\credentials`
2. Replace the placeholder values with your actual AWS credentials:
   ```
   [default]
   aws_access_key_id = AKIAIOSFODNN7EXAMPLE
   aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
   ```

### Option B: AWS CLI Interactive Setup
Run this command and follow the prompts:
```powershell
aws configure
```

## Step 2: Verify AWS Connection
Test your connection with:
```powershell
aws sts get-caller-identity
```

You should see output like:
```json
{
    "UserId": "AIDACKCEVSQ6C2EXAMPLE",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/YourUsername"
}
```

## Step 3: Set Your AWS Region
The default region is set to `us-east-1`. To change it:
1. Edit `C:\Users\[YourUsername]\.aws\config`
2. Change the region value (e.g., `us-west-2`, `eu-west-1`)

## Step 4: Required AWS Permissions
Your AWS user/role needs these permissions:
- EC2: Create, modify, delete instances
- VPC: Create and manage networking
- IAM: Create roles and policies
- GuardDuty: Enable and configure
- Security Hub: Enable and configure
- S3: Create buckets and upload files
- CloudWatch: Create log groups and metrics

## Step 5: Run the Lab
1. Navigate to the terraform directory: `cd terraform`
2. Initialize Terraform: `terraform init`
3. Review the plan: `terraform plan`
4. Apply the infrastructure: `terraform apply`

## Security Notes
- Never commit AWS credentials to version control
- Use IAM roles with minimal required permissions
- Consider using temporary credentials for lab environments
- Clean up resources after completing the lab

## Troubleshooting
- If you get permission errors, check your IAM user permissions
- If region errors occur, verify your AWS config file
- For Terraform errors, ensure you have the required AWS permissions
