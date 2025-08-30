# Instructor Access Guide - P2W12 Quantum Shield Cyber Range
## Secure AWS Console Access for Lab Demonstration

**Project**: P2W12 Advanced Cybersecurity Lab  
**Environment**: Quantum Shield Cyber Range  
**Access Method**: IAM Role-Based Console Access  
**Security Level**: Enterprise-Grade, Temporary Access  

---

## 🎯 **Access Overview**

This guide provides instructors with secure, temporary access to the P2W12 cyber range lab environment through the AWS Management Console. No SSH keys or direct server access required.

### **✅ What You Can Access:**
- **EC2 Instances**: View running Kali Linux and vulnerable target machines
- **Network Architecture**: VPC, subnets, security groups, route tables
- **Security Monitoring**: CloudWatch metrics, logs, and alarms
- **Resource Status**: Instance health, performance metrics, and configurations

### **❌ What You Cannot Access:**
- **SSH Access**: No direct server login capabilities
- **Resource Modification**: Read-only access only
- **Sensitive Data**: No access to credentials or private keys
- **Administrative Functions**: Cannot create, modify, or delete resources

---

## 🔐 **Access Methods**

### **Method 1: Temporary IAM User (Recommended for Quick Demo)**

#### **Step 1: Receive Access Credentials**
You will receive:
- **AWS Console URL**: https://console.aws.amazon.com/
- **Username**: `p2w12-instructor-YYYYMMDD`
- **Temporary Password**: Generated and shared securely
- **Access Duration**: 24 hours from creation

#### **Step 2: Login to AWS Console**
1. Navigate to: https://console.aws.amazon.com/
2. Click "Sign In to the Console"
3. Enter your username and temporary password
4. Change password on first login (if prompted)

#### **Step 3: Navigate to Lab Resources**
1. **EC2 Dashboard**: View running instances
2. **VPC Dashboard**: Explore network architecture
3. **CloudWatch**: Monitor metrics and logs
4. **IAM**: Verify your access permissions

### **Method 2: Cross-Account IAM Role (Professional Setup)**

#### **Step 1: Assume the Role**
```bash
# Using AWS CLI
aws sts assume-role \
  --role-arn arn:aws:iam::ACCOUNT:role/p2w12-instructor-role-YYYYMMDD \
  --role-session-name InstructorDemo \
  --tags Key=Project,Value=Quantum-Shield-Cyber-Range Key=Instructor,Value=true
```

#### **Step 2: Configure AWS CLI Profile**
```bash
# Add credentials to your AWS profile
aws configure set aws_access_key_id ACCESS_KEY_ID --profile instructor
aws configure set aws_secret_access_key SECRET_ACCESS_KEY --profile instructor
aws configure set aws_session_token SESSION_TOKEN --profile instructor
aws configure set region us-east-1 --profile instructor
```

#### **Step 3: Use the Profile**
```bash
# List EC2 instances
aws ec2 describe-instances --profile instructor

# View VPC resources
aws ec2 describe-vpcs --profile instructor
```

---

## 🖥️ **Console Navigation Guide**

### **EC2 Dashboard - Instance Overview**
1. **Navigate to**: EC2 → Instances
2. **Look for instances tagged**:
   - `Name: quantum-shield-kali-attacker`
   - `Name: quantum-shield-vuln-target`
3. **Key Information to Show**:
   - Instance IDs and status
   - Public/Private IP addresses
   - Security group assignments
   - Instance types and configurations

### **VPC Dashboard - Network Architecture**
1. **Navigate to**: VPC → Your VPCs
2. **Look for VPC**: `quantum-shield-vpc` (10.0.0.0/16)
3. **Explore Subnets**:
   - Public subnet (10.0.1.0/24)
   - Private app subnet (10.0.2.0/24)
   - Private data subnet (10.0.3.0/24)
4. **Security Groups**: Review access rules and microsegmentation

### **CloudWatch Dashboard - Monitoring**
1. **Navigate to**: CloudWatch → Dashboards
2. **Look for**: Security monitoring metrics
3. **Key Metrics**:
   - CPU utilization
   - Network traffic
   - Security events
   - Log analysis

---

## 📊 **What to Demonstrate**

### **1. Infrastructure Architecture**
- **Multi-tier VPC design** with public/private subnets
- **Security group microsegmentation** for network isolation
- **Route table configuration** for traffic control
- **Network ACLs** for additional security layers

### **2. Security Controls**
- **Security group rules** showing least privilege access
- **Network segmentation** demonstrating defense in depth
- **Monitoring and logging** capabilities
- **Compliance with security best practices**

### **3. Lab Environment**
- **Kali Linux machine** for offensive security testing
- **Vulnerable target** for penetration testing exercises
- **Real-time monitoring** of security events
- **Automated threat detection** systems

### **4. Professional Implementation**
- **Infrastructure as Code** using Terraform
- **Automated deployment** and configuration
- **Cost optimization** within Free Tier limits
- **Enterprise-grade security** architecture

---

## 🔒 **Security Features**

### **Access Control**
- **Time-limited access** (24 hours maximum)
- **Read-only permissions** (no resource modification)
- **Audit logging** of all access attempts
- **Principle of least privilege** enforcement

### **Network Security**
- **VPC isolation** from other AWS resources
- **Security group restrictions** limiting access
- **Network ACLs** providing additional protection
- **Private subnets** for sensitive resources

### **Monitoring & Compliance**
- **CloudWatch integration** for real-time monitoring
- **Security event logging** and alerting
- **Resource tagging** for cost tracking
- **Compliance documentation** and procedures

---

## 📋 **Demo Checklist**

### **Pre-Demo Setup**
- [ ] Verify instructor access credentials
- [ ] Test console login and navigation
- [ ] Prepare demo script and talking points
- [ ] Ensure lab environment is running

### **During Demo**
- [ ] **Introduction** (2 minutes)
  - Project overview and team structure
  - Lab objectives and learning outcomes
  - Security architecture highlights

- [ ] **Infrastructure Walkthrough** (5 minutes)
  - VPC and subnet design
  - Security group configuration
  - Network segmentation demonstration

- [ ] **Security Features** (3 minutes)
  - Monitoring and alerting systems
  - Threat detection capabilities
  - Compliance and best practices

- [ ] **Lab Capabilities** (3 minutes)
  - Penetration testing environment
  - Vulnerability assessment tools
  - Real-time security monitoring

- [ ] **Q&A Session** (2 minutes)
  - Address technical questions
  - Discuss implementation details
  - Share lessons learned

### **Post-Demo Actions**
- [ ] Document any questions or feedback
- [ ] Update access logs and audit trail
- [ ] Schedule follow-up if needed
- [ ] Revoke temporary access credentials

---

## 🚨 **Troubleshooting**

### **Common Issues**

#### **Access Denied Errors**
- **Cause**: Permissions not properly assigned
- **Solution**: Contact lab administrator to verify IAM policy

#### **Console Loading Issues**
- **Cause**: Browser compatibility or network issues
- **Solution**: Try different browser or clear cache

#### **Resource Not Found**
- **Cause**: Resources may have been terminated
- **Solution**: Check if lab environment is still running

#### **Session Expired**
- **Cause**: Temporary credentials expired
- **Solution**: Request new access credentials

### **Support Contacts**
- **Lab Administrator**: [Your Name]
- **Technical Lead**: [Team Lead Name]
- **Project Lead**: Shannon Kelly
- **Emergency Contact**: [Emergency Contact Info]

---

## 📚 **Additional Resources**

### **Documentation**
- **Lab Architecture**: See `ARCHITECTURE.md`
- **Security Controls**: See `SECURITY_OVERVIEW.md`
- **Team Structure**: See `TEAM_README.md`
- **Technical Details**: See `TECHNICAL_SPECS.md`

### **Training Materials**
- **Lab Objectives**: Learning outcomes and skills
- **Exercise Scenarios**: Penetration testing exercises
- **Security Concepts**: Theoretical background
- **Best Practices**: Industry standards and guidelines

---

## 🎉 **Conclusion**

This instructor access system provides:
- **Professional presentation** of lab capabilities
- **Secure access** without compromising security
- **Comprehensive visibility** into lab environment
- **Audit trail** for compliance and tracking

The P2W12 Quantum Shield Cyber Range demonstrates enterprise-grade cybersecurity infrastructure while maintaining the highest security standards for instructor access.

---

**Document Version**: 1.0  
**Last Updated**: August 29, 2025  
**Access Expires**: 24 hours from creation  
**Security Level**: Enterprise-Grade  
**Compliance**: AWS Security Best Practices

