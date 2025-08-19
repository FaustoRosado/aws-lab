# AWS Security Lab - Documentation Index

## Quick Navigation

Choose your path based on what you want to learn:

- **New to AWS?** → Start with [AWS Credentials Setup](#aws-credentials-setup)
- **New to Terraform?** → Start with [Terraform Guide](#terraform-guide)
- **Want to run the lab?** → Go to [Setup Guide](#setup-guide)
- **Need comprehensive docs?** → Browse [All Documentation](#all-documentation)

---

## Getting Started (Beginner-Friendly)

### AWS Credentials Setup
- **[AWS Credentials Walkthrough](SECURITY_AND_CREDENTIALS.md)** - Complete guide to setting up AWS access
- **[Environment Template Guide](env.template.README.md)** - How to use the env.template file
- **[Credential Scripts Guide](scripts/README.md)** - Automated credential setup and validation

### Terraform Infrastructure as Code
- **[Terraform Guide](../terraform/README.md)** - Complete beginner's guide to Terraform
- **[Main.tf Guide](../terraform/main.tf.README.md)** - Understanding the infrastructure conductor
- **[Variables.tf Guide](../terraform/variables.tf.README.md)** - Configuration control center
- **[Outputs.tf Guide](../terraform/outputs.tf.README.md)** - Information highway and data flow
- **[VPC Module Guide](../terraform/modules/vpc/README.md)** - Understanding networking
- **[EC2 Module Guide](../terraform/modules/ec2/README.md)** - Understanding virtual servers
- **[Security Groups Guide](../terraform/modules/security_groups/README.md)** - Understanding firewalls
- **[GuardDuty Module Guide](../terraform/modules/guardduty/README.md)** - Understanding threat detection
- **[IAM Module Guide](../terraform/modules/iam/README.md)** - Understanding access management
- **[S3 Module Guide](../terraform/modules/s3/README.md)** - Understanding object storage
- **[Security Hub Module Guide](../terraform/modules/security_hub/README.md)** - Understanding security management

### Lab Setup & Execution
- **[Setup Guide](SETUP_GUIDE.md)** - Step-by-step lab setup instructions
- **[Quick Start](../QUICK_START.md)** - Get up and running fast
- **[Lab Checklist](LAB_CHECKLIST.md)** - Track your progress through the lab

---

## All Documentation

### Security & Credentials
- **[Security and Credentials Guide](SECURITY_AND_CREDENTIALS.md)** - Comprehensive AWS security setup
- **[Environment Template](env.template.README.md)** - Safe credential management
- **[Credential Scripts](scripts/README.md)** - Automated setup tools

### Infrastructure & Terraform
- **[Main Terraform Guide](../terraform/README.md)** - Complete Terraform tutorial
- **[Main.tf Guide](../terraform/main.tf.README.md)** - Infrastructure conductor and orchestration
- **[Variables.tf Guide](../terraform/variables.tf.README.md)** - Configuration management
- **[Outputs.tf Guide](../terraform/outputs.tf.README.md)** - Data flow and module communication
- **[VPC Module](../terraform/modules/vpc/README.md)** - Network foundation
- **[EC2 Module](../terraform/modules/ec2/README.md)** - Virtual servers
- **[Security Groups Module](../terraform/modules/security_groups/README.md)** - Firewall rules
- **[GuardDuty Module](../terraform/modules/guardduty/README.md)** - Threat detection
- **[IAM Module](../terraform/modules/iam/README.md)** - Access management
- **[S3 Module](../terraform/modules/s3/README.md)** - Object storage
- **[Security Hub Module](../terraform/modules/security_hub/README.md)** - Security management
- **[Project Structure](PROJECT_STRUCTURE.md)** - How the project is organized

### Lab Execution
- **[Setup Guide](SETUP_GUIDE.md)** - Complete lab setup
- **[Quick Start](../QUICK_START.md)** - Fast deployment
- **[Lab Checklist](LAB_CHECKLIST.md)** - Progress tracking
- **[Module Documentation](MODULE_DOCUMENTATION.md)** - Deep dive into each component

---

## Learning Paths

### Complete Beginner Path
1. **[AWS Credentials Setup](SECURITY_AND_CREDENTIALS.md)** - Get AWS access
2. **[Terraform Guide](../terraform/README.md)** - Learn infrastructure as code
3. **[Setup Guide](SETUP_GUIDE.md)** - Deploy your first lab
4. **[Lab Checklist](LAB_CHECKLIST.md)** - Complete the security scenarios

### Developer Path
1. **[Quick Start](../QUICK_START.md)** - Deploy quickly
2. **[Module Documentation](MODULE_DOCUMENTATION.md)** - Understand the architecture
3. **[Project Structure](PROJECT_STRUCTURE.md)** - Learn the codebase
4. **[Customize and Extend](../terraform/README.md)** - Modify the infrastructure

### Security Professional Path
1. **[Setup Guide](SETUP_GUIDE.md)** - Deploy the lab
2. **[Lab Checklist](LAB_CHECKLIST.md)** - Run security scenarios
3. **[Module Deep Dives](../terraform/modules/)** - Understand each component
4. **[Extend with New Services](../terraform/README.md)** - Add more security tools
5. **[Security Tools Deep Dive](../terraform/modules/guardduty/README.md)** - Master threat detection
6. **[Access Management](../terraform/modules/iam/README.md)** - Understand IAM security

---

## Time-Based Recommendations

### 15 Minutes
- **[Quick Start](../QUICK_START.md)** - Deploy the lab quickly
- **[AWS Credentials Setup](SECURITY_AND_CREDENTIALS.md)** - Basic AWS setup

### 1 Hour
- **[Setup Guide](SETUP_GUIDE.md)** - Complete lab deployment
- **[Lab Checklist](LAB_CHECKLIST.md)** - Run basic security scenarios
- **[Terraform Guide](../terraform/README.md)** - Learn infrastructure basics

### 4 Hours
- **[Module Documentation](MODULE_DOCUMENTATION.md)** - Deep dive into components
- **[Project Structure](PROJECT_STRUCTURE.md)** - Understand the architecture
- **[Customize Infrastructure](../terraform/README.md)** - Modify and extend

### 8 Hours (Full Day)
- **[Complete Lab Execution](LAB_CHECKLIST.md)** - Run all security scenarios
- **[Advanced Customization](../terraform/README.md)** - Build custom security tools
- **[Integration Testing](../terraform/README.md)** - Test with real-world scenarios

---

## Skill Level Recommendations

### Beginner (0-6 months AWS experience)
- Start with [AWS Credentials Setup](SECURITY_AND_CREDENTIALS.md)
- Follow the [Complete Beginner Path](#complete-beginner-path)
- Use [Setup Guide](SETUP_GUIDE.md) for step-by-step instructions

### Intermediate (6 months - 2 years AWS experience)
- Jump to [Quick Start](../QUICK_START.md)
- Follow the [Developer Path](#developer-path)
- Customize using [Module Documentation](MODULE_DOCUMENTATION.md)

### Advanced (2+ years AWS experience)
- Use [Project Structure](PROJECT_STRUCTURE.md) to understand architecture
- Follow the [Security Professional Path](#security-professional-path)
- Extend with [Advanced Customization](../terraform/README.md)

---

## Common Use Cases

### Learning AWS Security
1. **[Setup Guide](SETUP_GUIDE.md)** - Deploy the lab
2. **[Lab Checklist](LAB_CHECKLIST.md)** - Run security scenarios
3. **[Module Deep Dives](../terraform/modules/)** - Understand each service

### Teaching/Training
1. **[Project Structure](PROJECT_STRUCTURE.md)** - Understand the curriculum
2. **[Lab Checklist](LAB_CHECKLIST.md)** - Follow the learning path
3. **[Module Documentation](MODULE_DOCUMENTATION.md)** - Reference materials

### Production Deployment
1. **[Security and Credentials](SECURITY_AND_CREDENTIALS.md)** - Secure setup
2. **[Terraform Guide](../terraform/README.md)** - Infrastructure deployment
3. **[Customization](../terraform/README.md)** - Adapt for your needs

---

## Troubleshooting & Support

### Common Issues
- **[AWS Credentials Setup](SECURITY_AND_CREDENTIALS.md)** - Authentication problems
- **[Setup Guide](SETUP_GUIDE.md)** - Deployment issues
- **[Module Documentation](MODULE_DOCUMENTATION.md)** - Component-specific problems

### Getting Help
- Check the [Lab Checklist](LAB_CHECKLIST.md) for step-by-step guidance
- Review [Module Documentation](MODULE_DOCUMENTATION.md) for detailed explanations
- Use [Project Structure](PROJECT_STRUCTURE.md) to understand the architecture

---

## What's Next?

After completing the lab:

1. **Customize the Infrastructure** - Modify Terraform configurations
2. **Add New Services** - Extend with additional AWS security tools
3. **Real-World Scenarios** - Apply learnings to production environments
4. **Share Knowledge** - Teach others using this lab as a foundation

---

<div align="center">
  <p><em>Your AWS Security Lab documentation is ready!</em></p>
</div>
