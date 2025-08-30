# Advanced Cyber Range - AWS Security Lab

## Project Overview

This project implements a sophisticated, three-tiered cybersecurity lab environment in AWS using Infrastructure as Code (IaC) principles. The lab simulates a real-world corporate network architecture with multiple security layers, providing hands-on experience in penetration testing, network security, and incident response.

## Architecture Overview

### Three-Tier Network Design
- **Public Tier (DMZ)**: Internet-facing resources including Kali Linux attacker machine
- **Application Tier**: Protected web servers and application servers
- **Data Tier**: Highly secure database servers with no internet access

### Security Features
- **Microsegmentation**: Security groups reference each other for least-privilege access
- **Network Isolation**: Private subnets with controlled internet access via NAT Gateway
- **Multi-AZ Deployment**: High availability across multiple availability zones
- **Stateful Firewalls**: Security groups with specific ingress/egress rules

## Team Roles & Responsibilities

### **Team Lead / Project Manager**
- **Responsibilities**: Overall project coordination, timeline management, stakeholder communication
- **Deliverables**: Project plan, status reports, risk management
- **Skills**: Project management, AWS architecture, team leadership

### **Infrastructure Engineer**
- **Responsibilities**: Terraform code development, AWS resource provisioning, network design
- **Deliverables**: Infrastructure as Code, network diagrams, deployment scripts
- **Skills**: Terraform, AWS networking, infrastructure automation

### **Security Engineer**
- **Responsibilities**: Security group configuration, compliance validation, security testing
- **Deliverables**: Security architecture, compliance reports, penetration testing results
- **Skills**: AWS security, compliance frameworks, security testing

### **DevOps Engineer**
- **Responsibilities**: CI/CD pipeline setup, monitoring configuration, automation scripts
- **Deliverables**: Deployment automation, monitoring dashboards, operational procedures
- **Skills**: CI/CD tools, monitoring, automation scripting

### **Documentation Specialist**
- **Responsibilities**: Technical documentation, user guides, screenshot capture
- **Deliverables**: User manuals, technical specifications, training materials
- **Skills**: Technical writing, documentation tools, process documentation

## Prerequisites

### AWS Requirements
- AWS Account with appropriate permissions
- AWS CLI configured with credentials
- SSH key pair created in AWS Console
- Public IP address for SSH access

### Local Requirements
- Terraform installed (version >= 1.0)
- SSH client (PuTTY, OpenSSH, etc.)
- Git for version control

## Deployment Instructions

### 1. Initialize Terraform
```bash
cd p2w12-quantum-shield/terraform
terraform init
```

### 2. Plan Deployment
```bash
terraform plan -var="my_ip=YOUR_PUBLIC_IP/32" -var="key_name=your-key-name"
```

### 3. Deploy Infrastructure
```bash
terraform apply -var="my_ip=YOUR_PUBLIC_IP/32" -var="key_name=your-key-name"
```

### 4. Access Kali Machine
```bash
ssh -i your-key-name.pem kali@<KALI_PUBLIC_IP>
```

## Instructor Access System

### Temporary Credentials Setup
The project includes an automated instructor access system that provides temporary credentials with automatic expiration:

```bash
# Set up instructor access (24-hour expiration)
cd p2w12-quantum-shield
./setup-instructor-access.sh

# Check credential status
./check-credentials-expiration.sh
```

### Features
- **Automatic Expiration**: Credentials expire after 24 hours
- **Local Storage**: Secure credential management on instructor's machine
- **AWS Console Access**: Full visual access to AWS resources
- **Audit Trail**: All access logged through CloudTrail

## Security Considerations

### Network Security
- All subnets use private IP ranges (10.10.0.0/16)
- Public subnets only for internet-facing resources
- Private subnets have controlled internet access via NAT Gateway
- Data tier completely isolated from internet

### Access Control
- SSH access restricted to specific IP addresses
- Security groups implement least-privilege principle
- No direct internet access to sensitive resources
- Microsegmentation between network tiers

### Compliance Features
- Multi-AZ deployment for high availability
- Encrypted data in transit and at rest
- Comprehensive logging and monitoring
- Audit trail through Terraform state

## Cost Management

### Resource Optimization
- Use of t2.micro instances where possible (free tier eligible)
- Automatic cleanup with `terraform destroy`
- Resource tagging for cost allocation
- Monitoring of AWS billing dashboard

### Cleanup Commands
```bash
# Destroy all resources when finished
terraform destroy -var="my_ip=YOUR_PUBLIC_IP/32" -var="key_name=your-key-name"
```

## Monitoring & Maintenance

### AWS Services Used
- **VPC**: Network isolation and routing
- **EC2**: Virtual machines for lab instances
- **Security Groups**: Stateful firewalls
- **NAT Gateway**: Controlled internet access
- **Route Tables**: Traffic routing control

### Best Practices
- Regular security group reviews
- Monitoring of AWS CloudTrail logs
- Regular Terraform plan reviews
- Documentation updates with each deployment

## Troubleshooting

### Common Issues
1. **SSH Connection Failed**: Verify security group rules and key pair
2. **Terraform Plan Errors**: Check variable values and AWS credentials
3. **Resource Creation Failed**: Verify AWS service limits and permissions

### Support Resources
- AWS Documentation: [VPC User Guide](https://docs.aws.amazon.com/vpc/)
- Terraform Documentation: [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- Security Best Practices: [AWS Security Documentation](https://aws.amazon.com/security/)

## Project Timeline

### Phase 1: Infrastructure Setup (Week 1)
- [x] Terraform code development
- [x] Network architecture design
- [x] Security group configuration

### Phase 2: Deployment & Testing (Week 2)
- [ ] Infrastructure deployment
- [ ] Security testing and validation
- [ ] Performance optimization

### Phase 3: Documentation & Training (Week 3)
- [ ] User documentation completion
- [ ] Team training sessions
- [ ] Process documentation

### Phase 4: Production Readiness (Week 4)
- [ ] Final security review
- [ ] Compliance validation
- [ ] Production deployment

## Contact Information

### Team Lead
- **Name**: [Team Lead Name]
- **Email**: [team.lead@company.com]
- **Slack**: [@team-lead]

### Technical Support
- **Infrastructure**: [infra@company.com]
- **Security**: [security@company.com]
- **DevOps**: [devops@company.com]

---

**Last Updated**: [Current Date]
**Version**: 1.0
**Status**: In Development
