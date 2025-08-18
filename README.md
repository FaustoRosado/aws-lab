# 🔒 AWS Security Lab: EC2 Compromise & Remediation

This lab simulates an EC2 compromise scenario and demonstrates how to detect and remediate security threats using AWS GuardDuty and Security Hub.

## 🎯 Lab Objectives

- **Infrastructure Setup**: Deploy a vulnerable web application and database server
- **Threat Simulation**: Simulate various attack scenarios to trigger security alerts
- **Detection**: Use AWS GuardDuty to detect suspicious activities
- **Investigation**: Analyze findings in AWS Security Hub
- **Remediation**: Implement security controls and clean up compromised resources

## 🏗️ Lab Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Internet                                │
│                                                                 │
│                              │                                 │
│                              ▼                                 │
│                    ┌─────────────────┐                         │
│                    │  Internet       │                         │
│                    │  Gateway        │                         │
│                    └─────────────────┘                         │
│                              │                                 │
│                              ▼                                 │
│                    ┌─────────────────────────────────────────┐ │
│                    │                 VPC                     │ │
│                    │           (10.0.0.0/16)                │ │
│                    │                                         │ │
│                    │  ┌─────────────────┐ ┌─────────────────┐ │ │
│                    │  │   Public        │ │   Private       │ │ │
│                    │  │   Subnet        │ │   Subnet        │ │ │
│                    │  │ (10.0.1.0/24)  │ │ (10.0.10.0/24) │ │ │
│                    │  │                 │ │                 │ │ │
│                    │  │ ┌─────────────┐ │ │ ┌─────────────┐ │ │ │
│                    │  │ │ Web Server  │ │ │ │ Database    │ │ │ │
│                    │  │ │ (Target)    │ │ │ │ Server      │ │ │ │
│                    │  │ │ EC2 Instance│ │ │ │ EC2 Instance│ │ │ │
│                    │  │ └─────────────┘ │ │ └─────────────┘ │ │ │
│                    │  └─────────────────┘ └─────────────────┘ │ │
│                    │                                         │ │
│                    │  ┌─────────────────────────────────────┐ │ │
│                    │  │        Security Services             │ │ │
│                    │  │  ┌─────────────┐ ┌─────────────┐   │ │ │
│                    │  │  │ GuardDuty   │ │ Security    │   │ │ │
│                    │  │  │ Detector    │ │ Hub         │   │ │ │
│                    │  │  └─────────────┘ └─────────────┘   │ │ │
│                    │  └─────────────────────────────────────┘ │ │
│                    │                                         │ │
│                    │  ┌─────────────────────────────────────┐ │ │
│                    │  │        Monitoring & Logging          │ │ │
│                    │  │  ┌─────────────┐ ┌─────────────┐   │ │ │
│                    │  │  │ CloudWatch  │ │ S3 Threat   │   │ │ │
│                    │  │  │ Logs &      │ │ Intelligence│   │ │ │
│                    │  │  │ Alarms      │ │ Bucket      │   │ │ │
│                    │  │  └─────────────┘ └─────────────┘   │ │ │
│                    └─────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## 🚀 Quick Start

### Prerequisites

- ✅ AWS Account with appropriate permissions
- ✅ AWS CLI v2 installed and configured
- ✅ Terraform v1.0+ installed
- ✅ PowerShell 7+ (Windows) or Bash (Linux/Mac)

### 🔐 **Security First!**

**⚠️ CRITICAL: Never commit AWS credentials to GitHub!**

This lab includes comprehensive security measures:
- **`.gitignore`** - Excludes all sensitive files
- **`env.template`** - Safe template for credentials
- **Security scripts** - Help secure credential setup
- **Documentation** - Complete security guidelines

**Quick Security Setup:**
```bash
# Windows
.\scripts\setup_credentials.ps1 setup

# Mac/Linux  
./scripts/setup_credentials.sh setup
```

### 1. Configure AWS Credentials

```powershell
# Option A: Interactive setup
aws configure

# Option B: Manual setup
# Edit C:\Users\[YourUsername]\.aws\credentials
[default]
aws_access_key_id = YOUR_ACCESS_KEY_ID
aws_secret_access_key = YOUR_SECRET_ACCESS_KEY

# Edit C:\Users\[YourUsername]\.aws\config
[default]
region = us-east-1
output = json
```

### 2. Verify Setup

```powershell
# Check AWS CLI
.\scripts\setup_lab.ps1 -Action check-aws

# Check Terraform
.\scripts\setup_lab.ps1 -Action check-terraform
```

### 3. Deploy Infrastructure

```powershell
# Initialize Terraform
.\scripts\setup_lab.ps1 -Action init

# Plan deployment
.\scripts\setup_lab.ps1 -Action plan

# Deploy infrastructure
.\scripts\setup_lab.ps1 -Action deploy
```

### 4. Run Security Lab

```powershell
# Simulate compromise scenarios
.\scripts\setup_lab.ps1 -Action simulate

# Monitor security findings
.\scripts\setup_lab.ps1 -Action monitor

# Clean up findings
.\scripts\setup_lab.ps1 -Action cleanup
```

### 5. Clean Up

```powershell
# Destroy infrastructure
.\scripts\setup_lab.ps1 -Action destroy
```

## 🔍 Lab Scenarios

### Scenario 1: Web Application Compromise
- **Target**: Public web server
- **Attack Vector**: SQL injection, file upload vulnerability
- **Detection**: GuardDuty findings for suspicious activities
- **Remediation**: Patch vulnerabilities, update security groups

### Scenario 2: Database Breach
- **Target**: Private database server
- **Attack Vector**: Unauthorized access, data exfiltration
- **Detection**: Security Hub compliance findings
- **Remediation**: Implement network segmentation, access controls

### Scenario 3: Lateral Movement
- **Target**: Internal network
- **Attack Vector**: Privilege escalation, network scanning
- **Detection**: GuardDuty network findings
- **Remediation**: Implement least privilege, network monitoring

## 🛡️ Security Services Used

### AWS GuardDuty
- **Threat Detection**: ML-based threat detection
- **Finding Types**: Unusual API calls, suspicious IPs, compromised instances
- **Integration**: CloudWatch, SNS, Security Hub

### AWS Security Hub
- **Security Standards**: CIS AWS Foundations, AWS Foundational Security Best Practices
- **Finding Aggregation**: Centralized security findings
- **Automated Response**: Integration with Lambda, Step Functions

### AWS CloudWatch
- **Log Aggregation**: Centralized logging and monitoring
- **Metrics**: Performance and security metrics
- **Alarms**: Automated alerting

## 📁 Project Structure

```
aws-lab/
├── terraform/                 # Infrastructure as Code
│   ├── main.tf               # Main Terraform configuration
│   ├── variables.tf          # Variable definitions
│   ├── modules/              # Reusable Terraform modules
│   │   ├── vpc/             # VPC and networking
│   │   ├── security_groups/ # Security group definitions
│   │   ├── ec2/             # EC2 instances
│   │   ├── s3/              # S3 bucket for threat intel
│   │   ├── guardduty/       # GuardDuty configuration
│   │   └── security_hub/    # Security Hub setup
│   └── outputs.tf           # Output values
├── scripts/                  # Automation scripts
│   └── setup_lab.ps1        # Main lab setup script
├── docs/                     # Documentation
│   └── SETUP_GUIDE.md       # Detailed setup guide
└── README.md                 # This file
```

## 🔧 Configuration

### Environment Variables
- `AWS_REGION`: AWS region for deployment (default: us-east-1)
- `AWS_PROFILE`: AWS CLI profile to use (default: default)

### Terraform Variables
- `environment`: Environment name (default: lab)
- `instance_type`: EC2 instance type (default: t3.micro)
- `vpc_cidr`: VPC CIDR block (default: 10.0.0.0/16)

## 📊 Monitoring & Alerting

### CloudWatch Dashboards
- **Security Metrics**: Failed login attempts, API call volumes
- **Performance Metrics**: CPU, memory, network utilization
- **Cost Metrics**: Resource usage and estimated costs

### SNS Notifications
- **GuardDuty Findings**: Real-time threat alerts
- **Security Hub Updates**: Compliance and security updates
- **Infrastructure Changes**: Terraform deployment notifications

## 🚨 Security Considerations

### Lab Environment
- ⚠️ **NOT FOR PRODUCTION**: This lab creates intentionally vulnerable resources
- 🔒 **ISOLATED NETWORK**: Resources are isolated in a dedicated VPC
- 🧹 **AUTOMATED CLEANUP**: Infrastructure is destroyed after lab completion

### Best Practices
- ✅ Use IAM roles with minimal required permissions
- ✅ Enable CloudTrail for audit logging
- ✅ Implement least privilege access
- ✅ Regular security assessments
- ✅ Automated security monitoring

## 🆘 Troubleshooting

### Common Issues

#### AWS CLI Configuration
```powershell
# Verify credentials
aws sts get-caller-identity

# Check profile
aws configure list
```

#### Terraform Errors
```powershell
# Check Terraform state
terraform show

# Validate configuration
terraform validate

# Check provider versions
terraform version
```

#### Permission Errors
- Ensure your AWS user has required permissions
- Check IAM policies for EC2, VPC, GuardDuty, Security Hub
- Verify region settings match your AWS account

### Getting Help

1. **Check the logs**: Review CloudWatch logs for error details
2. **Verify permissions**: Ensure AWS user has required IAM permissions
3. **Check region**: Verify resources are created in the correct region
4. **Review documentation**: Check AWS service documentation for limits and requirements

## 📚 Additional Resources

- [AWS GuardDuty Documentation](https://docs.aws.amazon.com/guardduty/)
- [AWS Security Hub Documentation](https://docs.aws.amazon.com/securityhub/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Security Best Practices](https://aws.amazon.com/security/security-learning/)

## 🤝 Contributing

This lab is designed for educational purposes. Feel free to:
- Report issues or bugs
- Suggest improvements
- Add new attack scenarios
- Enhance monitoring and detection

## 📄 License

This project is for educational purposes only. Use at your own risk in controlled lab environments.

---

**⚠️ DISCLAIMER**: This lab creates intentionally vulnerable resources for security training. Never deploy this infrastructure in production environments or on AWS accounts with production workloads.
