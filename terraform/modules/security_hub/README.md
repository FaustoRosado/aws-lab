# Security Hub Module - Centralized Security Management

## What is Security Hub?

**Security Hub** is AWS's **centralized security service** that aggregates, organizes, and prioritizes security findings from multiple AWS services. Think of it as a **security command center** that gives you a comprehensive view of your security posture across your entire AWS environment.

### Real-World Analogy

- **Security Hub** = A security operations center (SOC)
- **Security Standards** = Security frameworks and compliance requirements
- **Findings** = Security alerts and issues that need attention
- **Automated Actions** = Automated responses to security threats
- **Integration** = Connects all your security tools together
- **Compliance** = Ensures you meet security requirements

---

## What This Module Creates

This module sets up **comprehensive security monitoring** for your AWS environment:

- **Security Hub** - Central security management service
- **Security Standards** - Compliance frameworks (CIS, PCI DSS, etc.)
- **Finding Aggregation** - Collects security findings from all services
- **Automated Actions** - Responds to security threats automatically
- **SNS Integration** - Sends security alerts and notifications
- **Compliance Monitoring** - Tracks security compliance status

---

## Module Structure

```
security_hub/
├── main.tf      # Creates Security Hub and security standards
├── variables.tf # What the module needs as input
├── outputs.tf   # What the module provides to others
└── README.md    # This file!
```

---

## Input Variables Explained

### Environment Configuration

```hcl
variable "environment" {
  description = "Environment name for tagging and naming"
  type        = string
  default     = "lab"
}
```

**What this means:** All Security Hub resources get tagged with your environment (dev, staging, prod)

### Region Configuration

```hcl
variable "aws_region" {
  description = "AWS region where Security Hub will be enabled"
  type        = string
  default     = "us-east-1"
}
```

**What this means:** Security Hub will be enabled in this specific AWS region

### Security Standards Configuration

```hcl
variable "enable_cis_standard" {
  description = "Enable CIS AWS Foundations Benchmark"
  type        = bool
  default     = true
}

variable "enable_pci_standard" {
  description = "Enable PCI DSS standard"
  type        = bool
  default     = false
}
```

**What this means:** Controls which security compliance standards to enable for your environment

---

## How It Works (Step by Step)

### Step 1: Enable Security Hub

```hcl
resource "aws_securityhub_account" "main" {
  enable_default_standards = false
  
  tags = {
    Name        = "${var.environment}-security-hub"
    Environment = var.environment
    Service     = "Security Hub"
  }
}
```

**What this does:** Enables Security Hub in your AWS account with custom standards

### Step 2: Enable Security Standards

```hcl
resource "aws_securityhub_standards_subscription" "cis" {
  count      = var.enable_cis_standard ? 1 : 0
  depends_on = [aws_securityhub_account.main]
  
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/cis-aws-foundations-benchmark/v/1.2.0"
  
  tags = {
    Name        = "${var.environment}-cis-standard"
    Environment = var.environment
    Standard    = "CIS"
  }
}
```

**What this does:** Enables the CIS AWS Foundations Benchmark security standard

### Step 3: Enable PCI DSS Standard

```hcl
resource "aws_securityhub_standards_subscription" "pci" {
  count      = var.enable_pci_standard ? 1 : 0
  depends_on = [aws_securityhub_account.main]
  
  standards_arn = "arn:aws:securityhub:${var.aws_region}::standards/pci-dss/v/3.2.1"
  
  tags = {
    Name        = "${var.environment}-pci-standard"
    Environment = var.environment
    Standard    = "PCI DSS"
  }
}
```

**What this does:** Enables the PCI DSS compliance standard for payment card security

### Step 4: Configure Finding Aggregation

```hcl
resource "aws_securityhub_finding_aggregator" "main" {
  depends_on = [aws_securityhub_account.main]
  
  linking_mode = "ALL_REGIONS"
  
  tags = {
    Name        = "${var.environment}-finding-aggregator"
    Environment = var.environment
    Service     = "Security Hub"
  }
}
```

**What this does:** Aggregates security findings from all AWS regions into one central location

---

## What Security Hub Monitors

### AWS Service Integration
- **GuardDuty** - Threat detection findings
- **IAM Access Analyzer** - Permission and access issues
- **AWS Config** - Configuration compliance violations
- **Macie** - Data privacy and protection issues
- **Inspector** - Vulnerability assessment findings

### Security Standards
- **CIS AWS Foundations Benchmark** - Security best practices
- **PCI DSS** - Payment card industry security standards
- **ISO 27001** - Information security management
- **SOC 2** - Service organization control standards

### Compliance Frameworks
- **GDPR** - Data protection and privacy
- **HIPAA** - Healthcare information security
- **SOX** - Financial reporting controls
- **NIST** - Cybersecurity framework

---

## Types of Security Findings

### High Severity
- **Critical vulnerabilities** that require immediate attention
- **Data breaches** or unauthorized access
- **Malware infections** or suspicious activity
- **Compliance violations** that could result in penalties

### Medium Severity
- **Security misconfigurations** that increase risk
- **Missing security controls** or monitoring
- **Access permission issues** that could be exploited
- **Outdated software** or missing patches

### Low Severity
- **Informational findings** for awareness
- **Best practice recommendations** for improvement
- **Minor configuration issues** with low risk
- **Documentation gaps** or missing procedures

---

## What the Module Provides (Outputs)

### Security Hub Information

```hcl
output "security_hub_arn" {
  description = "ARN of the Security Hub account"
  value       = aws_securityhub_account.main.arn
}

output "security_hub_id" {
  description = "ID of the Security Hub account"
  value       = aws_securityhub_account.main.id
}
```

**Used by:** Other modules that need to integrate with Security Hub

### Standards Information

```hcl
output "enabled_standards" {
  description = "List of enabled security standards"
  value       = concat(
    var.enable_cis_standard ? ["CIS"] : [],
    var.enable_pci_standard ? ["PCI DSS"] : []
  )
}
```

**Used by:** Compliance reporting and security monitoring

---

## Customizing Your Security Hub Setup

### Enable Additional Standards

```hcl
variable "enable_iso_standard" {
  description = "Enable ISO 27001 standard"
  type        = bool
  default     = true
}

variable "enable_soc_standard" {
  description = "Enable SOC 2 standard"
  type        = bool
  default     = false
}
```

### Configure Finding Aggregation

```hcl
# Aggregate findings from specific regions only
resource "aws_securityhub_finding_aggregator" "selective" {
  depends_on = [aws_securityhub_account.main]
  
  linking_mode = "SPECIFIED_REGIONS"
  specified_regions = ["us-east-1", "us-west-2", "eu-west-1"]
}
```

### Custom Security Controls

```hcl
# Create custom security controls
resource "aws_securityhub_control" "custom" {
  name        = "${var.environment}-custom-control"
  description = "Custom security control for environment"
  
  control_status = "ENABLED"
  
  tags = {
    Name        = "${var.environment}-custom-control"
    Environment = var.environment
    Type        = "Custom"
  }
}
```

---

## Common Questions

### "What's the difference between Security Hub and GuardDuty?"

- **Security Hub:** Centralizes and organizes security findings from multiple services
- **GuardDuty:** Continuously monitors for threats and generates security findings

### "How much does Security Hub cost?"

- **Security Hub:** $0.30 per finding per month
- **Security Standards:** $0.30 per finding per month
- **Finding Aggregator:** FREE
- **First 100 findings:** FREE per month

### "Which security standards should I enable?"

**Start with:**
- **CIS AWS Foundations Benchmark** - Essential security best practices
- **PCI DSS** - If you handle payment card data
- **ISO 27001** - For comprehensive information security management

### "How quickly does Security Hub detect issues?"

- **Real-time:** Findings appear as soon as they're generated by source services
- **Continuous:** 24/7 monitoring and aggregation
- **Immediate:** Alerts and notifications sent via SNS

---

## Troubleshooting

### Error: "Security Hub already enabled"
**Solution:** Security Hub can only be enabled once per account. Use data source instead of resource.

### Error: "Standard not available in region"
**Solution:** Some security standards may not be available in all regions. Check availability.

### Error: "Insufficient permissions"
**Solution:** Ensure your AWS user has Security Hub and IAM permissions

### Error: "Finding aggregator failed"
**Solution:** Check that Security Hub is fully enabled before configuring aggregation

---

## Next Steps

1. **Look at the main.tf** to see how Security Hub is configured
2. **Modify variables** to customize your security standards
3. **Deploy the module** to enable Security Hub monitoring
4. **Check the AWS Console** to see Security Hub in action
5. **Set up additional integrations** with GuardDuty and other services

---

## Security Best Practices

### Do's
- Enable relevant security standards for your industry
- Regularly review and act on security findings
- Set up automated response workflows
- Monitor compliance status continuously
- Integrate with existing security tools

### Don'ts
- Don't ignore high-severity findings
- Don't enable standards you don't need
- Don't skip regular security reviews
- Don't forget to monitor costs
- Don't ignore compliance requirements

---

## Cost Considerations

### Security Hub Costs
- **Security Hub:** $0.30 per finding per month
- **Security Standards:** $0.30 per finding per month
- **Finding Aggregator:** FREE
- **First 100 findings:** FREE per month

### Cost Optimization Tips
- Monitor finding volume and costs
- Disable unnecessary security standards
- Use finding filters to reduce noise
- Set up cost alerts and budgets
- Review and archive old findings

---

## Integration with Other Services

### GuardDuty
- Security Hub automatically receives GuardDuty findings
- Centralized view of threat detection alerts
- Automated response workflows

### AWS Config
- Configuration compliance violations appear in Security Hub
- Track resource configuration changes
- Ensure compliance with security policies

### CloudWatch
- Monitor Security Hub metrics and performance
- Set up alarms for unusual activity
- Track finding trends over time

### Lambda Functions
- Automated response to security findings
- Custom notification workflows
- Integration with external security tools

---

<div align="center">
  <p><em>Your security command center is now active!</em></p>
</div>
