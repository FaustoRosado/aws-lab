# Quantum Shield Cyber Range - Defense Playbook
## P2W12 Team Project - Blue Team Operations

**Team Members:**
- Shannon Kelly - Lead Cloud Architect
- Fausto Rosado - Infrastructure Engineer  
- Zeinab Ali - Red Team Engineer
- Latrisha Dodson - Blue Team Engineer
- Javier Acosta - Documentation Lead

**Lab Environment:**
- **Kali Attacker**: `54.86.84.45` (Public IP)
- **Vulnerable Target**: `10.0.2.90` (Private IP)
- **SSH Key**: `my-lab-key-new.pem`
- **VPC**: `vpc-07040a3caaeb5f336`

---

## 🛡️ Blue Team Mission

### Primary Objectives
1. **Threat Detection**: Identify and monitor suspicious activities
2. **Incident Response**: Respond to security incidents effectively
3. **Security Hardening**: Implement and maintain security controls
4. **Forensics**: Collect and analyze evidence
5. **Recovery**: Restore systems to secure state

### Key Responsibilities
- Monitor security logs and alerts
- Investigate security incidents
- Implement security controls
- Conduct security assessments
- Maintain incident response procedures

---

## 🔍 Phase 1: Security Monitoring

### 1.1 Log Collection
**Objective**: Establish comprehensive logging across all systems

**Exercise**: Log Review Setup
```bash
# Check system logs on target
ssh -i my-lab-key-new.pem ec2-user@54.86.84.45 "ssh ec2-user@10.0.2.90 'sudo tail -20 /var/log/secure'"

# Expected Result: SSH authentication logs
```

**Learning Point**: Centralized logging is essential for security monitoring

**Exercise**: CloudWatch Logs Setup
```bash
# Check if CloudWatch agent is running
ssh -i my-lab-key-new.pem ec2-user@54.86.84.45 "ssh ec2-user@10.0.2.90 'systemctl status amazon-cloudwatch-agent'"

# Expected Result: Service status information
```

**Learning Point**: Cloud-native logging and monitoring solutions

### 1.2 Network Monitoring
**Objective**: Monitor network traffic for suspicious activity

**Exercise**: Network Flow Analysis
```bash
# Check network connections on target
ssh -i my-lab-key-new.pem ec2-user@54.86.84.45 "ssh ec2-user@10.0.2.90 'netstat -tuln'"

# Expected Result: Active network connections
```

**Learning Point**: Network monitoring for anomaly detection

**Exercise**: Security Group Monitoring
```bash
# Review security group rules
aws ec2 describe-security-groups --group-ids sg-046b3d3fb030c6d1b --query 'SecurityGroups[*].IpPermissions'

# Expected Result: Current security group configuration
```

**Learning Point**: Security group configuration monitoring

### 1.3 Process Monitoring
**Objective**: Monitor system processes for malicious activity

**Exercise**: Process Analysis
```bash
# Check running processes on target
ssh -i my-lab-key-new.pem ec2-user@54.86.84.45 "ssh ec2-user@10.0.2.90 'ps aux | head -10'"

# Expected Result: List of running processes
```

**Learning Point**: Process monitoring for backdoor detection

---

## 🚨 Phase 2: Threat Detection

### 2.1 Anomaly Detection
**Objective**: Identify unusual patterns and behaviors

**Exercise**: SSH Brute Force Detection
```bash
# Monitor SSH login attempts
ssh -i my-lab-key-new.pem ec2-user@54.86.84.45 "ssh ec2-user@10.0.2.90 'grep -i 'failed password' /var/log/secure | tail -5'"

# Expected Result: Failed authentication attempts
```

**Learning Point**: Pattern recognition for attack detection

**Exercise**: Port Scan Detection
```bash
# Monitor for port scanning activity
ssh -i my-lab-key-new.pem ec2-user@54.86.84.45 "ssh ec2-user@10.0.2.90 'netstat -an | grep :22 | wc -l'"

# Expected Result: Number of SSH connections
```

**Learning Point**: Network scanning detection

### 2.2 Signature Detection
**Objective**: Identify known attack patterns

**Exercise**: Malware Detection
```bash
# Check for suspicious files
ssh -i my-lab-key-new.pem ec2-user@54.86.84.45 "ssh ec2-user@10.0.2.90 'find /tmp -name \"*.sh\" -o -name \"*.py\" -o -name \"*.exe\" 2>/dev/null'"

# Expected Result: List of suspicious files (if any)
```

**Learning Point**: File-based threat detection

**Exercise**: Command History Analysis
```bash
# Review command history for suspicious activity
ssh -i my-lab-key-new.pem ec2-user@54.86.84.45 "ssh ec2-user@10.0.2.90 'history | tail -20'"

# Expected Result: Recent command history
```

**Learning Point**: User behavior analysis

---

## 🚨 Phase 3: Incident Response

### 3.1 Incident Classification
**Objective**: Categorize and prioritize security incidents

**Exercise**: Incident Assessment
```bash
# Create incident report template
cat > /tmp/incident_report.txt << 'EOF'
INCIDENT REPORT
===============
Date: $(date)
Severity: [LOW/MEDIUM/HIGH/CRITICAL]
Description: 
Affected Systems:
Impact Assessment:
Response Actions:
EOF
```

**Learning Point**: Structured incident documentation

### 3.2 Containment Procedures
**Objective**: Isolate affected systems and prevent spread

**Exercise**: Network Isolation
```bash
# Simulate network isolation
echo "Simulating network isolation for target system..."
echo "1. Blocking suspicious IP addresses"
echo "2. Restricting network access"
echo "3. Monitoring for additional activity"
```

**Learning Point**: Incident containment strategies

**Exercise**: Process Termination
```bash
# Check for suspicious processes
ssh -i my-lab-key-new.pem ec2-user@54.86.84.45 "ssh ec2-user@10.0.2.90 'ps aux | grep -E \"(nc|netcat|bash -i|python -c)\"'"

# Expected Result: No suspicious processes (or list if found)
```

**Learning Point**: Process containment and termination

### 3.3 Evidence Collection
**Objective**: Preserve evidence for analysis

**Exercise**: Log Preservation
```bash
# Create evidence collection script
cat > /tmp/collect_evidence.sh << 'EOF'
#!/bin/bash
echo "Collecting evidence from $(hostname) at $(date)"
echo "=== System Information ===" > evidence.log
uname -a >> evidence.log
echo "=== Network Connections ===" >> evidence.log
netstat -tuln >> evidence.log
echo "=== Running Processes ===" >> evidence.log
ps aux >> evidence.log
echo "=== Recent Logs ===" >> evidence.log
tail -100 /var/log/secure >> evidence.log
echo "Evidence collection complete"
EOF
```

**Learning Point**: Evidence preservation procedures

---

## 🔒 Phase 4: Security Hardening

### 4.1 Access Control
**Objective**: Strengthen authentication and authorization

**Exercise**: SSH Hardening
```bash
# Review SSH configuration
ssh -i my-lab-key-new.pem ec2-user@54.86.84.45 "ssh ec2-user@10.0.2.90 'grep -E \"(PasswordAuthentication|PermitRootLogin|MaxAuthTries)\" /etc/ssh/sshd_config'"

# Expected Result: SSH security settings
```

**Learning Point**: SSH security configuration

**Exercise**: User Account Review
```bash
# Check user accounts
ssh -i my-lab-key-new.pem ec2-user@54.86.84.45 "ssh ec2-user@10.0.2.90 'cat /etc/passwd | grep -E \"(sh|bash)\"'"

# Expected Result: List of shell-enabled users
```

**Learning Point**: User account management

### 4.2 Network Security
**Objective**: Strengthen network defenses

**Exercise**: Firewall Configuration
```bash
# Check iptables rules
ssh -i my-lab-key-new.pem ec2-user@54.86.84.45 "ssh ec2-user@10.0.2.90 'sudo iptables -L -n'"

# Expected Result: Current firewall rules
```

**Learning Point**: Network firewall configuration

**Exercise**: Security Group Optimization
```bash
# Review security group rules
aws ec2 describe-security-groups --group-ids sg-046b3d3fb030c6d1b --query 'SecurityGroups[*].{Name:GroupName,Rules:IpPermissions}'

# Expected Result: Security group configuration
```

**Learning Point**: Cloud security group management

---

## 🔍 Phase 5: Forensics Analysis

### 5.1 Memory Analysis
**Objective**: Analyze system memory for malicious activity

**Exercise**: Process Memory Analysis
```bash
# Check process memory usage
ssh -i my-lab-key-new.pem ec2-user@54.86.84.45 "ssh ec2-user@10.0.2.90 'ps aux --sort=-%mem | head -10'"

# Expected Result: Memory usage by process
```

**Learning Point**: Memory analysis techniques

**Exercise**: File System Analysis
```bash
# Check for recently modified files
ssh -i my-lab-key-new.pem ec2-user@54.86.84.45 "ssh ec2-user@10.0.2.90 'find /home -mtime -1 -type f 2>/dev/null'"

# Expected Result: Recently modified files
```

**Learning Point**: File system forensics

### 5.2 Network Forensics
**Objective**: Analyze network traffic and connections

**Exercise**: Connection Analysis
```bash
# Analyze network connections
ssh -i my-lab-key-new.pem ec2-user@54.86.84.45 "ssh ec2-user@10.0.2.90 'netstat -tuln | grep -E \"(22|80|443|3306)\"'"

# Expected Result: Active network connections
```

**Learning Point**: Network forensics techniques

---

## 🚨 Phase 6: Recovery & Lessons Learned

### 6.1 System Recovery
**Objective**: Restore systems to secure state

**Exercise**: Recovery Procedures
```bash
# Create recovery checklist
cat > /tmp/recovery_checklist.txt << 'EOF'
RECOVERY CHECKLIST
=================
1. Verify system integrity
2. Update security patches
3. Review and update security configurations
4. Test system functionality
5. Document lessons learned
6. Update incident response procedures
EOF
```

**Learning Point**: System recovery procedures

### 6.2 Post-Incident Analysis
**Objective**: Analyze incident and improve defenses

**Exercise**: Lessons Learned
```bash
# Create lessons learned document
cat > /tmp/lessons_learned.txt << 'EOF'
LESSONS LEARNED
===============
Incident Date: $(date)
What Worked Well:
What Could Be Improved:
Recommendations:
Action Items:
EOF
```

**Learning Point**: Continuous improvement process

---

## 📋 Blue Team Exercise Checklist

### Phase 1: Security Monitoring
- [ ] Log collection setup completed
- [ ] Network monitoring configured
- [ ] Process monitoring established

### Phase 2: Threat Detection
- [ ] Anomaly detection configured
- [ ] Signature detection implemented
- [ ] Alert system tested

### Phase 3: Incident Response
- [ ] Incident classification procedures established
- [ ] Containment procedures tested
- [ ] Evidence collection procedures documented

### Phase 4: Security Hardening
- [ ] Access control strengthened
- [ ] Network security improved
- [ ] Security configurations reviewed

### Phase 5: Forensics Analysis
- [ ] Memory analysis procedures established
- [ ] File system analysis procedures documented
- [ ] Network forensics procedures tested

### Phase 6: Recovery & Lessons Learned
- [ ] System recovery procedures tested
- [ ] Post-incident analysis completed
- [ ] Lessons learned documented

---

## 🎓 Blue Team Skills Developed

### Technical Skills
- ✅ Security monitoring and alerting
- ✅ Incident response procedures
- ✅ Forensics analysis techniques
- ✅ Security hardening practices
- ✅ Threat detection and analysis

### Security Concepts
- ✅ Defense in depth
- ✅ Incident response lifecycle
- ✅ Threat hunting techniques
- ✅ Security metrics and KPIs
- ✅ Continuous improvement

### Cloud Security
- ✅ AWS security monitoring
- ✅ Cloud-native incident response
- ✅ Security group management
- ✅ CloudWatch integration
- ✅ AWS security best practices

---

## 🔧 Advanced Blue Team Exercises

### Threat Hunting
- Advanced log analysis
- Behavioral analytics
- Machine learning for threat detection
- Custom detection rules

### Incident Response Automation
- Automated response playbooks
- SOAR platform integration
- Threat intelligence integration
- Automated containment procedures

### Security Metrics
- Mean time to detection (MTTD)
- Mean time to response (MTTR)
- False positive rates
- Security ROI measurement

---

## 📚 Additional Resources

### Blue Team Tools
- **SIEM Solutions**: Splunk, ELK Stack, QRadar
- **EDR Solutions**: CrowdStrike, Carbon Black, SentinelOne
- **Forensics Tools**: Volatility, Autopsy, Wireshark
- **Threat Intelligence**: MISP, OpenCTI, ThreatFox

### Training Resources
- **SANS Blue Team**: https://www.sans.org/blue-team/
- **MITRE ATT&CK**: https://attack.mitre.org/
- **NIST Cybersecurity Framework**: https://www.nist.gov/cyberframework
- **AWS Security Best Practices**: https://aws.amazon.com/security/security-learning/

---

## 🚀 Next Steps for Blue Team

1. **Implement SIEM Solution**: Centralized security monitoring
2. **Deploy EDR Solution**: Endpoint detection and response
3. **Establish Threat Intelligence**: External threat feeds
4. **Automate Response**: SOAR platform implementation
5. **Conduct Tabletop Exercises**: Incident response practice

---

**⚠️ Important Notes:**
- All defensive activities are for educational purposes
- Follow incident response best practices
- Document all activities and findings
- Practice ethical security practices
- Maintain chain of custody for evidence

**Blue Team Status**: ✅ **OPERATIONAL**
**Last Updated**: August 29, 2025
**Next Review**: September 5, 2025
