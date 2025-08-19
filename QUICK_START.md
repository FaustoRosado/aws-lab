# Quick Start Guide - AWS Security Lab

Get up and running with the AWS Security Lab in just 5 minutes!

## Get Started in 5 Minutes

### 1. Prerequisites (2 minutes)
- AWS Account with appropriate permissions
- AWS CLI v2 installed and configured
- Terraform v1.0+ installed
- PowerShell 7+ (Windows) or Bash (Linux/Mac)

### 2. Configure AWS Credentials (1 minute)
```bash
# Windows
aws configure

# Mac/Linux
aws configure
```

### 3. Deploy Infrastructure (2 minutes)
```bash
# Navigate to terraform directory
cd terraform

# Initialize Terraform
terraform init

# Deploy infrastructure
terraform apply -auto-approve
```

That's it! Your lab infrastructure is now running.

## What You'll Learn

- **Infrastructure as Code** with Terraform
- **AWS Security Services** (GuardDuty, Security Hub, CloudWatch)
- **Threat Detection** and response
- **Security Monitoring** and alerting
- **Incident Response** procedures

## Next Steps

1. **Run Security Scenarios** - Use the simulation scripts
2. **Monitor Findings** - Check GuardDuty and Security Hub
3. **Investigate Threats** - Analyze security alerts
4. **Practice Remediation** - Implement security controls
5. **Clean Up** - Destroy infrastructure when done

## Important Notes

- This lab creates intentionally vulnerable resources for educational purposes
- Never deploy this infrastructure in production environments
- Monitor your AWS costs and clean up resources when finished
- All resources are isolated in a dedicated VPC for safety

**Ready to start?** Run `aws configure` and then follow the steps above!
