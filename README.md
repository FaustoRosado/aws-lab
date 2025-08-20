# AWS Security Lab: EC2 Compromise & Remediation

This lab simulates an EC2 compromise scenario and demonstrates how to detect and remediate security threats using AWS GuardDuty and Security Hub.

## Lab Objectives

- **Infrastructure Setup**: Deploy a vulnerable web application and database server
- **Threat Simulation**: Simulate various attack scenarios to trigger security alerts
- **Detection**: Use AWS GuardDuty to detect suspicious activities
- **Investigation**: Analyze findings in AWS Security Hub
- **Remediation**: Implement security controls and clean up compromised resources

## Lab Architecture

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

## Quick Start

### Prerequisites

- AWS Account with appropriate permissions
- AWS CLI v2 installed and configured
- Terraform v1.0+ installed
- PowerShell 7+ (Windows) or Bash (Linux/Mac)

### Security First!

**CRITICAL: Never commit AWS credentials to GitHub!**

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

## Fast Cleanup (If Needed)

**If `terraform destroy` gets stuck or takes too long, use our fast cleanup scripts:**

### Windows (PowerShell):
```powershell
.\fast_cleanup.ps1
```

### Linux/Mac:
```bash
chmod +x fast_cleanup.sh
./fast_cleanup.sh
```

**These scripts will clean up everything in under 30 seconds!**

**Why Fast Cleanup?**
- **Cybersecurity professionals need speed** - no time to wait
- **Avoid AWS charges** - quick resource termination
- **Handle stuck deployments** - bypass Terraform issues
- **Production-ready** - reliable cleanup every time

## Lab Scenarios

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

## Security Services Used

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

## Project Structure

```
aws-lab/
├── terraform/                           # Infrastructure as Code
│   ├── main.tf                         # Main Terraform configuration
│   ├── variables.tf                    # Variable definitions  
│   ├── outputs.tf                      # Output values
│   ├── main.tf.README.md               # Infrastructure conductor guide
│   ├── variables.tf.README.md          # Configuration control center guide
│   ├── outputs.tf.README.md            # Information highway guide
│   ├── README.md                        # Complete Terraform beginner's guide
│   └── modules/                        # Reusable Terraform modules
│       ├── vpc/                        # VPC and networking
│       │   ├── main.tf                 # VPC, subnets, route tables
│       │   ├── variables.tf            # VPC configuration variables
│       │   ├── outputs.tf              # VPC outputs
│       │   └── README.md               # VPC module guide
│       ├── security_groups/            # Security group definitions
│       │   ├── main.tf                 # Security group rules
│       │   ├── variables.tf            # Security group variables
│       │   ├── outputs.tf              # Security group outputs
│       │   └── README.md               # Security groups guide
│       ├── ec2/                        # EC2 instances
│       │   ├── main.tf                 # EC2 instances and key pairs
│       │   ├── variables.tf            # EC2 configuration variables
│       │   ├── outputs.tf              # EC2 outputs
│       │   ├── README.md               # EC2 module guide
│       │   └── user_data/              # Instance bootstrapping scripts
│       │       ├── web_server.sh       # Web server setup script
│       │       └── database_server.sh  # Database server setup script
│       ├── s3/                         # S3 bucket for threat intel
│       │   ├── main.tf                 # S3 bucket configuration
│       │   ├── variables.tf            # S3 configuration variables
│       │   ├── outputs.tf              # S3 outputs
│       │   └── sample_data/            # Sample threat intelligence data
│       │       └── threats/            # Malware indicators and samples
│       ├── guardduty/                  # GuardDuty configuration
│       │   ├── main.tf                 # GuardDuty detector setup
│       │   ├── variables.tf            # GuardDuty configuration variables
│       │   └── outputs.tf              # GuardDuty outputs
│       ├── security_hub/               # Security Hub setup
│       │   ├── main.tf                 # Security Hub configuration
│       │   ├── variables.tf            # Security Hub variables
│       │   └── outputs.tf              # Security Hub outputs
│       ├── cloudwatch/                 # CloudWatch monitoring
│       │   ├── main.tf                 # CloudWatch logs and dashboards
│       │   ├── variables.tf            # CloudWatch variables
│       │   └── outputs.tf              # CloudWatch outputs
│       └── iam/                        # IAM roles and policies
│           ├── main.tf                 # IAM roles and instance profiles
│           ├── variables.tf            # IAM configuration variables
│           └── outputs.tf              # IAM outputs
├── scripts/                             # Automation scripts
│   ├── setup_lab.ps1                   # Main lab setup script (PowerShell)
│   ├── setup_lab.sh                    # Main lab setup script (Bash)
│   ├── simulate_compromise.ps1         # Attack simulation script
│   ├── setup_credentials.ps1           # Windows credential setup
│   ├── setup_credentials.sh            # Mac/Linux credential setup
│   └── README.md                       # Scripts usage guide
├── docs/                                # Comprehensive documentation
│   ├── INDEX.md                         # Master documentation index
│   ├── SETUP_GUIDE.md                  # Complete lab setup guide
│   ├── LAB_CHECKLIST.md                # Lab progress checklist
│   ├── SECURITY_AND_CREDENTIALS.md     # AWS security setup guide
│   ├── PROJECT_STRUCTURE.md             # Project organization guide
│   └── MODULE_DOCUMENTATION.md         # Module deep dive guide
├── .gitignore                           # Git ignore patterns
├── env.template                         # Environment variables template
├── env.template.README.md               # Environment template guide
├── QUICK_START.md                       # Fast deployment guide
├── GITHUB_COMMIT_STRATEGY.md           # Structured commit strategy
└── README.md                            # This main project file
```

## Configuration

### Environment Variables
- `AWS_REGION`: AWS region for deployment (default: us-east-1)
- `AWS_PROFILE`: AWS CLI profile to use (default: default)

### Terraform Variables
- `environment`: Environment name (default: lab)
- `instance_type`: EC2 instance type (default: t3.micro)
- `vpc_cidr`: VPC CIDR block (default: 10.0.0.0/16)

## Monitoring & Alerting

### CloudWatch Dashboards
- **Security Metrics**: Failed login attempts, API call volumes
- **Performance Metrics**: CPU, memory, network utilization
- **Cost Metrics**: Resource usage and estimated costs

### SNS Notifications
- **GuardDuty Findings**: Real-time threat alerts
- **Security Hub Updates**: Compliance and security updates
- **Infrastructure Changes**: Terraform deployment notifications

## Security Considerations

### Lab Environment
- **NOT FOR PRODUCTION**: This lab creates intentionally vulnerable resources
- **ISOLATED NETWORK**: Resources are isolated in a dedicated VPC
- **AUTOMATED CLEANUP**: Infrastructure is destroyed after lab completion

### Best Practices
- Use IAM roles with minimal required permissions
- Enable CloudTrail for audit logging
- Implement least privilege access
- Regular security assessments
- Automated security monitoring

## Troubleshooting

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

## Additional Resources

- [AWS GuardDuty Documentation](https://docs.aws.amazon.com/guardduty/)
- [AWS Security Hub Documentation](https://docs.aws.amazon.com/securityhub/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Security Best Practices](https://aws.amazon.com/security/security-learning/)

## Contributing

This lab is designed for educational purposes. Feel free to:
- Report issues or bugs
- Suggest improvements
- Add new attack scenarios
- Enhance monitoring and detection

## License

This project is for educational purposes only. Use at your own risk in controlled lab environments.

---

**DISCLAIMER**: This lab creates intentionally vulnerable resources for security training. Never deploy this infrastructure in production environments or on AWS accounts with production workloads.
