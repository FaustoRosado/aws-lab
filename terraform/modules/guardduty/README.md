# 🛡️ GuardDuty Module - Threat Detection

## 📚 **What is GuardDuty?**

**GuardDuty** is AWS's **continuous security monitoring service** that automatically detects threats in your AWS environment. Think of it as having a **24/7 security guard** that watches for suspicious activity and alerts you when something looks wrong.

### **🏠 Real-World Analogy**

- **🛡️ GuardDuty** = A security guard monitoring your building 24/7
- **🔍 Continuous Monitoring** = The guard never sleeps, always watching
- **🚨 Threat Detection** = Alerts you when something suspicious happens
- **📊 Security Findings** = Detailed reports about what the guard found
- **🔗 Integration** = Works with other security tools to respond to threats

---

## 🎯 **What This Module Creates**

This module sets up **GuardDuty threat detection** for your security lab:

- **🛡️ GuardDuty Detector** - The main threat detection service
- **🔍 Data Sources** - What GuardDuty monitors (CloudTrail, VPC Flow Logs, DNS logs)
- **📧 SNS Topic** - Where GuardDuty sends security alerts
- **🔐 IAM Role** - Permissions for GuardDuty to access your resources
- **🏷️ Tags** - Organization and cost tracking

---

## 🏗️ **Module Structure**

```
guardduty/
├── main.tf      # 🎯 Creates GuardDuty detector and resources
├── variables.tf # 📝 What the module needs as input
├── outputs.tf   # 📤 What the module provides to others
└── README.md    # 📖 This file!
```

---

## 📝 **Input Variables Explained**

### **🏷️ Environment and Naming**

```hcl
variable "environment" {
  description = "Environment name for tagging and naming"
  type        = string
  default     = "lab"
}
```

**What this means:** All GuardDuty resources get tagged with your environment (dev, staging, prod)

### **🌍 AWS Region**

```hcl
variable "region" {
  description = "AWS region where GuardDuty will be enabled"
  type        = string
  default     = "us-east-1"
}
```

**What this means:** GuardDuty will monitor resources in this specific AWS region

### **📧 SNS Configuration**

```hcl
variable "sns_topic_arn" {
  description = "ARN of SNS topic for GuardDuty findings"
  type        = string
}
```

**What this means:** GuardDuty will send security alerts to this SNS topic (created by another module)

---

## 🔍 **How It Works (Step by Step)**

### **Step 1: Create GuardDuty Detector**

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

**What this does:** Creates the main GuardDuty service that will monitor your AWS environment

### **Step 2: Configure Data Sources**

```hcl
resource "aws_guardduty_detector_feature" "cloudtrail" {
  detector_id = aws_guardduty_detector.main.id
  name        = "CLOUD_TRAIL"
  status      = "ENABLED"
}

resource "aws_guardduty_detector_feature" "vpc_flow_logs" {
  detector_id = aws_guardduty_detector.main.id
  name        = "VPC_FLOW_LOGS"
  status      = "ENABLED"
}

resource "aws_guardduty_detector_feature" "dns_logs" {
  detector_id = aws_guardduty_detector.main.id
  name        = "DNS_LOGS"
  status      = "ENABLED"
}
```

**What this does:** Enables GuardDuty to monitor:
- **CloudTrail logs** - API calls and account activity
- **VPC Flow Logs** - Network traffic patterns
- **DNS logs** - Domain name resolution requests

### **Step 3: Create IAM Role for GuardDuty**

```hcl
resource "aws_iam_role" "guardduty_service_role" {
  name = "${var.environment}-guardduty-service-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "guardduty.amazonaws.com"
        }
      }
    ]
  })
  
  tags = {
    Name        = "${var.environment}-guardduty-service-role"
    Environment = var.environment
    Service     = "GuardDuty"
  }
}
```

**What this does:** Creates a role that gives GuardDuty permission to:
- **Read CloudTrail logs** for API activity monitoring
- **Access VPC Flow Logs** for network traffic analysis
- **Read DNS logs** for domain resolution monitoring

### **Step 4: Attach GuardDuty Policy**

```hcl
resource "aws_iam_role_policy_attachment" "guardduty_policy" {
  role       = aws_iam_role.guardduty_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonGuardDutyServiceRolePolicy"
}
```

**What this does:** Gives the role the standard GuardDuty permissions needed to monitor your environment

---

## 🔍 **What GuardDuty Monitors**

### **📊 CloudTrail Monitoring**

**What it watches:**
- **API calls** to AWS services
- **Account changes** (new users, policy modifications)
- **Resource creation/deletion** (instances, buckets, databases)
- **Permission changes** (role assignments, policy updates)

**Threats it detects:**
- **Unauthorized access** attempts
- **Privilege escalation** (users getting more permissions)
- **Resource manipulation** (deleting backups, changing security settings)

### **🌐 VPC Flow Logs Monitoring**

**What it watches:**
- **Network traffic** between your resources
- **Connection patterns** (who talks to whom)
- **Data transfer** volumes and directions
- **Port usage** (which services are communicating)

**Threats it detects:**
- **Data exfiltration** (large data transfers out)
- **Command & Control** (C2) communication
- **Port scanning** and reconnaissance
- **Unusual network patterns**

### **🔍 DNS Logs Monitoring**

**What it watches:**
- **Domain name requests** from your resources
- **DNS resolution** patterns
- **Suspicious domains** (known malware, phishing sites)
- **DNS tunneling** attempts

**Threats it detects:**
- **Malware communication** to known bad domains
- **Phishing attempts** using fake domains
- **Data exfiltration** through DNS
- **Botnet communication**

---

## 🚨 **Types of Threats GuardDuty Detects**

### **🔴 High Severity Threats**

- **🚨 Unauthorized Access** - Someone accessing resources they shouldn't
- **🚨 Data Exfiltration** - Large amounts of data being sent out
- **🚨 Malware Communication** - Instances talking to known bad domains
- **🚨 Privilege Escalation** - Users getting more permissions than they should

### **🟡 Medium Severity Threats**

- **⚠️ Suspicious API Calls** - Unusual patterns of AWS service usage
- **⚠️ Network Scanning** - Port scanning or reconnaissance activity
- **⚠️ Unusual Login Patterns** - Logins from unexpected locations or times
- **⚠️ Resource Manipulation** - Changes to security-critical resources

### **🟢 Low Severity Threats**

- **ℹ️ Policy Changes** - Modifications to IAM policies or security groups
- **ℹ️ New Resource Creation** - Instances, buckets, or databases being created
- **ℹ️ Configuration Changes** - Modifications to security settings
- **ℹ️ Access Pattern Changes** - Users accessing resources they don't normally use

---

## 📤 **What the Module Provides (Outputs)**

### **🆔 GuardDuty Detector ID**

```hcl
output "detector_id" {
  description = "ID of the GuardDuty detector"
  value       = aws_guardduty_detector.main.id
}
```

**Used by:** Other modules or scripts that need to reference your GuardDuty detector

### **🔐 IAM Role Information**

```hcl
output "service_role_arn" {
  description = "ARN of the GuardDuty service role"
  value       = aws_iam_role.guardduty_service_role.arn
}

output "service_role_name" {
  description = "Name of the GuardDuty service role"
  value       = aws_iam_role.guardduty_service_role.name
}
```

**Used by:** Other modules that need to reference the GuardDuty service role

### **🏷️ Resource Tags**

```hcl
output "tags" {
  description = "Tags applied to GuardDuty resources"
  value = {
    Environment = var.environment
    Service     = "GuardDuty"
  }
}
```

**Used by:** Cost tracking and resource organization

---

## 🎨 **Customizing Your GuardDuty Setup**

### **🔍 Enable/Disable Data Sources**

```hcl
# Disable DNS monitoring if you don't need it
resource "aws_guardduty_detector_feature" "dns_logs" {
  detector_id = aws_guardduty_detector.main.id
  name        = "DNS_LOGS"
  status      = "DISABLED"  # Change from ENABLED to DISABLED
}
```

### **🌍 Monitor Multiple Regions**

```hcl
# Create detectors in multiple regions
variable "regions" {
  description = "List of AWS regions to monitor"
  type        = list(string)
  default     = ["us-east-1", "us-west-2", "eu-west-1"]
}

# Then create detectors for each region
resource "aws_guardduty_detector" "multi_region" {
  count  = length(var.regions)
  region = var.regions[count.index]
  enable = true
  
  tags = {
    Name        = "${var.environment}-guardduty-${var.regions[count.index]}"
    Environment = var.environment
    Region      = var.regions[count.index]
  }
}
```

### **📧 Custom SNS Topics**

```hcl
# Create multiple SNS topics for different severity levels
variable "high_severity_topic_arn" {
  description = "SNS topic for high severity findings"
  type        = string
}

variable "medium_severity_topic_arn" {
  description = "SNS topic for medium severity findings"
  type        = string
}
```

---

## 🚨 **Common Questions**

### **❓ "How much does GuardDuty cost?"**

- **💰 Free Tier:** First 30 days are free
- **📊 Data Processing:** $4.00 per million CloudTrail events
- **🌐 VPC Flow Logs:** $0.50 per VPC Flow Log
- **🔍 DNS Logs:** $0.50 per million DNS queries
- **💡 Tip:** Start with free tier to understand costs

### **❓ "How long does it take to start detecting threats?"**

- **⚡ Immediate:** Starts monitoring as soon as enabled
- **📊 Historical:** Can analyze up to 90 days of historical data
- **🔍 Baseline:** Takes 24-48 hours to establish normal behavior patterns
- **🚨 Alerts:** May receive alerts immediately for obvious threats

### **❓ "What if I get too many false positives?"**

- **🔧 Suppression Rules:** Create rules to ignore known false positives
- **📊 Severity Adjustment:** Lower severity for less critical findings
- **🔄 Fine-tuning:** Adjust detection sensitivity over time
- **📝 Documentation:** Document why certain alerts are false positives

### **❓ "Can GuardDuty detect all threats?"**

**No, but it's very comprehensive:**
- **✅ Detects:** Most common attack patterns and known threats
- **⚠️ Limitations:** May miss sophisticated, custom attacks
- **🔄 Continuous:** AWS constantly updates detection capabilities
- **🛡️ Defense in Depth:** Use with other security tools for best protection

---

## 🔧 **Troubleshooting**

### **🚨 Error: "GuardDuty already exists in this region"**
**Solution:** GuardDuty can only have one detector per region. Use `data` source instead of `resource`.

### **🚨 Error: "Insufficient permissions"**
**Solution:** Ensure your AWS user/role has GuardDuty permissions:
- `guardduty:CreateDetector`
- `guardduty:CreateDetectorFeature`
- `iam:CreateRole`
- `iam:AttachRolePolicy`

### **🚨 Error: "SNS topic not found"**
**Solution:** Make sure the SNS topic exists and is in the same region as GuardDuty.

### **🚨 Error: "VPC Flow Logs not enabled"**
**Solution:** Enable VPC Flow Logs in your VPC before enabling this feature in GuardDuty.

---

## 🎯 **Next Steps**

1. **🔍 Look at the main.tf** to see how GuardDuty is configured
2. **📝 Modify variables** to customize your setup
3. **🚀 Deploy the module** to enable threat detection
4. **📊 Check the AWS Console** to see GuardDuty in action
5. **📧 Set up SNS notifications** to receive security alerts

---

## 🔐 **Security Best Practices**

### **✅ Do's**
- **🔍 Enable all data sources** for comprehensive monitoring
- **📧 Set up SNS notifications** to receive immediate alerts
- **🏷️ Use consistent tagging** for cost tracking and organization
- **📊 Review findings regularly** to understand your security posture

### **❌ Don'ts**
- **🚫 Don't ignore low severity findings** - they can indicate larger issues
- **🚫 Don't disable monitoring** without understanding the risks
- **🚫 Don't share GuardDuty findings** publicly (may contain sensitive information)
- **🚫 Don't forget to monitor costs** - GuardDuty can generate significant charges

---

## 💰 **Cost Optimization**

### **💰 Cost Factors**
- **CloudTrail Events:** $4.00 per million events
- **VPC Flow Logs:** $0.50 per VPC Flow Log
- **DNS Logs:** $0.50 per million DNS queries
- **Data Transfer:** Standard AWS data transfer costs

### **💡 Cost Saving Tips**
- **📊 Monitor Usage:** Use AWS Cost Explorer to track GuardDuty costs
- **🔍 Selective Monitoring:** Only enable data sources you need
- **🏷️ Resource Tagging:** Tag resources to track costs by project
- **📅 Regular Review:** Review and clean up unnecessary monitoring

---

## 🔗 **Integration with Other Services**

### **🛡️ Security Hub**
- **Centralized View:** All GuardDuty findings appear in Security Hub
- **Automated Response:** Trigger actions based on GuardDuty findings
- **Compliance Tracking:** Use findings for compliance reporting

### **📊 CloudWatch**
- **Metrics:** Monitor GuardDuty activity and costs
- **Dashboards:** Create custom security dashboards
- **Alarms:** Set up alerts for unusual GuardDuty activity

### **🔐 IAM Access Analyzer**
- **Permission Review:** Use GuardDuty findings to review IAM permissions
- **Access Optimization:** Remove unnecessary permissions based on findings
- **Security Hardening:** Improve security posture based on detected threats

---

<div align="center">
  <p><em>🛡️ Your threat detection is now active! 🚨</em></p>
</div>
