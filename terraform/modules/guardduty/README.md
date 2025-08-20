# GuardDuty Module - Threat Detection

## What is GuardDuty?

**GuardDuty** is AWS's **continuous threat detection service**. Think of it as a **security guard** that monitors your AWS accounts, workloads, and data 24/7 for malicious activity and unauthorized behavior.

### Real-World Analogy

- **GuardDuty** = A security guard monitoring your building
- **Data Sources** = Security cameras, motion sensors, access logs
- **Findings** = Security alerts when suspicious activity is detected
- **SNS Notifications** = The guard calling you when something happens
- **IAM Role** = The guard's badge that gives them permission to monitor

---

## What This Module Creates

This module sets up **comprehensive threat detection** for your AWS environment:

- **GuardDuty Detector** - The main threat detection service
- **Data Sources** - What GuardDuty monitors (CloudTrail, VPC Flow Logs, DNS logs)
- **SNS Topic** - Sends security alerts when threats are detected
- **IAM Role** - Permissions for GuardDuty to access your resources
- **Integration** - Connects with Security Hub and other security services

---

## Module Structure

```
guardduty/
├── main.tf      # Creates GuardDuty detector, threat intel sets, and SNS integration
├── variables.tf # What the module needs as input (environment, s3_bucket_name)
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

**What this means:** All GuardDuty resources get tagged with your environment (dev, staging, prod)

### Region Configuration

```hcl
variable "aws_region" {
  description = "AWS region where GuardDuty will be enabled"
  type        = string
  default     = "us-east-1"
}
```

**What this means:** GuardDuty will monitor resources in this specific AWS region

### S3 Bucket Configuration

```hcl
variable "s3_bucket_name" {
  description = "S3 bucket name for threat intelligence data"
  type        = string
}
```

**What this means:** GuardDuty will use this S3 bucket to store and retrieve threat intelligence data

---

## How It Works (Step by Step)

### Step 1: Create GuardDuty Detector

```hcl
resource "aws_guardduty_detector" "main" {
  enable = true
  
  tags = {
    Name        = "${var.environment}-guardduty-detector"
    Environment = var.environment
    Service     = "GuardDuty"
  }
}
```

**What this does:** Creates the main GuardDuty service that monitors your AWS environment

### Step 2: Enable Data Sources

```hcl
resource "aws_guardduty_member" "main" {
  account_id  = data.aws_caller_identity.current.account_id
  detector_id = aws_guardduty_detector.main.id
  email       = "security@yourcompany.com"
  
  tags = {
    Name        = "${var.environment}-guardduty-member"
    Environment = var.environment
  }
}
```

**What this does:** Enables GuardDuty to monitor your AWS account and resources

### Step 3: Create SNS Topic for Alerts

```hcl
resource "aws_sns_topic" "guardduty_alerts" {
  name = var.sns_topic_name
  
  tags = {
    Name        = "${var.environment}-guardduty-alerts"
    Environment = var.environment
    Service     = "GuardDuty"
  }
}
```

**What this does:** Creates a topic where security alerts will be published

### Step 4: Subscribe to Alerts

```hcl
resource "aws_sns_topic_subscription" "guardduty_email" {
  topic_arn = aws_sns_topic.guardduty_alerts.arn
  protocol  = "email"
  endpoint  = "security@yourcompany.com"
}
```

**What this does:** Subscribes your email to receive security alerts

---

## What GuardDuty Monitors

### CloudTrail Logs
- **API calls** made to your AWS services
- **User activity** and authentication events
- **Resource changes** and configuration modifications
- **Suspicious patterns** in API usage

### VPC Flow Logs
- **Network traffic** between your resources
- **Unusual connections** to suspicious IP addresses
- **Data exfiltration** attempts
- **Port scanning** and reconnaissance activity

### DNS Logs
- **DNS queries** made by your resources
- **Malicious domains** and command & control servers
- **Data exfiltration** through DNS tunneling
- **Suspicious domain** resolution patterns

### EKS Audit Logs
- **Kubernetes API calls** and cluster activity
- **Container runtime** security events
- **Pod and service** configuration changes
- **Suspicious container** behavior

---

## Types of Threats GuardDuty Detects

### Credential Compromise
- **Unusual API calls** from new locations
- **Failed authentication** attempts
- **Credential harvesting** activities
- **Privilege escalation** attempts

### Instance Compromise
- **Malware detection** on EC2 instances
- **Suspicious network** connections
- **Unauthorized access** attempts
- **Data exfiltration** activities

### Data Exfiltration
- **Unusual data transfer** patterns
- **Suspicious S3 bucket** access
- **Large data downloads** to external IPs
- **Unauthorized data** exports

### Resource Hijacking
- **Cryptocurrency mining** on your resources
- **Unauthorized resource** creation
- **Suspicious IAM** changes
- **Resource abuse** patterns

---

## What the Module Provides (Outputs)

### Detector Information

```hcl
output "detector_id" {
  description = "ID of the GuardDuty detector"
  value       = aws_guardduty_detector.main.id
}

output "detector_arn" {
  description = "ARN of the GuardDuty detector"
  value       = aws_guardduty_detector.main.arn
}
```

**Used by:** Other modules that need to integrate with GuardDuty

### SNS Topic Information

```hcl
output "sns_topic_arn" {
  description = "ARN of the SNS topic for security alerts"
  value       = aws_sns_topic.guardduty_alerts.arn
}

output "sns_topic_name" {
  description = "Name of the SNS topic for security alerts"
  value       = aws_sns_topic.guardduty_alerts.name
}
```

**Used by:** Security Hub and other services that need to send alerts

---

## Customizing Your GuardDuty Setup

### Change Notification Email

```hcl
variable "sns_topic_name" {
  description = "Name for the SNS topic that sends security alerts"
  type        = string
  default     = "my-security-alerts"  # Change from default
}
```

### Enable Additional Data Sources

```hcl
# Enable EKS audit logs monitoring
resource "aws_guardduty_detector_feature" "eks_audit_logs" {
  detector_id = aws_guardduty_detector.main.id
  name        = "EKS_AUDIT_LOGS"
  status      = "ENABLED"
}
```

### Customize Alert Thresholds

```hcl
# Set custom finding severity thresholds
resource "aws_guardduty_filter" "high_severity" {
  detector_id = aws_guardduty_detector.main.id
  name        = "high-severity-findings"
  
  finding_criteria {
    criterion {
      field = "severity"
      equals = ["HIGH"]
    }
  }
}
```

---

## Common Questions

### "How much does GuardDuty cost?"

- **CloudTrail Events:** $4.00 per million events
- **VPC Flow Logs:** $0.50 per million events
- **DNS Logs:** $0.50 per million queries
- **EKS Audit Logs:** $0.50 per million events

### "How quickly does GuardDuty detect threats?"

- **Real-time detection** for most threats
- **Within minutes** for credential compromise
- **Within hours** for complex attack patterns
- **Continuous monitoring** 24/7

### "Can I customize what GuardDuty monitors?"

**Yes!** You can:
- **Enable/disable** specific data sources
- **Set custom thresholds** for findings
- **Create filters** to focus on specific threats
- **Integrate** with your existing security tools

### "What happens when a threat is detected?"

1. **GuardDuty creates a finding** with threat details
2. **SNS notification** is sent to your topic
3. **Security Hub** receives the finding
4. **You can set up automated responses** via Lambda functions

---

## Troubleshooting

### Error: "GuardDuty already enabled in region"
**Solution:** GuardDuty can only have one detector per region. Use the existing one.

### Error: "SNS topic already exists"
**Solution:** Use a unique topic name or reference an existing topic

### Error: "Insufficient permissions"
**Solution:** Ensure your AWS user has GuardDuty and SNS permissions

### Error: "Email subscription failed"
**Solution:** Check the email address and ensure it's valid

---

## Next Steps

1. **Look at the main.tf** to see how GuardDuty is configured
2. **Modify variables** to customize your threat detection setup
3. **Deploy the module** to enable GuardDuty monitoring
4. **Check the AWS Console** to see GuardDuty in action
5. **Set up additional integrations** with Security Hub and Lambda

---

## Security Best Practices

### Do's
- Enable all relevant data sources
- Set up multiple notification channels
- Integrate with Security Hub
- Review findings regularly
- Set up automated response workflows

### Don'ts
- Don't ignore low-severity findings
- Don't disable GuardDuty in production
- Don't forget to monitor costs
- Don't skip finding investigation

---

## Cost Considerations

### GuardDuty Costs
- **CloudTrail Events:** $4.00 per million events
- **VPC Flow Logs:** $0.50 per million events
- **DNS Logs:** $0.50 per million queries
- **EKS Audit Logs:** $0.50 per million events

### SNS Costs
- **Topic creation:** FREE
- **Message delivery:** $0.50 per million messages
- **Email delivery:** FREE

### Cost Optimization Tips
- Monitor data source usage
- Set up cost alerts
- Use filters to reduce noise
- Review and adjust data sources

---

## Integration with Other Services

### Security Hub
- GuardDuty findings automatically appear in Security Hub
- Centralized view of all security issues
- Automated response workflows

### CloudWatch
- Monitor GuardDuty metrics and performance
- Set up alarms for unusual activity
- Track finding trends over time

### Lambda Functions
- Automated response to security findings
- Custom notification workflows
- Integration with external security tools

### SNS
- Real-time security alert delivery
- Multiple notification channels
- Integration with chat platforms

---

<div align="center">
  <p><em>Your threat detection is now active!</em></p>
</div>
