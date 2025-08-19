# AWS Security Lab - Completion Checklist

This checklist helps you track your progress through the EC2 Compromise & Remediation lab.

## Pre-Lab Setup

- [ ] AWS CLI installed and configured
- [ ] Terraform installed
- [ ] AWS credentials configured
- [ ] Lab directory structure created
- [ ] Required AWS permissions verified

## Infrastructure Deployment

- [ ] Terraform initialized (`terraform init`)
- [ ] Infrastructure plan reviewed (`terraform plan`)
- [ ] Infrastructure deployed (`terraform apply`)
- [ ] VPC and subnets created
- [ ] Security groups configured
- [ ] EC2 instances launched
- [ ] S3 bucket created
- [ ] GuardDuty enabled
- [ ] Security Hub enabled
- [ ] CloudWatch dashboard created

## Infrastructure Verification

- [ ] VPC created with correct CIDR blocks
- [ ] Public and private subnets configured
- [ ] Internet Gateway attached
- [ ] Route tables configured
- [ ] Security groups with appropriate rules
- [ ] EC2 instances accessible via SSH
- [ ] Web server responding on HTTP
- [ ] Database server accessible from web server

## Compromise Simulation

- [ ] Port scanning simulation completed
- [ ] Brute force attack simulation completed
- [ ] SQL injection simulation completed
- [ ] Malicious file upload simulation completed
- [ ] Network scanning simulation completed
- [ ] All simulation scripts executed successfully

## Security Detection

- [ ] GuardDuty findings generated
- [ ] Security Hub findings generated
- [ ] CloudWatch metrics populated
- [ ] SNS notifications received (if configured)
- [ ] Security dashboard accessible

## Investigation & Analysis

- [ ] GuardDuty findings reviewed
- [ ] Security Hub findings analyzed
- [ ] CloudWatch logs examined
- [ ] EC2 instance logs reviewed
- [ ] Network traffic patterns analyzed
- [ ] Security group rules reviewed

## Remediation Actions

- [ ] Vulnerable web application patched
- [ ] Security group rules tightened
- [ ] Unnecessary ports closed
- [ ] Access controls implemented
- [ ] Monitoring enhanced
- [ ] Incident response procedures documented

## Monitoring & Alerting

- [ ] CloudWatch alarms configured
- [ ] SNS topics for notifications
- [ ] Log aggregation working
- [ ] Metrics collection active
- [ ] Dashboard accessible and functional

## Lab Cleanup

- [ ] Infrastructure destroyed (`terraform destroy`)
- [ ] AWS resources cleaned up
- [ ] Local files cleaned up
- [ ] SSH keys removed
- [ ] Lab artifacts archived (if needed)

## Learning Objectives Achieved

- [ ] Understand AWS security services (GuardDuty, Security Hub)
- [ ] Experience threat detection in action
- [ ] Practice incident response procedures
- [ ] Learn infrastructure security best practices
- [ ] Understand monitoring and alerting
- [ ] Practice remediation techniques

## Additional Exploration

- [ ] Try different attack vectors
- [ ] Test different security configurations
- [ ] Experiment with different monitoring setups
- [ ] Practice with different remediation techniques
- [ ] Explore additional AWS security services

## Notes & Observations

Use this space to document your findings, challenges, and insights:

- **What worked well:**
- **Challenges encountered:**
- **Key learnings:**
- **Areas for improvement:**
- **Next steps:**

---

## Completion Status

- **Total Tasks:** 50+
- **Completed:** ___ / ___
- **Completion Rate:** ___%

**Lab Status:** [ ] Not Started [ ] In Progress [ ] Completed [ ] Mastered

---

<div align="center">
  <p><em>Track your progress and document your learning journey!</em></p>
</div>
