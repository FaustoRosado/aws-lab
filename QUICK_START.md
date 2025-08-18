# 🚀 Quick Start Guide - AWS Security Lab

## ⚡ Get Started in 5 Minutes

### 1. Configure AWS Credentials
```powershell
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Enter your preferred region (e.g., us-east-1)
# Enter output format (json)
```

### 2. Verify Setup
```powershell
.\scripts\setup_lab.ps1 -Action check-aws
.\scripts\setup_lab.ps1 -Action check-terraform
```

### 3. Deploy Lab Infrastructure
```powershell
.\scripts\setup_lab.ps1 -Action init
.\scripts\setup_lab.ps1 -Action plan
.\scripts\setup_lab.ps1 -Action deploy
```

### 4. Run Security Lab
```powershell
# Get your web server IP from Terraform outputs
terraform output public_web_public_ip

# Run compromise simulation
.\scripts\simulate_compromise.ps1 -WebServerIP <YOUR_WEB_SERVER_IP>

# Monitor findings
.\scripts\setup_lab.ps1 -Action monitor
```

### 5. Clean Up
```powershell
.\scripts\setup_lab.ps1 -Action destroy
```

## 🔑 What You'll Learn

- **AWS GuardDuty**: ML-based threat detection
- **AWS Security Hub**: Centralized security findings
- **Infrastructure Security**: VPC, security groups, IAM
- **Incident Response**: Detection, investigation, remediation
- **Security Monitoring**: CloudWatch, SNS, dashboards

## 📚 Next Steps

1. Read the full [README.md](README.md)
2. Follow the [SETUP_GUIDE.md](docs/SETUP_GUIDE.md)
3. Use the [LAB_CHECKLIST.md](docs/LAB_CHECKLIST.md) to track progress
4. Explore the [scripts/](scripts/) directory for automation

## ⚠️ Important Notes

- **Educational Use Only**: This lab creates intentionally vulnerable resources
- **Cost Awareness**: AWS resources will incur charges
- **Clean Up**: Always destroy infrastructure after completing the lab
- **Security**: Never deploy this in production environments

---

**Ready to start?** Run `aws configure` and then follow the steps above! 🚀
