# 🔐 Setup Credentials Scripts - Complete Guide

This document explains how to use the credential setup scripts to securely configure your AWS credentials for the AWS Security Lab.

## 📋 **What Are These Scripts?**

The setup credentials scripts are **automated tools** that help you:

- 🔑 **Create secure credential files** from templates
- ✅ **Validate your AWS credentials** before using them
- 🔍 **Check your configuration** for common issues
- 🛡️ **Follow security best practices** automatically
- 🌍 **Work on multiple platforms** (Windows, Mac, Linux)

## 📁 **Available Scripts**

| Platform | Script | Description |
|----------|--------|-------------|
| **Windows** | `setup_credentials.ps1` | PowerShell script for Windows users |
| **Mac/Linux** | `setup_credentials.sh` | Bash script for Unix-based systems |

## 🚀 **Quick Start**

### **Windows Users**
```powershell
# Navigate to project root
cd C:\Users\faust\aws-lab

# Set up credentials interactively
.\scripts\setup_credentials.ps1 setup

# Validate your setup
.\scripts\setup_credentials.ps1 validate
```

### **Mac/Linux Users**
```bash
# Navigate to project root
cd ~/aws-lab

# Make script executable (first time only)
chmod +x scripts/setup_credentials.sh

# Set up credentials interactively
./scripts/setup_credentials.sh setup

# Validate your setup
./scripts/setup_credentials.sh validate
```

## 🔧 **Available Actions**

### **`setup` - Interactive Credential Setup**
Creates your `.env.local` file from the template and guides you through configuration.

**What it does:**
- ✅ Copies `env.template` to `.env.local`
- 🔑 Opens the file for editing (if requested)
- 🚨 Shows security warnings
- 📝 Provides step-by-step instructions

**Example:**
```bash
# Windows
.\scripts\setup_credentials.ps1 setup

# Mac/Linux
./scripts/setup_credentials.sh setup
```

### **`check` - Configuration Verification**
Examines your current setup and reports what's configured.

**What it checks:**
- 📁 Environment files (`.env.local`, `.env.development`, etc.)
- 🔧 AWS CLI configuration files
- ⚠️ Missing or incomplete configurations

**Example:**
```bash
# Windows
.\scripts\setup_credentials.ps1 check

# Mac/Linux
./scripts/setup_credentials.sh check
```

### **`validate` - Credential Testing**
Tests your AWS credentials to ensure they work correctly.

**What it tests:**
- 🔐 AWS CLI installation and functionality
- ✅ Credential validity and permissions
- 📊 Account information retrieval
- 🚨 Common configuration issues

**Example:**
```bash
# Windows
.\scripts\setup_credentials.ps1 validate

# Mac/Linux
./scripts/setup_credentials.sh validate
```

### **`help` - Usage Information**
Shows detailed help and usage examples.

**Example:**
```bash
# Windows
.\scripts\setup_credentials.ps1 help

# Mac/Linux
./scripts/setup_credentials.sh help
```

## 🔍 **How the Scripts Work**

### **Setup Process Flow**
```
1. Security Warning Display
   ↓
2. Template File Check
   ↓
3. Environment File Creation
   ↓
4. User Instructions
   ↓
5. File Opening (Optional)
   ↓
6. Next Steps Guidance
```

### **Validation Process Flow**
```
1. AWS CLI Check
   ↓
2. Credential Test
   ↓
3. Account Information Retrieval
   ↓
4. Success/Failure Reporting
   ↓
5. Troubleshooting Guidance
```

## 📚 **Detailed Usage Examples**

### **Complete Setup Workflow**

#### **Step 1: Initial Setup**
```bash
# Windows
.\scripts\setup_credentials.ps1 setup

# Mac/Linux
./scripts/setup_credentials.sh setup
```

**Expected Output:**
```
🔐 AWS Security Lab - Credentials Setup
=========================================

🚨 SECURITY WARNING
==================
⚠️  NEVER share your AWS credentials with anyone!
⚠️  NEVER commit credentials to GitHub!
⚠️  NEVER use the same credentials across multiple accounts!

🔑 Setting up AWS credentials for development environment...

📝 Creating .env.local from template...
✅ Template copied successfully!

🚨 IMPORTANT: You need to manually edit .env.local with your real AWS credentials!

Steps:
1. Open .env.local in your text editor
2. Replace 'YOUR_ACCESS_KEY_ID_HERE' with your actual AWS Access Key ID
3. Replace 'YOUR_SECRET_ACCESS_KEY_HERE' with your actual AWS Secret Access Key
4. Update other values as needed
5. Save the file

⚠️  NEVER commit .env.local to git - it's already in .gitignore

Would you like to open .env.local now? (y/n): y
✅ File opened in Notepad

🎯 After editing your credentials, run:
  .\setup_credentials.ps1 validate
```

#### **Step 2: Edit Credentials**
The script will open your `.env.local` file. Edit these key values:

```bash
# Replace these placeholder values:
AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY_ID_HERE
AWS_SECRET_ACCESS_KEY=YOUR_SECRET_ACCESS_KEY_HERE

# With your real credentials:
AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

#### **Step 3: Validate Setup**
```bash
# Windows
.\scripts\setup_credentials.ps1 validate

# Mac/Linux
./scripts/setup_credentials.sh validate
```

**Expected Output:**
```
🔍 Validating AWS credentials...

✅ AWS CLI found: aws-cli/2.28.11 Python/3.11.8 Windows/10 exe/AMD64
🔐 Testing AWS credentials...
✅ AWS credentials are valid!

Account Information:
  Account ID: 123456789012
  User ID: AIDACKCEVSQ6C2EXAMPLE
  ARN: arn:aws:iam::123456789012:user/YourUserName

🎉 You're ready to use the AWS Security Lab!
```

### **Environment-Specific Setup**

You can specify different environments for different use cases:

```bash
# Development environment (default)
.\scripts\setup_credentials.ps1 setup development

# Production environment
.\scripts\setup_credentials.ps1 setup production

# Staging environment
.\scripts\setup_credentials.ps1 setup staging
```

This creates environment-specific files like `.env.development`, `.env.production`, etc.

## 🛡️ **Security Features**

### **Built-in Security Measures**
- 🚨 **Security warnings** displayed before setup
- ⚠️ **Credential validation** prevents invalid configurations
- 🔒 **Template-based approach** prevents credential exposure
- 📁 **Automatic Git exclusion** via `.gitignore`

### **Security Best Practices Enforced**
- ✅ **No hardcoded credentials** in scripts
- ✅ **Environment file isolation** from version control
- ✅ **Credential validation** before lab execution
- ✅ **Clear security warnings** and reminders

## 🔍 **Troubleshooting Guide**

### **Common Issues and Solutions**

#### **Issue: "Template file not found"**
**Symptoms:**
```
❌ Template file 'env.template' not found!
Please ensure you're running this script from the project root directory.
```

**Solutions:**
1. **Check your location**: Ensure you're in the project root directory
2. **Verify file exists**: Check that `env.template` is present
3. **Check permissions**: Ensure you can read the template file

**Commands:**
```bash
# Check current directory
pwd  # Mac/Linux
Get-Location  # Windows PowerShell

# List files
ls  # Mac/Linux
Get-ChildItem  # Windows PowerShell
```

#### **Issue: "AWS CLI not found"**
**Symptoms:**
```
❌ AWS CLI not found!
Please install AWS CLI first.
```

**Solutions:**
1. **Install AWS CLI**: Follow platform-specific installation
2. **Check PATH**: Ensure AWS CLI is in your system PATH
3. **Restart terminal**: After installation, restart your terminal

**Installation Commands:**
```bash
# Windows (using winget)
winget install -e --id Amazon.AWSCLI

# Mac (using Homebrew)
brew install awscli

# Linux (Ubuntu/Debian)
sudo apt update && sudo apt install awscli
```

#### **Issue: "AWS credentials validation failed"**
**Symptoms:**
```
❌ AWS credentials validation failed!
Error: [Error details]
```

**Solutions:**
1. **Check credentials**: Verify your Access Key ID and Secret Access Key
2. **Verify account**: Ensure your AWS account is active
3. **Check permissions**: Ensure your IAM user has necessary permissions
4. **Check expiration**: Verify your access keys haven't expired

**Debugging Commands:**
```bash
# Test AWS CLI directly
aws sts get-caller-identity

# Check AWS configuration
aws configure list

# Test with specific profile
aws sts get-caller-identity --profile default
```

#### **Issue: "File not ignored by Git"**
**Symptoms:**
- `.env.local` appears in `git status`
- File is staged for commit

**Solutions:**
1. **Check `.gitignore`**: Ensure `.env.local` is listed
2. **Remove from staging**: Unstage the file if already tracked
3. **Verify file name**: Ensure exact match with `.gitignore` pattern

**Commands:**
```bash
# Check git status
git status

# Check .gitignore contents
cat .gitignore | grep env

# Remove from staging (if needed)
git reset HEAD .env.local

# Verify file is ignored
git check-ignore .env.local
```

### **Advanced Troubleshooting**

#### **Permission Issues**
```bash
# Mac/Linux: Check file permissions
ls -la scripts/setup_credentials.sh

# Fix permissions if needed
chmod +x scripts/setup_credentials.sh

# Windows: Check execution policy
Get-ExecutionPolicy

# Allow script execution if needed
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

#### **Environment Variable Issues**
```bash
# Check if environment variables are loaded
echo $AWS_ACCESS_KEY_ID  # Mac/Linux
echo $env:AWS_ACCESS_KEY_ID  # Windows PowerShell

# Load environment file manually
source .env.local  # Mac/Linux
Get-Content .env.local | ForEach-Object { ... }  # Windows PowerShell
```

## 📚 **Integration with Other Tools**

### **Main Lab Script Integration**
After setting up credentials, you can use the main lab script:

```bash
# Windows
.\scripts\setup_lab.ps1 -Action check
.\scripts\setup_lab.ps1 -Action init
.\scripts\setup_lab.ps1 -Action deploy

# Mac/Linux
./scripts/setup_lab.sh check
./scripts/setup_lab.sh init
./scripts/setup_lab.sh deploy
```

### **Terraform Integration**
The scripts work seamlessly with Terraform:

```bash
# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply changes
terraform apply
```

## 🎯 **Best Practices**

### **Script Usage**
- ✅ **Use the setup action first** to create your configuration
- ✅ **Validate credentials** before running the lab
- ✅ **Check configuration** if you encounter issues
- ✅ **Use help action** when unsure about usage

### **Security**
- ✅ **Never share your credentials** with anyone
- ✅ **Rotate access keys** every 90 days
- ✅ **Use IAM users** with minimal permissions
- ✅ **Enable MFA** on your AWS account

### **Configuration**
- ✅ **Use environment-specific files** for different scenarios
- ✅ **Keep sensitive values** out of version control
- ✅ **Validate your setup** before proceeding
- ✅ **Follow the provided instructions** carefully

## 🚀 **Next Steps**

After successfully setting up your credentials:

1. **Run the main lab script** to deploy infrastructure
2. **Follow the lab checklist** to complete objectives
3. **Monitor your AWS usage** for cost control
4. **Clean up resources** when finished

## 📚 **Related Documentation**

- **`env.template.README.md`** - Complete template guide
- **`docs/SECURITY_AND_CREDENTIALS.md`** - Security best practices
- **`docs/SETUP_GUIDE.md`** - Complete setup instructions
- **`docs/QUICK_START.md`** - Fast deployment guide
- **`README.md`** - Main project overview

## 🆘 **Getting Help**

### **Script Issues**
1. **Check this README** for troubleshooting steps
2. **Run the help action** for usage information
3. **Review error messages** carefully
4. **Check file permissions** and locations

### **AWS Issues**
1. **Verify your credentials** using the validation action
2. **Check IAM permissions** for your user
3. **Review AWS documentation** for service limits
4. **Contact AWS support** if needed

### **Lab Issues**
1. **Use the main lab script** for infrastructure management
2. **Follow the lab checklist** for step-by-step guidance
3. **Check the documentation** for detailed explanations
4. **Create GitHub issues** for bugs or improvements

## 🎉 **You're Ready!**

With these scripts, you have everything you need to:

- 🔑 **Set up secure credentials** quickly and safely
- ✅ **Validate your configuration** before starting
- 🔍 **Troubleshoot issues** when they arise
- 🛡️ **Follow security best practices** automatically

**Remember**: These scripts are designed to make setup easy while keeping you secure. Take your time to understand each step, and don't hesitate to use the help action if you need guidance!

---

**Happy learning! 🚀🔒**
