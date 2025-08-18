# 🔐 Environment Template (`env.template`) - Complete Guide

This document explains how to use the `env.template` file to securely configure your AWS Security Lab environment variables.

## 📋 **What is `env.template`?**

`env.template` is a **safe template file** that contains placeholder values for all the configuration options needed to run the AWS Security Lab. It's designed to be:

- ✅ **Safe to commit** to GitHub (contains no real credentials)
- ✅ **Comprehensive** (covers all configuration options)
- ✅ **Educational** (explains what each setting does)
- ✅ **Cross-platform** (works on Windows, Mac, and Linux)

## 🚨 **IMPORTANT SECURITY WARNING**

**NEVER put your real AWS credentials in this file!**

- ❌ This file is committed to GitHub
- ❌ It's visible to everyone who can see your repository
- ❌ Real credentials would be exposed to the internet
- ❌ This could lead to unauthorized AWS access and charges

## 🔧 **How to Use This Template**

### **Step 1: Copy the Template**
```bash
# Windows (PowerShell)
Copy-Item env.template .env.local

# Mac/Linux (Bash)
cp env.template .env.local
```

### **Step 2: Edit with Your Real Values**
Open `.env.local` in your text editor and replace the placeholder values:

```bash
# BEFORE (template - safe to commit)
AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY_ID_HERE
AWS_SECRET_ACCESS_KEY=YOUR_SECRET_ACCESS_KEY_HERE

# AFTER (your real file - NEVER commit)
AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

### **Step 3: Verify It's Ignored**
The `.env.local` file is automatically excluded from Git by `.gitignore`, so it won't be committed accidentally.

## 📚 **Configuration Sections Explained**

### **🌍 AWS Credentials Section**
```bash
# Your AWS Access Key ID (starts with AKIA)
AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY_ID_HERE

# Your AWS Secret Access Key (very long string)
AWS_SECRET_ACCESS_KEY=YOUR_SECRET_ACCESS_KEY_HERE

# AWS Session Token (if using temporary credentials)
# AWS_SESSION_TOKEN=YOUR_SESSION_TOKEN_HERE
```

**What these do:**
- **Access Key ID**: Identifies your AWS account/user
- **Secret Access Key**: Authenticates your requests to AWS
- **Session Token**: Used for temporary credentials (optional)

**How to get them:**
1. Go to AWS Console → IAM → Users → Your User
2. Security credentials tab → Create access key
3. Download the CSV file with your keys

### **🌍 AWS Configuration Section**
```bash
# AWS Region (e.g., us-east-1, us-west-2, eu-west-1)
AWS_DEFAULT_REGION=us-east-1

# AWS Output Format (json, text, table)
AWS_OUTPUT_FORMAT=json

# AWS Profile (if using multiple profiles)
# AWS_PROFILE=default
```

**What these do:**
- **Region**: Where your AWS resources will be created
- **Output Format**: How AWS CLI displays information
- **Profile**: Which AWS profile to use (if you have multiple)

**Recommended settings:**
- **Region**: Use `us-east-1` for best compatibility
- **Output Format**: Use `json` for scripting
- **Profile**: Leave as `default` unless you have multiple accounts

### **🏗️ Lab Configuration Section**
```bash
# Lab Environment (development, staging, production)
LAB_ENVIRONMENT=development

# Lab Name (for resource tagging)
LAB_NAME=aws-security-lab

# Lab Owner (your name or team)
LAB_OWNER=YOUR_NAME_HERE
```

**What these do:**
- **Environment**: Helps organize resources and costs
- **Lab Name**: Tags all AWS resources for easy identification
- **Lab Owner**: Helps with cost tracking and resource management

**Recommended settings:**
- **Environment**: Use `development` for learning
- **Lab Name**: Keep as `aws-security-lab`
- **Lab Owner**: Put your name or team name

### **🔒 Security Settings Section**
```bash
# Enable detailed logging (true/false)
ENABLE_DEBUG_LOGGING=false

# Enable credential validation (true/false)
ENABLE_CREDENTIAL_VALIDATION=true

# Maximum lab runtime in hours (for cost control)
MAX_LAB_RUNTIME_HOURS=24
```

**What these do:**
- **Debug Logging**: Shows detailed information during lab execution
- **Credential Validation**: Checks your AWS credentials before starting
- **Max Runtime**: Automatically stops the lab after specified hours

**Recommended settings:**
- **Debug Logging**: `false` for normal use, `true` for troubleshooting
- **Credential Validation**: Always `true`
- **Max Runtime**: `24` hours for safety

### **📊 Monitoring and Alerting Section**
```bash
# Enable CloudWatch monitoring (true/false)
ENABLE_CLOUDWATCH_MONITORING=true

# Enable billing alerts (true/false)
ENABLE_BILLING_ALERTS=true

# Billing alert threshold in USD
BILLING_ALERT_THRESHOLD_USD=50.00
```

**What these do:**
- **CloudWatch Monitoring**: Tracks performance and security metrics
- **Billing Alerts**: Warns you when costs exceed threshold
- **Alert Threshold**: Dollar amount that triggers billing warnings

**Recommended settings:**
- **CloudWatch**: Always `true` for security labs
- **Billing Alerts**: Always `true` for cost control
- **Threshold**: Set to `50.00` or your comfort level

### **🎯 Lab-Specific Settings Section**
```bash
# Web server instance type (t2.micro, t3.micro, etc.)
WEB_SERVER_INSTANCE_TYPE=t2.micro

# Database server instance type
DB_SERVER_INSTANCE_TYPE=t2.micro

# Enable GuardDuty (true/false)
ENABLE_GUARDDUTY=true

# Enable Security Hub (true/false)
ENABLE_SECURITY_HUB=true

# Enable CloudWatch (true/false)
ENABLE_CLOUDWATCH=true
```

**What these do:**
- **Instance Types**: Determines the size and cost of your EC2 instances
- **Security Services**: Controls which AWS security services are enabled

**Recommended settings:**
- **Instance Types**: Use `t2.micro` or `t3.micro` (free tier eligible)
- **Security Services**: All should be `true` for the full lab experience

### **🌐 Network Configuration Section**
```bash
# VPC CIDR block
VPC_CIDR=10.0.0.0/16

# Public subnet CIDR blocks
PUBLIC_SUBNET_CIDRS=["10.0.1.0/24","10.0.2.0/24"]

# Private subnet CIDR blocks
PRIVATE_SUBNET_CIDRS=["10.0.10.0/24","10.0.11.0/24"]
```

**What these do:**
- **VPC CIDR**: Defines the IP address range for your virtual network
- **Subnet CIDRs**: Divides your network into public and private areas

**Recommended settings:**
- **VPC CIDR**: Keep as `10.0.0.0/16` (standard lab configuration)
- **Subnet CIDRs**: Keep as shown (provides good network segmentation)

### **🔑 SSH Configuration Section**
```bash
# SSH key name (will be created if it doesn't exist)
SSH_KEY_NAME=lab-key

# SSH username for EC2 instances
SSH_USERNAME=ec2-user

# SSH port (usually 22)
SSH_PORT=22
```

**What these do:**
- **SSH Key**: Allows you to connect to your EC2 instances
- **Username**: The user account on your EC2 instances
- **Port**: The network port for SSH connections

**Recommended settings:**
- **SSH Key**: Keep as `lab-key`
- **Username**: Keep as `ec2-user` (standard for Amazon Linux)
- **Port**: Keep as `22` (standard SSH port)

## 🚀 **Quick Setup Commands**

### **Using the Setup Script (Recommended)**
```bash
# Windows
.\scripts\setup_credentials.ps1 setup

# Mac/Linux
./scripts/setup_credentials.sh setup
```

### **Manual Setup**
```bash
# Copy template
cp env.template .env.local

# Edit with your credentials
# (Use your preferred text editor)

# Validate your setup
# Windows: .\scripts\setup_credentials.ps1 validate
# Mac/Linux: ./scripts/setup_credentials.sh validate
```

## 🔍 **Verification Steps**

After setting up your `.env.local` file:

1. **Check file exists**: Verify `.env.local` is in your project root
2. **Verify credentials**: Run the validation script
3. **Test AWS connection**: Ensure you can access AWS services
4. **Check Git status**: Confirm `.env.local` is not staged for commit

## 🆘 **Troubleshooting**

### **Common Issues**

#### **"Template file not found"**
- Ensure you're in the project root directory
- Check that `env.template` exists
- Verify file permissions

#### **"Credentials validation failed"**
- Check your AWS Access Key ID and Secret Access Key
- Verify your AWS account is active
- Ensure your IAM user has necessary permissions
- Check if your access keys have expired

#### **"File not ignored by Git"**
- Verify `.gitignore` contains `.env.local`
- Check that `.env.local` is not already tracked
- Run `git status` to see what's staged

### **Getting Help**

1. **Check the logs**: Look for error messages in the setup script output
2. **Verify AWS setup**: Use `aws sts get-caller-identity` to test credentials
3. **Review permissions**: Ensure your IAM user has the required policies
4. **Check documentation**: See `docs/SECURITY_AND_CREDENTIALS.md` for more details

## 📚 **Related Documentation**

- **`docs/SECURITY_AND_CREDENTIALS.md`** - Complete security guide
- **`docs/SETUP_GUIDE.md`** - Detailed setup instructions
- **`docs/QUICK_START.md`** - Fast deployment guide
- **`scripts/setup_credentials.ps1`** - Windows setup script
- **`scripts/setup_credentials.sh`** - Mac/Linux setup script

## 🎯 **Best Practices**

### **Security**
- ✅ Use IAM users with minimal required permissions
- ✅ Rotate your access keys every 90 days
- ✅ Enable MFA on your AWS account
- ✅ Monitor your AWS usage regularly

### **Configuration**
- ✅ Use environment-specific files for different scenarios
- ✅ Keep sensitive values out of version control
- ✅ Validate your configuration before running the lab
- ✅ Use descriptive names for your resources

### **Cost Control**
- ✅ Set billing alerts at reasonable thresholds
- ✅ Use free tier eligible instance types
- ✅ Set maximum runtime limits
- ✅ Clean up resources when done

## 🎉 **You're Ready!**

Once you've configured your `.env.local` file:

1. **Validate your setup**: Run the validation script
2. **Deploy the lab**: Use the main lab script
3. **Follow the checklist**: Complete all lab objectives
4. **Clean up**: Destroy resources when finished

**Remember**: This template is designed to make setup easy while keeping you secure. Take your time to understand each setting, and don't hesitate to ask for help if you need it!

---

**Happy learning! 🚀🔒**
