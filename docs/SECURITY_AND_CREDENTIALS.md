# 🔐 Security & Credentials Management Guide

This guide explains how to securely manage your AWS credentials and what files should NEVER be committed to GitHub.

## 🚨 **CRITICAL SECURITY WARNING**

**NEVER commit AWS credentials to GitHub!** This includes:
- ❌ Access Key IDs
- ❌ Secret Access Keys
- ❌ Session tokens
- ❌ Private SSH keys
- ❌ Configuration files with credentials
- ❌ Environment files with secrets

**Why this matters:**
- **Public repositories** are visible to everyone on the internet
- **Credential exposure** can lead to unauthorized AWS access
- **Cost implications** - attackers can use your account and charge you
- **Security breaches** - compromise of your entire AWS infrastructure
- **Compliance violations** - potential legal and regulatory issues

---

## 📁 **What to Exclude from GitHub**

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

## 🔑 **Secure Credential Storage Options**

### **Option 1: Local Environment Variables (Recommended)**

#### For Windows (PowerShell):
```powershell
# Create a secure environment file (NOT committed to git)
$envFile = @"
# AWS Credentials - DO NOT COMMIT THIS FILE!
AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
AWS_DEFAULT_REGION=us-east-1
AWS_OUTPUT_FORMAT=json
"@

# Save to a file that's in .gitignore
$envFile | Out-File -FilePath ".env.local" -Encoding UTF8

# Load environment variables
Get-Content ".env.local" | ForEach-Object {
    if ($_ -match "^([^=]+)=(.*)$") {
        $name = $matches[1]
        $value = $matches[2]
        Set-Item -Path "env:$name" -Value $value
    }
}
```

#### For Mac/Linux (Bash):
```bash
# Create a secure environment file (NOT committed to git)
cat > .env.local << 'EOF'
# AWS Credentials - DO NOT COMMIT THIS FILE!
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
export AWS_DEFAULT_REGION=us-east-1
export AWS_OUTPUT_FORMAT=json
EOF

# Load environment variables
source .env.local
```

### **Option 2: AWS CLI Configuration (Secure)**

```bash
# Configure AWS CLI (credentials stored securely)
aws configure

# This creates:
# ~/.aws/credentials (encrypted)
# ~/.aws/config (public configuration)
```

**What this creates:**
- **`~/.aws/credentials`**: Encrypted credential storage
- **`~/.aws/config`**: Public configuration (safe to share)

### **Option 3: Environment-Specific Files**

Create different credential files for different environments:

```bash
# Development environment
.env.development

# Production environment  
.env.production

# Testing environment
.env.test
```

**Load the appropriate file based on your needs:**
```bash
# Load development credentials
source .env.development

# Load production credentials
source .env.production
```

---

## 🛡️ **Security Best Practices**

### 1. **Credential Rotation**
- **Rotate access keys** every 90 days
- **Use temporary credentials** when possible
- **Monitor credential usage** in AWS IAM
- **Remove unused credentials** immediately

### 2. **Access Control**
- **Use IAM roles** instead of access keys when possible
- **Implement least privilege** - only necessary permissions
- **Use AWS Organizations** for multi-account management
- **Enable MFA** on all accounts

### 3. **Monitoring and Alerting**
- **Enable CloudTrail** for API logging
- **Set up CloudWatch alarms** for unusual activity
- **Monitor billing alerts** for unexpected charges
- **Use AWS Config** for compliance monitoring

### 4. **Development Security**
- **Never hardcode credentials** in scripts
- **Use parameter stores** for configuration
- **Implement secret scanning** in CI/CD
- **Regular security audits** of code

---

## 🔧 **Implementation Examples**

### **Example 1: Secure PowerShell Script**

```powershell
# setup_lab.ps1 - Secure version
param(
    [string]$Action = "help",
    [string]$Environment = "development"
)

# Load environment-specific credentials
$envFile = ".env.$Environment"
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match "^([^=]+)=(.*)$") {
            $name = $matches[1]
            $value = $matches[2]
            Set-Item -Path "env:$name" -Value $value
        }
    }
} else {
    Write-Host "❌ Environment file $envFile not found!" -ForegroundColor Red
    Write-Host "Please create $envFile with your AWS credentials" -ForegroundColor Yellow
    exit 1
}

# Verify credentials are loaded
if (-not $env:AWS_ACCESS_KEY_ID -or -not $env:AWS_SECRET_ACCESS_KEY) {
    Write-Host "❌ AWS credentials not loaded!" -ForegroundColor Red
    exit 1
}

# Rest of your script...
```

### **Example 2: Secure Bash Script**

```bash
#!/bin/bash
# setup_lab.sh - Secure version

ENVIRONMENT=${1:-development}
ENV_FILE=".env.$ENVIRONMENT"

# Load environment-specific credentials
if [ -f "$ENV_FILE" ]; then
    source "$ENV_FILE"
else
    echo "❌ Environment file $ENV_FILE not found!"
    echo "Please create $ENV_FILE with your AWS credentials"
    exit 1
fi

# Verify credentials are loaded
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "❌ AWS credentials not loaded!"
    exit 1
fi

# Rest of your script...
```

### **Example 3: Terraform Secure Configuration**

```hcl
# variables.tf - Define variables without values
variable "aws_access_key_id" {
  description = "AWS Access Key ID"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive   = true
}

# terraform.tfvars.example - Template file (safe to commit)
aws_access_key_id     = "YOUR_ACCESS_KEY_ID_HERE"
aws_secret_access_key = "YOUR_SECRET_ACCESS_KEY_HERE"
aws_region           = "us-east-1"
environment          = "lab"
```

**Create actual terraform.tfvars (NOT committed):**
```hcl
# terraform.tfvars - Real values (NOT committed to git)
aws_access_key_id     = "AKIAIOSFODNN7EXAMPLE"
aws_secret_access_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
aws_region           = "us-east-1"
environment          = "lab"
```

---

## 📋 **Pre-Commit Checklist**

Before committing to GitHub, always check:

- [ ] **No credential files** in staging area
- [ ] **No .env files** with real values
- [ ] **No SSH private keys** included
- [ ] **No terraform.tfvars** with secrets
- [ ] **No AWS credentials** in any files
- [ ] **No hardcoded secrets** in code
- [ ] **No state files** with sensitive data
- [ ] **No log files** with credentials

### **Git Status Check**
```bash
# Check what's staged for commit
git status

# Check for any files that might contain credentials
git diff --cached | grep -i "aws\|key\|secret\|password\|token"

# Check for any new files that might be credentials
git ls-files --others --exclude-standard | grep -E "\.(env|key|pem|p12|pfx)$"
```

---

## 🚨 **Emergency Response**

### **If Credentials Are Accidentally Committed:**

1. **Immediate Actions:**
   - **Revoke the credentials** in AWS IAM immediately
   - **Create new credentials** to replace compromised ones
   - **Check AWS CloudTrail** for unauthorized usage
   - **Monitor billing** for unexpected charges

2. **GitHub Actions:**
   - **Force push** to remove the commit from history
   - **Use BFG Repo-Cleaner** to remove sensitive data
   - **Consider repository deletion** if credentials were exposed

3. **Security Review:**
   - **Audit all repositories** for credential exposure
   - **Review access logs** for unauthorized access
   - **Implement credential scanning** in CI/CD
   - **Train team** on security best practices

---

## 📚 **Additional Resources**

### **AWS Security Documentation**
- [AWS Security Best Practices](https://aws.amazon.com/security/security-learning/)
- [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [Security Pillar - AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)

### **Git Security Tools**
- [Git Secrets](https://github.com/awslabs/git-secrets) - AWS credential scanning
- [BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/) - Remove sensitive data
- [Pre-commit Hooks](https://pre-commit.com/) - Automated security checks

### **Environment Management**
- [AWS Systems Manager Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html)
- [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/)
- [HashiCorp Vault](https://www.vaultproject.io/) - Alternative secret management

---

## 🎯 **Summary**

### **DO:**
✅ Use environment variables for credentials  
✅ Store credentials in `.env.local` files  
✅ Add credential files to `.gitignore`  
✅ Use AWS CLI secure configuration  
✅ Implement credential rotation  
✅ Monitor for unauthorized access  

### **DON'T:**
❌ Commit credentials to GitHub  
❌ Hardcode secrets in scripts  
❌ Share credentials in public repositories  
❌ Use the same credentials everywhere  
❌ Forget to revoke compromised credentials  
❌ Ignore security warnings  

### **Remember:**
- **Security is everyone's responsibility**
- **When in doubt, don't commit it**
- **Regular security audits prevent breaches**
- **Proper credential management saves money and reputation**

---

**Stay secure, stay vigilant! 🔒🛡️**
