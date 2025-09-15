# Blue Team Demo Instructions

## Blue Team Detection Flow (3-4 minutes)

### 1. CLI Detection Checks
```bash
# Check GuardDuty status
DET="12cc3e71aee20682764236ade5fbdb3d"
echo "GuardDuty Detector: $DET"
aws guardduty list-findings --detector-id "$DET" --query 'length(FindingIds)' --output text
```

**PAUSE: "GuardDuty has detected X findings"**

### 2. Security Hub Overview
```bash
# Check Security Hub findings
aws securityhub get-findings --max-items 5 --query 'Findings[].{Title:Title,Severity:Severity.Label}' --output table
```

**PAUSE: "Security Hub shows compliance and security findings"**

### 3. Instance Monitoring
```bash
# Check running instances
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query 'Reservations[].Instances[].[Tags[?Key==`Name`].Value|[0],State.Name,PublicIpAddress,PrivateIpAddress]' --output table
```

**PAUSE: "These are our lab instances - web server and database"**

## Console Tour Checklist (60-90 seconds)

### EC2 Dashboard
- **PAUSE**: "Students, refresh your console and go to EC2"
- Show running instances with names from Terraform tags
- Point out public vs private IP addresses

### VPC Dashboard  
- **PAUSE**: "Go to VPC in your console"
- Show the lab VPC and subnets
- Explain public vs private subnet routing

### GuardDuty Dashboard
- **PAUSE**: "Navigate to GuardDuty"
- Show detector is enabled
- Show any findings present

### Security Hub Dashboard
- **PAUSE**: "Go to Security Hub"
- Show enabled standards (CIS + AWS Foundational)
- Show any compliance findings

## Key Teaching Points
- Multiple layers of detection
- Real-time monitoring capabilities
- Centralized security view
- Compliance posture assessment
