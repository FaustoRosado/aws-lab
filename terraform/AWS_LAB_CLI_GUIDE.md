# AWS Security Lab - CLI Commands & Deployment Guide

## Prerequisites Check
```bash
# Check AWS CLI version
aws --version

# Check Terraform version  
terraform --version

# Verify AWS credentials
aws sts get-caller-identity
```

## AWS Configuration
```bash
# Configure AWS CLI (Windows PowerShell)
aws configure

# Enter your credentials:
# AWS Access Key ID: [Your Access Key]
# AWS Secret Access Key: [Your Secret Key]  
# Default region name: us-east-1
# Default output format: json
```

## Repository Setup

### Clone the AWS Security Lab Repository
```bash
# Windows PowerShell
git clone https://github.com/FaustoRosado/aws-lab.git
cd aws-lab/terraform

# Mac/Linux Terminal
git clone https://github.com/FaustoRosado/aws-lab.git
cd aws-lab/terraform
```

### Verify Repository Contents
```bash
# List all files and directories
ls -la

# Check Terraform files
ls *.tf

# Check modules directory
ls modules/
```

### Repository Structure
The repository contains:
- `main.tf` - Main Terraform configuration
- `variables.tf` - Input variables
- `outputs.tf` - Output values
- `modules/` - Reusable Terraform modules
- `fast_cleanup.ps1` - Windows cleanup script
- `fast_cleanup.sh` - Linux/Mac cleanup script
- `README.md` - Project documentation

## Lab Deployment Steps

### Step 1: Initialize Terraform
```bash
terraform init
```

### Step 2: Validate Configuration
```bash
terraform validate
```

### Step 3: Plan Deployment
```bash
terraform plan
```

### Step 4: Deploy Infrastructure
```bash
# Auto-approve deployment
terraform apply -auto-approve
```

## Verify Deployment

### Check AWS Resources
```bash
# List EC2 instances
aws ec2 describe-instances --filters "Name=tag:Project,Values=EC2-Compromise-Lab" --query 'Reservations[*].Instances[*].[InstanceId,State.Name,PublicIpAddress,Tags[?Key==`Name`].Value|[0]]' --output table

# List S3 buckets
aws s3 ls

# List VPCs
aws ec2 describe-vpcs --filters "Name=tag:Project,Values=EC2-Compromise-Lab" --query 'Vpcs[*].[VpcId,CidrBlock,Tags[?Key==`Name`].Value|[0]]' --output table
```

### Check Terraform Outputs
```bash
terraform output
```

## Lab Cleanup

### Option 1: Standard Terraform Destroy
```bash
terraform destroy -auto-approve
```

### Option 2: Fast Cleanup (If Terraform Gets Stuck)
```bash
# Windows PowerShell
.\fast_cleanup.ps1

# Mac/Linux Terminal  
./fast_cleanup.sh
```

## Expected Errors (Free Tier Limitations)

### GuardDuty & Security Hub Failures
These services require paid AWS accounts and will fail on free tier:
- `SubscriptionRequiredException` - Expected
- `AuthorizationError` - Expected

### What Still Works
- VPC & Subnets  
- EC2 Instances  
- Security Groups  
- S3 Bucket  
- CloudWatch  
- IAM Roles  

## Learning Objectives

### Infrastructure as Code (IaC)
- Terraform HCL syntax
- AWS resource management
- State management
- Module organization

### AWS Security Fundamentals
- VPC security groups
- IAM role-based access
- S3 bucket policies
- Network segmentation

### Real-World Scenarios
- Service limitations
- Error handling
- Resource cleanup
- Cost management

## Additional Commands

### Check Resource Tags
```bash
# Find all resources with lab tags
aws resourcegroupstaggingapi get-resources --tag-filters Key=Project,Values=EC2-Compromise-Lab
```

### Monitor CloudWatch
```bash
# List CloudWatch dashboards
aws cloudwatch list-dashboards

# List CloudWatch alarms
aws cloudwatch describe-alarms
```

### S3 Operations
```bash
# List S3 bucket contents
aws s3 ls s3://ec2-compromise-lab-threat-intel/

# Download sample threat data
aws s3 cp s3://ec2-compromise-lab-threat-intel/threats/ s3-threats/ --recursive
```

## Troubleshooting

### Common Issues
1. **AWS credentials not configured**
   - Run `aws configure`

2. **Terraform state locked**
   - Wait for other operations to complete

3. **S3 bucket not empty during destroy**
   - Use fast cleanup scripts

4. **EC2 instances stuck terminating**
   - Force stop in AWS Console

### Get Help
- Check Terraform logs: `terraform plan -detailed-exitcode`
- Verify AWS permissions: `aws iam get-user`
- Check resource status in AWS Console

## Success Criteria

Your lab is successfully deployed when:
- Terraform apply completes without errors  
- EC2 instances show "running" status  
- S3 bucket is accessible  
- VPC and subnets are created  
- Security groups are configured  

## Notes for Students

- **Keep AWS credentials secure** - Never commit to Git
- **Monitor costs** - Free tier has limits
- **Clean up resources** - Avoid unexpected charges
- **Document learnings** - Build your AWS knowledge base

---
*This lab provides hands-on experience with AWS infrastructure as code, perfect for cybersecurity professionals learning cloud security.*
