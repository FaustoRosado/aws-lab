# Advanced Cyber Range - P2W12 Quantum Shield

## Project Overview

This directory contains the complete implementation of the Advanced Cyber Range project, featuring a sophisticated three-tiered cybersecurity lab environment in AWS. The project demonstrates advanced threat detection, network security, and incident response capabilities using Infrastructure as Code principles.

## Architecture Components

### Infrastructure Layer
- **Network Design**: Multi-AZ VPC with public, application, and data tiers
- **Security Groups**: Microsegmentation with least-privilege access controls
- **EC2 Instances**: Kali Linux attacker, web target, and database servers
- **Monitoring**: CloudWatch integration with custom dashboards and alerts

### Security Features
- **Threat Detection**: Advanced monitoring and alerting systems
- **Network Isolation**: Private subnets with controlled internet access
- **Access Control**: Role-based permissions with temporary credential management
- **Compliance**: Multi-AZ deployment with encryption and audit trails

## Directory Structure

```
p2w12-quantum-shield/
├── terraform/                    # Infrastructure as Code
│   ├── main.tf                  # Main Terraform configuration
│   ├── network.tf               # VPC and networking resources
│   ├── security.tf              # Security groups and IAM
│   ├── instances.tf             # EC2 instance definitions
│   ├── instructor-access.tf     # Cross-account access setup
│   └── outputs.tf               # Output values and information
├── setup-instructor-access.sh   # Instructor access automation
├── check-credentials-expiration.sh # Credential management
├── security_monitor.sh          # Security monitoring script
├── cloudwatch-*.json            # CloudWatch configuration files
├── security-monitor.service     # Systemd service definition
└── *.md                         # Documentation files
```

## Quick Start Guide

### Prerequisites
- AWS CLI configured with appropriate permissions
- Terraform installed (version >= 1.0)
- SSH key pair in AWS Console
- Public IP address for SSH access

### Deployment Steps

1. **Navigate to Terraform Directory**
   ```bash
   cd p2w12-quantum-shield/terraform
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Plan Deployment**
   ```bash
   terraform plan -var="my_ip=YOUR_PUBLIC_IP/32" -var="key_name=your-key-name"
   ```

4. **Deploy Infrastructure**
   ```bash
   terraform apply -var="my_ip=YOUR_PUBLIC_IP/32" -var="key_name=your-key-name"
   ```

5. **Access Kali Machine**
   ```bash
   ssh -i your-key-name.pem kali@<KALI_PUBLIC_IP>
   ```

## Instructor Access System

### Temporary Credentials Setup
The project includes an automated instructor access system that provides temporary credentials with automatic expiration:

```bash
# Set up instructor access (24-hour expiration)
./setup-instructor-access.sh

# Check credential status
./check-credentials-expiration.sh
```

### Features
- **Automatic Expiration**: Credentials expire after 24 hours
- **Local Storage**: Secure credential management on instructor's machine
- **AWS Console Access**: Full visual access to AWS resources
- **Audit Trail**: All access logged through CloudTrail

## Security Monitoring

### CloudWatch Integration
- Custom dashboards for security metrics
- Automated alerting for suspicious activities
- Log aggregation and analysis
- Performance monitoring and optimization

### Security Scripts
- `security_monitor.sh`: Continuous security monitoring
- `security-monitor.service`: Systemd service for automated monitoring
- Threat intelligence integration
- Incident response automation

## Network Architecture

### Three-Tier Design
1. **Public Tier (DMZ)**: Internet-facing resources
   - Kali Linux attacker machine
   - Bastion host for secure access
   
2. **Application Tier**: Protected web services
   - Web application servers
   - Load balancers and proxies
   
3. **Data Tier**: Secure data storage
   - Database servers
   - File storage systems
   - No direct internet access

### Security Groups
- **kali-sg**: SSH access from authorized IPs
- **webtarget-sg**: HTTP/HTTPS access from kali-sg
- **database-sg**: Database access from webtarget-sg only

## Monitoring and Alerting

### CloudWatch Configuration
- **Dashboard**: Real-time security metrics visualization
- **Alarms**: Automated alerting for security events
- **Logs**: Centralized logging and analysis
- **Metrics**: Performance and security monitoring

### Security Alerts
- Unauthorized access attempts
- Unusual network traffic patterns
- Resource utilization anomalies
- Compliance violations

## Cost Management

### Resource Optimization
- Use of t2.micro instances where possible
- Automatic cleanup with `terraform destroy`
- Resource tagging for cost allocation
- Monitoring of AWS billing dashboard

### Estimated Costs
- **Development/Testing**: $5-15 per day
- **Production**: $20-50 per day
- **Long-term**: Consider reserved instances for cost savings

## Maintenance and Updates

### Regular Tasks
- Monitor CloudWatch metrics and logs
- Review security group rules and access logs
- Update threat intelligence feeds
- Review and rotate credentials

### Backup and Recovery
- Terraform state backup
- Configuration file versioning
- Disaster recovery procedures
- Documentation updates

## Troubleshooting

### Common Issues
1. **SSH Connection Failed**
   - Verify security group allows your IP
   - Check key pair name matches
   - Ensure instance is running

2. **Terraform Errors**
   - Verify AWS credentials
   - Check variable syntax
   - Ensure sufficient service limits

3. **Monitoring Issues**
   - Verify CloudWatch permissions
   - Check log group configurations
   - Review IAM role policies

### Support Resources
- AWS Documentation: VPC User Guide
- Terraform Documentation: AWS Provider
- Security Best Practices: AWS Security Documentation
- Project Documentation: See individual .md files

## Team Collaboration

### Version Control
- Use feature branches for development
- Require pull request reviews
- Maintain deployment documentation
- Track infrastructure changes

### Documentation Standards
- Update README files with changes
- Document configuration decisions
- Maintain deployment procedures
- Record troubleshooting solutions

## Compliance and Security

### Security Standards
- NIST Cybersecurity Framework
- AWS Well-Architected Framework
- Industry best practices
- Regular security assessments

### Audit Requirements
- Access logging and monitoring
- Change management documentation
- Security group rule reviews
- Compliance reporting

## Next Steps

### Immediate Actions
- Deploy infrastructure using Terraform
- Configure monitoring and alerting
- Test security controls and access
- Document deployment procedures

### Future Enhancements
- Multi-region deployment
- Advanced threat detection
- Automated incident response
- Integration with SIEM systems

---

**Project Status**: Active Development  
**Last Updated**: [Current Date]  
**Team**: P2W12 Security Team  
**Contact**: [Team Lead Information]
