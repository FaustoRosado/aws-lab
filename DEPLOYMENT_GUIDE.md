# Advanced Cyber Range - Deployment Guide

## Deployment Session: [Date]

### Team Members Present
- **Infrastructure Engineer**: [Name]
- **Security Engineer**: [Name]
- **Documentation Specialist**: [Name]

### Pre-Deployment Checklist

#### AWS Prerequisites Verification
- [ ] AWS CLI configured and working
- [ ] SSH key pair exists in AWS Console
- [ ] Sufficient AWS service limits
- [ ] Appropriate IAM permissions

#### Local Environment Verification
- [ ] Terraform version check
- [ ] Git repository status
- [ ] Required variables identified
- [ ] Network connectivity confirmed

---

## Phase 1: Environment Preparation

### Step 1: Navigate to Terraform Directory
```bash
cd p2w12-quantum-shield/terraform
```

**Screenshot Required**: Terminal showing current directory and file listing

### Step 2: Verify Terraform Files
```bash
ls -la
```

**Expected Files**:
- main.tf
- variables.tf
- network.tf
- security.tf
- instances.tf
- outputs.tf

**Screenshot Required**: Terminal showing file listing

---

## Phase 2: Terraform Initialization

### Step 3: Initialize Terraform
```bash
terraform init
```

**Expected Output**: Provider download and initialization success

**Screenshot Required**: Terminal showing successful initialization

**Verification Points**:
- [ ] AWS provider downloaded
- [ ] No error messages
- [ ] Working directory initialized

---

## Phase 3: Deployment Planning

### Step 4: Create Terraform Plan
```bash
terraform plan -var="my_ip=YOUR_PUBLIC_IP/32" -var="key_name=your-key-name"
```

**Note**: Replace variables with actual values:
- `YOUR_PUBLIC_IP/32`: Your public IP with /32 CIDR
- `your-key-name`: Your AWS SSH key pair name

**Screenshot Required**: Terminal showing plan output

**Key Resources to Verify**:
- [ ] VPC creation (10.10.0.0/16)
- [ ] 6 subnets across 2 AZs
- [ ] Internet Gateway and NAT Gateway
- [ ] 3 route tables
- [ ] 3 security groups
- [ ] 3 EC2 instances

---

## Phase 4: Infrastructure Deployment

### Step 5: Apply Terraform Configuration
```bash
terraform apply -var="my_ip=YOUR_PUBLIC_IP/32" -var="key_name=your-key-name"
```

**Important**: Type `yes` when prompted to confirm

**Screenshot Required**: Terminal showing deployment progress

**Deployment Timeline**:
- VPC and subnets: ~2-3 minutes
- Gateways and route tables: ~1-2 minutes
- EC2 instances: ~3-5 minutes
- **Total estimated time**: 6-10 minutes

---

## Phase 5: AWS Console Verification

### Step 6: Verify VPC Creation
**Navigate to**: AWS Console → VPC → Your VPCs

**Check for**:
- [ ] VPC with CIDR 10.10.0.0/16
- [ ] Name tag: "CyberRange-VPC"

**Screenshot Required**: AWS Console showing VPC details

### Step 7: Verify Subnet Configuration
**Navigate to**: AWS Console → VPC → Subnets

**Expected Subnets**:
- PublicSubnet-AZ1 (10.10.1.0/24)
- PublicSubnet-AZ2 (10.10.2.0/24)
- AppSubnet-AZ1 (10.10.10.0/24)
- AppSubnet-AZ2 (10.10.11.0/24)
- DataSubnet-AZ1 (10.10.20.0/24)
- DataSubnet-AZ2 (10.10.21.0/24)

**Screenshot Required**: AWS Console showing subnet listing

### Step 8: Verify Security Groups
**Navigate to**: AWS Console → VPC → Security Groups

**Expected Groups**:
- kali-sg (SSH from your IP, all outbound)
- webtarget-sg (HTTP/HTTPS/SSH from kali-sg)
- database-sg (MySQL from webtarget-sg)

**Screenshot Required**: AWS Console showing security group rules

### Step 9: Verify EC2 Instances
**Navigate to**: AWS Console → EC2 → Instances

**Expected Instances**:
- Kali-Attacker (Public subnet, t2.medium)
- Web-Target (App subnet, t2.micro)
- Database-Server (Data subnet, t2.micro)

**Screenshot Required**: AWS Console showing running instances

---

## Phase 6: Connectivity Testing

### Step 10: Test SSH Access to Kali Machine
```bash
ssh -i your-key-name.pem kali@<KALI_PUBLIC_IP>
```

**Screenshot Required**: Terminal showing successful SSH connection

**Verification Commands**:
```bash
# Check network configuration
ip addr show

# Verify internet connectivity
ping -c 3 8.8.8.8

# Check security tools availability
which nmap
which metasploit
```

### Step 11: Test Network Segmentation
From Kali machine:
```bash
# Test connectivity to web target
ping -c 3 <WEB_TARGET_PRIVATE_IP>

# Test connectivity to database
ping -c 3 <DATABASE_PRIVATE_IP>
```

**Expected Results**:
- Web target: Accessible
- Database: ❌ Not accessible (by design)

**Screenshot Required**: Terminal showing ping test results

---

## Phase 7: Security Validation

### Step 12: Verify Security Group Rules
**Test from Kali machine**:
```bash
# Test HTTP access to web target
curl http://<WEB_TARGET_PRIVATE_IP>

# Test direct database access (should fail)
telnet <DATABASE_PRIVATE_IP> 3306
```

**Screenshot Required**: Terminal showing security test results

---

## Phase 8: Documentation Completion

### Step 13: Capture Final State
```bash
# Get Terraform outputs
terraform output

# Show current state
terraform show
```

**Screenshot Required**: Terminal showing final outputs

### Step 14: Update Documentation
- [ ] Screenshots added to this guide
- [ ] README.md updated with deployment status
- [ ] Team roles assigned and documented
- [ ] Next steps identified

---

## Post-Deployment Checklist

### Immediate Actions
- [ ] Verify all resources created successfully
- [ ] Test SSH access to Kali machine
- [ ] Validate network segmentation
- [ ] Document any issues encountered

### Documentation Updates
- [ ] Screenshots added to deployment guide
- [ ] README.md status updated
- [ ] Team roles documented
- [ ] Process improvements identified

### Next Steps
- [ ] Schedule security testing session
- [ ] Plan penetration testing exercises
- [ ] Set up monitoring and alerting
- [ ] Schedule cleanup reminder

---

## Troubleshooting Notes

### Common Issues
1. **SSH Connection Failed**
   - Verify security group allows your IP
   - Check key pair name matches
   - Ensure instance is running

2. **Terraform Plan Errors**
   - Verify AWS credentials
   - Check variable syntax
   - Ensure sufficient service limits

3. **Resource Creation Failed**
   - Check AWS service status
   - Verify IAM permissions
   - Review CloudTrail logs

### Support Resources
- AWS Documentation: [VPC User Guide](https://docs.aws.amazon.com/vpc/)
- Terraform Documentation: [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- Security Best Practices: [AWS Security Documentation](https://aws.amazon.com/security/)

---

**Deployment Completed**: [Date/Time]
**Deployment Duration**: [Duration]
**Issues Encountered**: [List any issues]
**Next Session**: [Date/Time]
