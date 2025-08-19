# Environment Template Guide

This guide explains how to use the `env.template` file to configure your AWS Security Lab environment.

## What is env.template?

The `env.template` file is a **safe template** that contains placeholder values for all the configuration options needed to run the AWS Security Lab. It's designed to be copied and customized for your specific environment without exposing sensitive information.

## How to Use

### Step 1: Copy the Template
```bash
# Copy the template to create your environment file
cp env.template .env.lab
```

### Step 2: Edit Your Environment File
Open `.env.lab` in your preferred text editor and replace the placeholder values with your actual configuration.

### Step 3: Never Commit Environment Files
Environment files containing real credentials should never be committed to version control. They're already included in `.gitignore`.

## Configuration Sections

### AWS Credentials
```bash
# Your AWS Access Key ID (get this from AWS IAM)
AWS_ACCESS_KEY_ID=your_access_key_id_here

# Your AWS Secret Access Key (get this from AWS IAM)
AWS_SECRET_ACCESS_KEY=your_secret_access_key_here

# Your AWS Account ID (12-digit number)
AWS_ACCOUNT_ID=123456789012
```

**What this means:** These are your AWS account credentials for programmatic access.

### AWS Configuration
```bash
# AWS region where you want to deploy resources
AWS_DEFAULT_REGION=us-east-1

# AWS CLI profile name (if using multiple profiles)
AWS_PROFILE=default

# AWS CLI output format
AWS_OUTPUT_FORMAT=json
```

**What this means:** Basic AWS CLI configuration settings.

### Lab Configuration
```bash
# Environment name (used for resource naming and tagging)
ENVIRONMENT=lab

# Project name (used for resource naming)
PROJECT_NAME=aws-security-lab

# Your name or username (for resource ownership)
OWNER=your_name_here

# Lab description
LAB_DESCRIPTION=EC2 Compromise and Remediation Lab
```

**What this means:** These values are used to name and tag your AWS resources.

### Security Settings
```bash
# Enable MFA for AWS operations (true/false)
ENABLE_MFA=true

# Require encryption for data at rest (true/false)
REQUIRE_ENCRYPTION=true

# Enable CloudTrail logging (true/false)
ENABLE_CLOUDTRAIL=true

# Enable VPC Flow Logs (true/false)
ENABLE_VPC_FLOW_LOGS=true
```

**What this means:** Security configuration options for your lab environment.

### Monitoring and Alerting
```bash
# Enable CloudWatch monitoring (true/false)
ENABLE_MONITORING=true

# Enable SNS notifications (true/false)
ENABLE_SNS_NOTIFICATIONS=true

# Email address for security alerts
SECURITY_ALERT_EMAIL=security@yourcompany.com

# Enable cost monitoring (true/false)
ENABLE_COST_MONITORING=true
```

**What this means:** Configuration for monitoring, alerting, and cost tracking.

### Lab-Specific Settings
```bash
# EC2 instance type for web server
WEB_SERVER_INSTANCE_TYPE=t3.micro

# EC2 instance type for database server
DATABASE_SERVER_INSTANCE_TYPE=t3.micro

# VPC CIDR block
VPC_CIDR=10.0.0.0/16

# Public subnet CIDR blocks
PUBLIC_SUBNET_CIDRS=["10.0.1.0/24","10.0.2.0/24"]

# Private subnet CIDR blocks
PRIVATE_SUBNET_CIDRS=["10.0.10.0/24","10.0.20.0/24"]
```

**What this means:** Infrastructure configuration for your lab resources.

### Network Configuration
```bash
# Enable DNS hostnames (true/false)
ENABLE_DNS_HOSTNAMES=true

# Enable DNS resolution (true/false)
ENABLE_DNS_RESOLUTION=true

# Enable auto-assign public IPs (true/false)
ENABLE_AUTO_ASSIGN_PUBLIC_IPS=true
```

**What this means:** Network configuration options for your VPC.

### SSH Configuration
```bash
# SSH key pair name
SSH_KEY_NAME=lab-key

# SSH username for EC2 instances
SSH_USERNAME=ec2-user

# SSH port (default: 22)
SSH_PORT=22
```

**What this means:** SSH access configuration for your EC2 instances.

### Logging Configuration
```bash
# Log level (debug, info, warn, error)
LOG_LEVEL=info

# Enable detailed logging (true/false)
ENABLE_DETAILED_LOGGING=false

# Log retention period in days
LOG_RETENTION_DAYS=30

# Enable log encryption (true/false)
ENABLE_LOG_ENCRYPTION=true
```

**What this means:** Logging and debugging configuration options.

### Cost Optimization
```bash
# Maximum lab runtime in hours
MAX_LAB_RUNTIME_HOURS=24

# Enable auto-shutdown (true/false)
ENABLE_AUTO_SHUTDOWN=true

# Shutdown time (24-hour format, e.g., 18:00)
SHUTDOWN_TIME=18:00

# Cost alert threshold in USD
COST_ALERT_THRESHOLD=50.00
```

**What this means:** Cost control and optimization settings.

### Emergency Settings
```bash
# Emergency shutdown email
EMERGENCY_EMAIL=admin@yourcompany.com

# Enable emergency shutdown (true/false)
ENABLE_EMERGENCY_SHUTDOWN=true

# Emergency shutdown threshold (CPU percentage)
EMERGENCY_CPU_THRESHOLD=90
```

**What this means:** Emergency response configuration for critical situations.

## Security Best Practices

### Credential Management
- **Never share** your AWS credentials
- **Rotate access keys** every 90 days
- **Use IAM roles** when possible
- **Enable MFA** on your AWS account

### Environment Isolation
- **Separate environments** for different purposes
- **Use different AWS accounts** for production vs. lab
- **Isolate resources** in dedicated VPCs
- **Tag resources** for cost tracking

### Monitoring and Alerting
- **Enable CloudTrail** for audit logging
- **Set up cost alerts** to avoid surprises
- **Monitor resource usage** regularly
- **Review security findings** from GuardDuty

## Troubleshooting

### Common Issues

#### Environment File Not Found
**Problem:** Scripts can't find your environment file
**Solution:** Ensure you've copied `env.template` to `.env.lab` or similar

#### Invalid Credentials
**Problem:** AWS CLI commands fail with authentication errors
**Solution:** Verify your access key and secret key are correct

#### Permission Errors
**Problem:** AWS operations fail with permission errors
**Solution:** Ensure your IAM user has the required permissions

#### Region Mismatch
**Problem:** Resources created in wrong region
**Solution:** Check your `AWS_DEFAULT_REGION` setting

## Next Steps

1. **Copy the template** to create your environment file
2. **Edit the file** with your actual values
3. **Test your configuration** using the setup scripts
4. **Deploy your infrastructure** using Terraform
5. **Monitor your resources** and costs

## Additional Resources

- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [AWS Security Best Practices](https://aws.amazon.com/security/security-learning/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

---

**Remember:** This template is for educational purposes. Never use these settings in production without proper security review!
