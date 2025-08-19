# AWS Security Lab Setup Guide

This comprehensive guide walks you through setting up and running the AWS Security Lab from start to finish.

## Overview

The AWS Security Lab is designed to teach you practical cloud security skills through hands-on experience. You'll learn how to:
- Deploy secure infrastructure using Infrastructure as Code
- Implement security monitoring and threat detection
- Manage access control and identity management
- Monitor and respond to security incidents
- Clean up resources to avoid unnecessary costs

## Prerequisites

Before starting this lab, ensure you have:

1. **AWS Account Setup**
   - Active AWS account with billing enabled
   - IAM user with appropriate permissions
   - Access keys configured

2. **Local Environment**
   - AWS CLI installed and configured
   - Terraform installed (version 1.0+)
   - Git for version control
   - Text editor (VS Code, Sublime, etc.)

3. **Knowledge Requirements**
   - Basic understanding of AWS services
   - Familiarity with command line operations
   - Understanding of basic networking concepts

## Quick Start

### Step 1: Clone the Repository

```bash
# Clone the lab repository
git clone https://github.com/yourusername/aws-security-lab.git
cd aws-security-lab

# Verify the structure
ls -la
```

### Step 2: Configure Your Environment

```bash
# Copy the environment template
cp env.template .env.lab

# Edit with your AWS credentials
nano .env.lab  # or use your preferred editor
```

### Step 3: Deploy Infrastructure

```bash
# Navigate to Terraform directory
cd terraform

# Initialize Terraform
terraform init

# Plan the deployment
terraform plan

# Apply the configuration
terraform apply
```

## Detailed Setup Instructions

### Phase 1: Environment Preparation

#### 1.1 AWS Account Verification

1. **Check Account Status**
   ```bash
   aws sts get-caller-identity
   ```

2. **Verify Permissions**
   ```bash
   aws iam get-user
   aws iam list-attached-user-policies --user-name YOUR_USERNAME
   ```

3. **Set Default Region**
   ```bash
   aws configure set default.region us-east-1
   ```

#### 1.2 Local Tool Verification

1. **Check AWS CLI**
   ```bash
   aws --version
   # Should show version 2.x.x
   ```

2. **Check Terraform**
   ```bash
   terraform --version
   # Should show version 1.0+
   ```

3. **Check Git**
   ```bash
   git --version
   ```

### Phase 2: Infrastructure Deployment

#### 2.1 VPC and Networking

1. **Navigate to VPC Module**
   ```bash
   cd terraform/modules/vpc
   ```

2. **Review Configuration**
   ```bash
   # Check the main.tf file
   cat main.tf
   
   # Review variables
   cat variables.tf
   ```

3. **Deploy VPC**
   ```bash
   # From terraform root directory
   terraform apply -target=module.vpc
   ```

#### 2.2 Security Groups

1. **Deploy Security Groups**
   ```bash
   terraform apply -target=module.security_groups
   ```

2. **Verify Creation**
   ```bash
   aws ec2 describe-security-groups --filters "Name=group-name,Values=*lab*"
   ```

#### 2.3 EC2 Instances

1. **Deploy EC2 Infrastructure**
   ```bash
   terraform apply -target=module.ec2
   ```

2. **Wait for Instances**
   ```bash
   # Check instance status
   aws ec2 describe-instances --filters "Name=tag:Environment,Values=lab"
   ```

#### 2.4 Security Services

1. **Deploy GuardDuty**
   ```bash
   terraform apply -target=module.guardduty
   ```

2. **Deploy Security Hub**
   ```bash
   terraform apply -target=module.security_hub
   ```

3. **Deploy CloudWatch**
   ```bash
   terraform apply -target=module.cloudwatch
   ```

### Phase 3: Configuration and Testing

#### 3.1 Security Group Verification

1. **Check Security Group Rules**
   ```bash
   # Get security group IDs
   aws ec2 describe-security-groups --filters "Name=tag:Environment,Values=lab"
   
   # Check specific rules
   aws ec2 describe-security-group-rules --filters "Name=group-id,Values=sg-xxxxxxxxx"
   ```

2. **Test Network Connectivity**
   ```bash
   # Test web server access
   curl http://[WEB_SERVER_PUBLIC_IP]
   
   # Test SSH access (if configured)
   ssh -i ssh/lab-key ec2-user@[WEB_SERVER_PUBLIC_IP]
   ```

#### 3.2 Security Service Configuration

1. **GuardDuty Setup**
   ```bash
   # Check detector status
   aws guardduty list-detectors
   
   # View findings (initially empty)
   aws guardduty list-findings --detector-id [DETECTOR_ID]
   ```

2. **Security Hub Setup**
   ```bash
   # Check hub status
   aws securityhub describe-hub
   
   # List enabled standards
   aws securityhub describe-standards
   ```

3. **CloudWatch Configuration**
   ```bash
   # List log groups
   aws logs describe-log-groups
   
   # Check metrics
   aws cloudwatch list-metrics --namespace AWS/EC2
   ```

## Lab Exercises

### Exercise 1: Basic Security Monitoring

1. **Generate Test Traffic**
   ```bash
   # Access your web server
   curl http://[WEB_SERVER_IP]
   
   # Check CloudWatch logs
   aws logs describe-log-streams --log-group-name /aws/ec2/lab-web-server
   ```

2. **Review Security Findings**
   - Check GuardDuty console for any findings
   - Review Security Hub for compliance status
   - Monitor CloudWatch metrics for unusual activity

### Exercise 2: Access Control Testing

1. **Test Security Group Rules**
   ```bash
   # Try to access blocked ports
   telnet [WEB_SERVER_IP] 22  # Should be blocked
   telnet [WEB_SERVER_IP] 80  # Should be allowed
   ```

2. **Verify IAM Permissions**
   ```bash
   # Test different permission levels
   aws s3 ls  # Should work if you have S3 permissions
   aws iam list-users  # May be restricted
   ```

### Exercise 3: Incident Response Simulation

1. **Simulate Security Event**
   ```bash
   # Create unusual API calls
   aws ec2 describe-instances --max-items 1000
   
   # Check GuardDuty for findings
   aws guardduty list-findings --detector-id [DETECTOR_ID]
   ```

2. **Review Response Procedures**
   - Document the incident
   - Implement containment measures
   - Review and update procedures

## Monitoring and Maintenance

### Daily Monitoring

1. **Check Resource Status**
   ```bash
   # Instance health
   aws ec2 describe-instances --filters "Name=instance-state-name,Values=running"
   
   # Security findings
   aws guardduty list-findings --detector-id [DETECTOR_ID]
   ```

2. **Review Costs**
   ```bash
   # Check current month costs
   aws ce get-cost-and-usage --time-period Start=2024-01-01,End=2024-01-31 --granularity MONTHLY --metrics BlendedCost
   ```

### Weekly Maintenance

1. **Security Review**
   - Review GuardDuty findings
   - Check Security Hub compliance
   - Update security group rules if needed

2. **Performance Review**
   - Analyze CloudWatch metrics
   - Review log data for anomalies
   - Optimize resource usage

### Monthly Tasks

1. **Access Review**
   - Review IAM user permissions
   - Rotate access keys
   - Update security policies

2. **Compliance Check**
   - Review security standards
   - Update documentation
   - Plan security improvements

## Troubleshooting

### Common Issues

#### Terraform Errors

1. **State Lock Issues**
   ```bash
   # Force unlock if needed
   terraform force-unlock [LOCK_ID]
   ```

2. **Provider Issues**
   ```bash
   # Reinitialize providers
   terraform init -upgrade
   ```

3. **State Conflicts**
   ```bash
   # Refresh state
   terraform refresh
   
   # Import existing resources if needed
   terraform import aws_instance.web_server i-1234567890abcdef0
   ```

#### AWS Service Issues

1. **Permission Errors**
   ```bash
   # Check current identity
   aws sts get-caller-identity
   
   # Verify permissions
   aws iam simulate-principal-policy --policy-source-arn [USER_ARN] --action-names ec2:DescribeInstances
   ```

2. **Service Limits**
   ```bash
   # Check service quotas
   aws service-quotas get-service-quota --service-code ec2 --quota-code L-1216C47A
   ```

3. **Region Issues**
   ```bash
   # Verify region availability
   aws ec2 describe-regions --region-names us-east-1
   ```

### Getting Help

1. **Check Logs**
   ```bash
   # Terraform logs
   terraform plan -detailed-exitcode
   
   # AWS service logs
   aws logs describe-log-streams --log-group-name [LOG_GROUP]
   ```

2. **Community Resources**
   - GitHub Issues
   - AWS Documentation
   - Terraform Documentation
   - Stack Overflow

3. **Professional Support**
   - AWS Support (if you have a support plan)
   - Terraform Enterprise support
   - Professional consulting services

## Cleanup and Cost Management

### Resource Cleanup

1. **Destroy Infrastructure**
   ```bash
   # From terraform directory
   terraform destroy
   
   # Confirm destruction
   # Type 'yes' when prompted
   ```

2. **Verify Cleanup**
   ```bash
   # Check for remaining resources
   aws ec2 describe-instances --filters "Name=tag:Environment,Values=lab"
   aws s3 ls | grep lab
   ```

3. **Manual Cleanup**
   ```bash
   # Remove any remaining resources manually
   aws ec2 terminate-instances --instance-ids i-1234567890abcdef0
   aws s3 rb s3://bucket-name --force
   ```

### Cost Optimization

1. **Set Budget Alerts**
   ```bash
   # Create budget
   aws budgets create-budget --account-id [ACCOUNT_ID] --budget [BUDGET_JSON]
   ```

2. **Monitor Usage**
   ```bash
   # Daily cost tracking
   aws ce get-cost-and-usage --time-period Start=2024-01-01,End=2024-01-01 --granularity DAILY --metrics BlendedCost
   ```

3. **Resource Tagging**
   - Tag all resources for cost allocation
   - Use consistent naming conventions
   - Implement automated tagging policies

## Advanced Configurations

### Multi-Region Deployment

1. **Configure Providers**
   ```hcl
   # In main.tf
   provider "aws" {
     region = "us-east-1"
     alias  = "primary"
   }
   
   provider "aws" {
     region = "us-west-2"
     alias  = "secondary"
   }
   ```

2. **Deploy to Multiple Regions**
   ```bash
   terraform apply -var="enable_multi_region=true"
   ```

### High Availability Setup

1. **Multi-AZ Configuration**
   ```hcl
   # In variables.tf
   variable "availability_zones" {
     description = "Number of availability zones"
     type        = number
     default     = 3
   }
   ```

2. **Load Balancer Configuration**
   ```bash
   # Deploy with high availability
   terraform apply -var="enable_ha=true"
   ```

### Custom Security Policies

1. **Create Custom IAM Policies**
   ```hcl
   # In iam/main.tf
   resource "aws_iam_policy" "custom_security_policy" {
     name        = "custom-security-policy"
     description = "Custom security policy for lab"
     
     policy = jsonencode({
       Version = "2012-10-17"
       Statement = [
         {
           Effect = "Allow"
           Action = [
             "ec2:Describe*",
             "s3:Get*"
           ]
           Resource = "*"
         }
       ]
     })
   }
   ```

2. **Apply Custom Policies**
   ```bash
   terraform apply -target=module.iam
   ```

## Next Steps

After completing the basic lab setup:

1. **Explore Advanced Features**
   - Implement automated response workflows
   - Set up cross-account monitoring
   - Deploy additional security services

2. **Customize for Your Needs**
   - Modify security policies
   - Add custom monitoring rules
   - Integrate with existing tools

3. **Production Considerations**
   - Implement proper backup strategies
   - Set up disaster recovery procedures
   - Establish change management processes

4. **Continuous Learning**
   - Stay updated with AWS security features
   - Participate in security communities
   - Attend security conferences and training

## Support and Resources

### Documentation

- [AWS Security Documentation](https://docs.aws.amazon.com/security/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Security Best Practices](https://aws.amazon.com/security/security-learning/)

### Community

- [AWS Security Blog](https://aws.amazon.com/blogs/security/)
- [Terraform Community](https://discuss.hashicorp.com/)
- [AWS User Groups](https://aws.amazon.com/developer/community/usergroups/)

### Training

- [AWS Security Fundamentals](https://aws.amazon.com/training/security/)
- [Terraform Certification](https://www.hashicorp.com/certification/terraform-associate)
- [Cloud Security Alliance](https://cloudsecurityalliance.org/)

---

**Remember**: This lab is designed for learning and development purposes. Always follow security best practices and never deploy untested configurations to production environments.
