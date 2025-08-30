# Live Demo Script - P2W12 Quantum Shield Cyber Range
## 15-20 Minute Command Line Presentation

**Audience**: Instructors, stakeholders, team members  
**Duration**: 15-20 minutes  
**Format**: Live command line demonstration  
**Goal**: Showcase complete lab capabilities and professional implementation  

---

## 🎯 **Demo Overview**

### **What We'll Demonstrate:**
1. **Infrastructure Deployment** (5 min)
2. **Security Architecture** (5 min)  
3. **Monitoring & Threat Detection** (5 min)
4. **Team Collaboration** (3 min)
5. **Q&A & Wrap-up** (2 min)

### **Key Messages:**
- **Enterprise-grade security** architecture
- **Professional implementation** using Infrastructure as Code
- **Real-time monitoring** and threat detection
- **Team collaboration** capabilities
- **Cost optimization** within Free Tier

---

## 🚀 **Pre-Demo Setup (5 minutes)**

### **1. Deploy Lab Environment**
```bash
# Navigate to terraform directory
cd p2w12-quantum-shield/terraform

# Deploy the complete lab
terraform apply -var="key_name=my-lab-key-new" -auto-approve

# Verify deployment
terraform output
```

### **2. Create Instructor Access**
```bash
# Return to main directory
cd ..

# Create access for demo
.\setup-instructor-access.ps1 -InstructorName "Live-Demo" -AccessHours 480
```

### **3. Test Access**
```bash
# Verify console access works
aws ec2 describe-instances --output table
aws ec2 describe-vpcs --output table
```

---

## 🎬 **Live Demo Execution (15-20 minutes)**

### **Phase 1: Infrastructure Overview (5 minutes)**

#### **Opening Statement:**
*"Welcome to the P2W12 Quantum Shield Cyber Range. Today I'll demonstrate our enterprise-grade cybersecurity training environment built entirely with Infrastructure as Code."*

#### **Commands to Execute:**
```bash
# Show project structure
echo "=== P2W12 QUANTUM SHIELD CYBER RANGE ==="
echo "Team: Shannon Kelly, Fausto Rosado, Zeinab Ali, Latrisha Dodson, Javier Acosta"
echo ""

# Display running infrastructure
echo "=== INFRASTRUCTURE OVERVIEW ==="
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name,InstanceType,Tags[?Key==`Name`].Value|[0]]' --output table

echo ""
echo "=== NETWORK ARCHITECTURE ==="
aws ec2 describe-vpcs --query 'Vpcs[*].[VpcId,CidrBlock,Tags[?Key==`Name`].Value|[0]]' --output table

echo ""
echo "=== SECURITY GROUPS ==="
aws ec2 describe-security-groups --query 'SecurityGroups[*].[GroupName,Description,VpcId]' --output table
```

#### **Talking Points:**
- **Multi-tier VPC design** with public/private subnets
- **Security group microsegmentation** for network isolation
- **Professional tagging** for cost tracking and management
- **Infrastructure as Code** using Terraform

---

### **Phase 2: Security Architecture (5 minutes)**

#### **Transition Statement:**
*"Now let me show you our enterprise-grade security controls and monitoring systems."*

#### **Commands to Execute:**
```bash
echo "=== SECURITY CONTROLS ==="
echo "Network ACLs:"
aws ec2 describe-network-acls --query 'NetworkAcls[*].[NetworkAclId,VpcId,Associations[*].SubnetId]' --output table

echo ""
echo "=== MONITORING & LOGGING ==="
echo "CloudWatch Log Groups:"
aws logs describe-log-groups --query 'logGroups[*].[logGroupName,storedBytes]' --output table

echo ""
echo "=== SECURITY METRICS ==="
echo "EC2 Performance Metrics:"
aws cloudwatch list-metrics --namespace AWS/EC2 --metric-name CPUUtilization --query 'Metrics[*].[MetricName,Dimensions[*].Value]' --output table
```

#### **Talking Points:**
- **Defense in depth** with multiple security layers
- **Real-time monitoring** using CloudWatch
- **Comprehensive logging** for audit compliance
- **Security best practices** implementation

---

### **Phase 3: Threat Detection & Monitoring (5 minutes)**

#### **Transition Statement:**
*"Let me demonstrate our advanced threat detection and real-time monitoring capabilities."*

#### **Commands to Execute:**
```bash
echo "=== THREAT DETECTION SYSTEM ==="
echo "Security Monitoring Status:"
aws ec2 describe-instance-status --query 'InstanceStatuses[*].[InstanceId,InstanceState.Name,SystemStatus.Status,InstanceStatus.Status]' --output table

echo ""
echo "=== LOG ANALYSIS ==="
echo "Recent Security Events:"
aws logs filter-log-events --log-group-name "/aws/ec2/security/ssh-access" --start-time $(date -d '1 hour ago' +%s)000 --query 'events[*].[timestamp,message]' --output table

echo ""
echo "=== PERFORMANCE MONITORING ==="
echo "System Resource Usage:"
aws cloudwatch get-metric-statistics --namespace AWS/EC2 --metric-name CPUUtilization --dimensions Name=InstanceId,Value=$(aws ec2 describe-instances --query 'Reservations[*].Instances[0].InstanceId' --output text) --start-time $(date -d '1 hour ago' -u +%Y-%m-%dT%H:%M:%S) --end-time $(date -u +%Y-%m-%dT%H:%M:%S) --period 300 --statistics Average --output table
```

#### **Talking Points:**
- **Real-time threat detection** using custom monitoring
- **Automated security alerts** and response
- **Performance monitoring** and capacity planning
- **Incident response** capabilities

---

### **Phase 4: Team Collaboration (3 minutes)**

#### **Transition Statement:**
*"Now let me show you how team members can collaborate securely using our instructor access system."*

#### **Commands to Execute:**
```bash
echo "=== TEAM COLLABORATION ==="
echo "Instructor Access Status:"
aws iam list-users --query 'Users[*].[UserName,CreateDate]' --output table

echo ""
echo "=== CROSS-ACCOUNT ACCESS ==="
echo "IAM Role for Team Access:"
aws iam list-roles --query 'Roles[?contains(RoleName, `instructor`)].{RoleName:RoleName,CreateDate:CreateDate}' --output table

echo ""
echo "=== ACCESS AUDIT ==="
echo "Recent Access Attempts:"
aws logs filter-log-events --log-group-name "/aws/iam/access" --start-time $(date -d '1 hour ago' +%s)000 --query 'events[*].[timestamp,message]' --output table
```

#### **Talking Points:**
- **Secure team access** without credential sharing
- **Cross-account collaboration** capabilities
- **Audit logging** for compliance
- **Professional presentation** for stakeholders

---

### **Phase 5: Q&A & Wrap-up (2 minutes)**

#### **Closing Statement:**
*"This concludes our demonstration of the P2W12 Quantum Shield Cyber Range. We've shown enterprise-grade security architecture, real-time monitoring, and professional team collaboration - all built within AWS Free Tier limits."*

#### **Key Takeaways to Emphasize:**
- **Professional implementation** using industry best practices
- **Enterprise-grade security** controls and monitoring
- **Cost optimization** without compromising capabilities
- **Team collaboration** for effective learning
- **Real-world applicability** for cybersecurity training

---

## 🧹 **Post-Demo Cleanup (5 minutes)**

### **1. Revoke Instructor Access**
```bash
# Get the generated username from the setup script output
aws iam delete-user --user-name [GENERATED_USERNAME]
```

### **2. Destroy Lab Environment**
```bash
cd terraform
terraform destroy -var="key_name=my-lab-key-new" -auto-approve
```

### **3. Verify Cleanup**
```bash
# Check that no resources remain
aws ec2 describe-instances --query 'Reservations[*].Instances[*].[InstanceId,State.Name]' --output table
aws ec2 describe-vpcs --query 'Vpcs[*].[VpcId,State]' --output table
```

---

## 🎯 **Demo Success Tips**

### **Preparation:**
- **Practice commands** before the demo
- **Prepare talking points** for each phase
- **Test all commands** in advance
- **Have backup plans** for any failures

### **During Demo:**
- **Speak clearly** and explain each command
- **Show confidence** in your implementation
- **Engage audience** with questions
- **Keep to time** limits for each phase

### **Professional Presentation:**
- **Dress appropriately** for your audience
- **Use professional language** and terminology
- **Highlight team achievements** and collaboration
- **Emphasize security** and compliance features

---

## 🎉 **Demo Outcomes**

### **What You'll Demonstrate:**
- **Technical expertise** in cloud security
- **Professional implementation** standards
- **Team collaboration** capabilities
- **Enterprise-grade** security architecture
- **Cost-effective** solution delivery

### **Audience Impressions:**
- **Professional credibility** with stakeholders
- **Technical competence** in cybersecurity
- **Team leadership** and collaboration skills
- **Industry knowledge** and best practices
- **Project management** and delivery capabilities

---

**Ready for Live Demos**: This script provides a complete 15-20 minute demonstration of your P2W12 cyber range lab, showcasing professional implementation and enterprise-grade security capabilities.

