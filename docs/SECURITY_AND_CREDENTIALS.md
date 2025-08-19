# Security & Credentials Management Guide

This guide explains how to securely manage your AWS credentials and what files should NEVER be committed to GitHub.

## CRITICAL SECURITY WARNING

**NEVER commit AWS credentials to GitHub!** This includes:
- Access Key IDs
- Secret Access Keys
- Session tokens
- Private SSH keys
- Configuration files with credentials
- Environment files with secrets

**Why this matters:**
- **Public repositories** are visible to everyone on the internet
- **Credential exposure** can lead to unauthorized AWS access
- **Cost implications** - attackers can use your account and charge you
- **Security breaches** - compromise of your entire AWS infrastructure
- **Compliance violations** - potential legal and regulatory issues

---

## What to Exclude from GitHub

### 1. **Create a `.gitignore` File**

Create this file in your project root directory:

```bash
# AWS Credentials and Configuration
.aws/
aws-credentials.txt
aws-config.txt
*.pem
*.key
*.p12
*.pfx

# Environment Variables
.env
.env.local
.env.production
.env.staging
*.env

# SSH Keys
ssh/
*.pub
id_rsa
id_ed25519
lab-key
lab-key.pub

# Terraform State and Secrets
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl
terraform.tfvars
*.tfvars
secrets.tf

# Logs and Temporary Files
*.log
*.tmp
*.temp
.DS_Store
Thumbs.db

# IDE and Editor Files
.vscode/
.idea/
*.swp
*.swo
*~

# OS Generated Files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
```

### 2. **Files That Should NEVER Be Committed**

| File Type | Example Names | Why Exclude |
|-----------|---------------|-------------|
| **AWS Credentials** | `.aws/credentials`, `aws-keys.txt` | Contains secret access keys |
| **SSH Private Keys** | `lab-key`, `id_rsa`, `*.pem` | Private authentication keys |
| **Environment Files** | `.env`, `config.env` | May contain secrets |
| **Terraform State** | `*.tfstate`, `*.tfstate.backup` | May contain sensitive data |
| **Configuration Files** | `terraform.tfvars`, `secrets.tf` | May contain credentials |
| **Log Files** | `*.log`, `debug.log` | May contain sensitive information |

---

## Safe Credential Management

### 1. **Use Environment Variables**

Instead of hardcoding credentials, use environment variables:

```bash
# Set environment variables (Windows PowerShell)
$env:AWS_ACCESS_KEY_ID="your-access-key"
$env:AWS_SECRET_ACCESS_KEY="your-secret-key"
$env:AWS_DEFAULT_REGION="us-east-1"

# Set environment variables (Linux/Mac)
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### 2. **Use AWS CLI Configuration**

Configure AWS CLI securely:

```bash
# Interactive configuration
aws configure

# Manual configuration
aws configure set aws_access_key_id your-access-key
aws configure set aws_secret_access_key your-secret-key
aws configure set default.region us-east-1
```

### 3. **Use IAM Roles (Recommended)**

For production environments, use IAM roles instead of access keys:

```bash
# For EC2 instances
aws configure set role_arn arn:aws:iam::123456789012:role/YourRoleName

# For cross-account access
aws configure set role_arn arn:aws:iam::123456789012:role/CrossAccountRole
```

---

## Template Files

### 1. **Environment Template (`env.template`)**

Create a template file that users can copy and fill in:

```bash
# Copy the template
cp env.template .env

# Edit with your actual values
nano .env
```

### 2. **Template Content**

Your `env.template` should look like this:

```bash
# AWS Configuration
AWS_ACCESS_KEY_ID=your_access_key_here
AWS_SECRET_ACCESS_KEY=your_secret_key_here
AWS_DEFAULT_REGION=us-east-1

# Lab Configuration
ENVIRONMENT=lab
PROJECT_NAME=aws-security-lab
OWNER=your_name_here

# Optional: Advanced Settings
ENABLE_MONITORING=true
ENABLE_LOGGING=true
LOG_LEVEL=info
```

---

## Best Practices

### 1. **Credential Rotation**

- Rotate access keys every 90 days
- Use temporary credentials when possible
- Monitor credential usage with CloudTrail

### 2. **Access Control**

- Follow the principle of least privilege
- Use IAM groups and policies
- Regularly review and audit permissions

### 3. **Monitoring**

- Enable CloudTrail for API logging
- Set up CloudWatch alarms for unusual activity
- Monitor AWS costs and usage

### 4. **Documentation**

- Document your security practices
- Keep security procedures up to date
- Train team members on security

---

## Common Mistakes to Avoid

### 1. **Never Do This**

```bash
# ❌ DON'T: Hardcode credentials in scripts
aws configure set aws_access_key_id AKIAIOSFODNN7EXAMPLE

# ❌ DON'T: Commit credential files
git add .aws/credentials
git commit -m "Add AWS credentials"

# ❌ DON'T: Share credentials in chat or email
# Send your access key to someone
```

### 2. **Always Do This**

```bash
# ✅ DO: Use environment variables
export AWS_ACCESS_KEY_ID="your-key"

# ✅ DO: Use .gitignore
echo ".aws/" >> .gitignore

# ✅ DO: Use IAM roles when possible
aws configure set role_arn arn:aws:iam::123456789012:role/YourRole
```

---

## Troubleshooting

### 1. **Permission Errors**

If you get permission errors:

```bash
# Check your current identity
aws sts get-caller-identity

# Verify your credentials
aws iam get-user

# Check your permissions
aws iam list-attached-user-policies --user-name YourUsername
```

### 2. **Configuration Issues**

If AWS CLI can't find your credentials:

```bash
# Check configuration files
cat ~/.aws/credentials
cat ~/.aws/config

# Verify environment variables
echo $AWS_ACCESS_KEY_ID
echo $AWS_SECRET_ACCESS_KEY
```

### 3. **Security Concerns**

If you accidentally exposed credentials:

1. **Immediately deactivate** the exposed credentials
2. **Create new credentials** to replace them
3. **Review your Git history** and remove any commits with credentials
4. **Check AWS CloudTrail** for unauthorized usage
5. **Monitor your AWS account** for unusual activity

---

## Summary

- **Never commit credentials** to version control
- **Use environment variables** or AWS CLI configuration
- **Implement proper .gitignore** files
- **Follow security best practices** for credential management
- **Monitor and audit** your AWS account regularly
- **Train your team** on security procedures

---

<div align="center">
  <p><em>Secure credential management is the foundation of AWS security!</em></p>
</div>
