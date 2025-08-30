# Instructor Access System - P2W12 Quantum Shield Lab
## Quick Setup for Live Demos & Team Collaboration

**Purpose**: Provide secure, temporary AWS Console access for instructors and team members  
**Duration**: 20 days (extended access for team collaboration)  
**Access**: Read-only AWS Console + CLI access  
**Security**: Enterprise-grade IAM roles with audit logging  

---

## 🚀 **Quick Start (Live Demo)**

### **1. Deploy Instructor Access**
```powershell
# From p2w12-quantum-shield directory
.\setup-instructor-access.ps1 -InstructorName "Team-Member-Name" -AccessHours 480
```

### **2. Share Access Credentials**
- **Console URL**: https://console.aws.amazon.com/
- **Username**: Generated automatically
- **Password**: Generated automatically
- **Expires**: 20 days from creation

### **3. Team Member Access**
```bash
# Using AWS CLI with generated credentials
aws configure
# Enter the access key, secret key, and region

# Test access
aws ec2 describe-instances
aws ec2 describe-vpcs
```

---

## 🎯 **What Team Members Can Access**

### **✅ Console Access (Read-Only)**
- **EC2 Dashboard**: View running instances and configurations
- **VPC Dashboard**: Explore network architecture and security groups
- **CloudWatch**: Monitor metrics, logs, and security events
- **IAM**: Verify access permissions and roles

### **✅ CLI Access (Read-Only)**
- **Resource Discovery**: List all lab resources
- **Status Monitoring**: Check instance health and performance
- **Security Review**: Examine security group configurations
- **Log Analysis**: Access CloudWatch logs and metrics

### **❌ Restricted Actions**
- No resource creation/modification
- No SSH access to instances
- No credential access
- No administrative functions

---

## 🔧 **Live Demo Commands**

### **Pre-Demo Setup**
```bash
# 1. Deploy lab environment
cd terraform
terraform apply -var="key_name=my-lab-key-new" -auto-approve

# 2. Create instructor access
cd ..
.\setup-instructor-access.ps1 -InstructorName "Live-Demo" -AccessHours 480
```

### **During Demo (15-20 minutes)**
```bash
# Show infrastructure (2 min)
aws ec2 describe-instances --output table
aws ec2 describe-vpcs --output table

# Demonstrate security (3 min)
aws ec2 describe-security-groups --output table
aws ec2 describe-network-acls --output table

# Show monitoring (2 min)
aws cloudwatch list-metrics --namespace AWS/EC2
aws logs describe-log-groups

# Team collaboration (3 min)
# Share credentials with team members
# Show cross-account access capabilities

# Q&A and wrap-up (2 min)
```

### **Post-Demo Cleanup**
```bash
# Revoke instructor access
aws iam delete-user --user-name [GENERATED_USERNAME]

# Destroy lab environment
cd terraform
terraform destroy -var="key_name=my-lab-key-new" -auto-approve
```

---

## 👥 **Team Collaboration Features**

### **Multi-User Access**
- **Individual IAM users** for each team member
- **Shared IAM role** for cross-account access
- **Audit logging** for all access attempts
- **Time-limited access** (20 days maximum)

### **Access Methods**
1. **AWS Console**: Web-based access for visual demos
2. **AWS CLI**: Command-line access for technical users
3. **Cross-Account**: Team members can assume roles from their AWS accounts

### **Security Controls**
- **Principle of least privilege**: Read-only access only
- **Time expiration**: Automatic access revocation
- **Audit trails**: Complete access logging
- **Resource isolation**: Lab environment only

---

## 📋 **Live Demo Checklist**

### **Pre-Demo (5 minutes)**
- [ ] Deploy lab environment with Terraform
- [ ] Create instructor access credentials
- [ ] Test console and CLI access
- [ ] Prepare demo script and talking points

### **Live Demo (15-20 minutes)**
- [ ] **Introduction** (2 min): Project overview and objectives
- [ ] **Infrastructure Walkthrough** (5 min): VPC, security groups, instances
- [ ] **Security Features** (3 min): Monitoring, logging, access controls
- [ ] **Team Collaboration** (3 min): Share access, demonstrate capabilities
- [ ] **Q&A Session** (2 min): Address questions and feedback

### **Post-Demo (5 minutes)**
- [ ] Document feedback and questions
- [ ] Schedule follow-up if needed
- [ ] Clean up access credentials
- [ ] Archive demo materials

---

## 🚨 **Troubleshooting**

### **Common Issues**
- **Access Denied**: Check IAM policy permissions
- **Console Loading**: Verify browser compatibility
- **CLI Errors**: Confirm AWS credentials configuration
- **Resource Not Found**: Verify lab environment is running

### **Support Contacts**
- **Technical Lead**: [Team Lead Name]
- **Project Lead**: Shannon Kelly
- **Lab Administrator**: [Your Name]

---

## 🎉 **Benefits for Live Demos**

### **Professional Presentation**
- **No SSH key sharing** required
- **Enterprise-grade security** controls
- **Audit-compliant access** logging
- **Professional appearance** for stakeholders

### **Team Collaboration**
- **Multiple team members** can access simultaneously
- **Cross-account access** capabilities
- **Time-limited access** for security
- **Comprehensive monitoring** and logging

### **Live Demo Success**
- **15-20 minute** complete lab walkthrough
- **Interactive audience** participation
- **Real-time resource** demonstration
- **Professional credibility** with stakeholders

---

**Ready for Live Demos**: This system enables professional, secure demonstrations of your P2W12 cyber range lab while maintaining enterprise-grade security standards.

