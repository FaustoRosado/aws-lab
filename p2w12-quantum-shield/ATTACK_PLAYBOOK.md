# Quantum Shield Cyber Range - Attack Playbook
## P2W12 Team Project

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

## 🎯 Lab Objectives

### Primary Goals
1. **Network Reconnaissance**: Learn passive and active information gathering
2. **Vulnerability Assessment**: Identify and categorize security weaknesses
3. **Penetration Testing**: Execute controlled attacks in isolated environment
4. **Security Controls**: Understand defense mechanisms and bypass techniques
5. **Incident Response**: Practice detection and response procedures

### Learning Outcomes
- Master network scanning and enumeration techniques
- Understand security group and network ACL configurations
- Practice ethical hacking in controlled environment
- Develop incident response and forensics skills
- Learn cloud security best practices

---

## 🚀 Lab Setup & Access

### Prerequisites
- AWS CLI configured with appropriate credentials
- SSH client (PuTTY, OpenSSH, etc.)
- Basic understanding of Linux commands
- Familiarity with networking concepts

### Initial Access
```bash
# Connect to Kali machine
ssh -i my-lab-key-new.pem ec2-user@54.86.84.45

# Verify connectivity to target
ping -c 3 10.0.2.90
```

### Available Tools
- **Nmap**: Port scanning and service enumeration
- **Netcat**: Network connectivity testing
- **Telnet**: Service testing and banner grabbing
- **Curl**: Web application testing
- **Ping**: ICMP connectivity testing

---

## 🔍 Phase 1: Reconnaissance

### 1.1 Network Discovery
**Objective**: Map the target network and identify live hosts

**Exercise**: Basic Network Scan
```bash
# Ping sweep to identify live hosts
ping -c 1 10.0.2.90

# Expected Result: Host is up, 0% packet loss
```

**Learning Point**: ICMP responses indicate host availability and network connectivity

**Exercise**: Port Scanning
```bash
# TCP connect scan of common ports
nmap -sT -p 1-1000 10.0.2.90

# Expected Result: 
# PORT   STATE  SERVICE
# 22/tcp open   ssh
# 80/tcp closed http
```

**Learning Point**: Understanding port states (open, closed, filtered) and service identification

### 1.2 Service Enumeration
**Objective**: Identify running services and their versions

**Exercise**: Service Detection
```bash
# Comprehensive service scan
nmap -sT -p 21,22,23,25,53,80,110,143,443,993,995,3306,3389,5432,5900,6379,8080,8443 10.0.2.90

# Expected Result: Most ports filtered, only SSH open
```

**Learning Point**: Security groups control access to services, demonstrating network segmentation

**Exercise**: Banner Grabbing
```bash
# Attempt to grab SSH banner
nc -v 10.0.2.90 22

# Expected Result: SSH service banner with version information
```

**Learning Point**: Service banners reveal version information useful for vulnerability research

### 1.3 Network Path Analysis
**Objective**: Understand network topology and routing

**Exercise**: Traceroute Analysis
```bash
# Trace network path to target
traceroute 10.0.2.90

# Expected Result: All asterisks indicating same subnet
```

**Learning Point**: Internal network routing and subnet design

---

## 🎯 Phase 2: Vulnerability Assessment

### 2.1 Authentication Testing
**Objective**: Test access controls and authentication mechanisms

**Exercise**: SSH Authentication Bypass
```bash
# Test password authentication (should fail)
ssh -o PasswordAuthentication=yes ec2-user@10.0.2.90

# Expected Result: Permission denied (publickey,gssapi-keyex,gssapi-with-mic)
```

**Learning Point**: Key-based authentication enforcement and security group restrictions

**Exercise**: SSH Brute Force Simulation
```bash
# Simulate multiple login attempts
for i in {1..3}; do 
    ssh -o ConnectTimeout=2 -o StrictHostKeyChecking=no -o PasswordAuthentication=no ec2-user@10.0.2.90 'echo test' 2>&1 | grep -E '(Permission denied|Connection refused|timeout)'
done

# Expected Result: All attempts fail with proper error messages
```

**Learning Point**: Brute force protection and rate limiting considerations

### 2.2 Service Vulnerability Testing
**Objective**: Identify service-specific vulnerabilities

**Exercise**: Web Application Testing
```bash
# Test HTTP connectivity
curl -v http://10.0.2.90

# Expected Result: Connection refused (web server not running)
```

**Learning Point**: Service availability and security group configurations

**Exercise**: Database Service Testing
```bash
# Test MySQL connectivity
nc -zv 10.0.2.90 3306

# Expected Result: Connection filtered (security group blocking)
```

**Learning Point**: Database security and network access controls

### 2.3 Network Security Testing
**Objective**: Test network-level security controls

**Exercise**: SYN Scan Testing
```bash
# Attempt SYN scan (requires root)
nmap -sS -p 22 10.0.2.90

# Expected Result: "requires root privileges. QUITTING!"
```

**Learning Point**: Privilege escalation requirements and security controls

**Exercise**: OS Fingerprinting
```bash
# Attempt OS detection
nmap -O 10.0.2.90

# Expected Result: "TCP/IP fingerprinting requires root privileges. QUITTING!"
```

**Learning Point**: Advanced scanning techniques and privilege requirements

---

## 🚨 Phase 3: Exploitation

### 3.1 Access Vector Testing
**Objective**: Test potential attack vectors

**Exercise**: SSH Key Testing
```bash
# Test if target has our SSH key
ssh -i my-lab-key-new.pem ec2-user@10.0.2.90

# Expected Result: Permission denied (key not authorized)
```

**Learning Point**: SSH key management and authorization

**Exercise**: Service Exploitation Simulation
```bash
# Simulate service exploitation attempts
echo "Simulating service exploitation..." > /tmp/exploit.log
```

**Learning Point**: Logging and monitoring for attack detection

### 3.2 Privilege Escalation
**Objective**: Test privilege escalation techniques

**Exercise**: Local Privilege Escalation
```bash
# Check current user privileges
whoami
id
sudo -l

# Expected Result: Limited privileges, no sudo access
```

**Learning Point**: Principle of least privilege and user access controls

---

## 🔒 Phase 4: Security Controls Validation

### 4.1 Network Segmentation
**Objective**: Verify network isolation and segmentation

**Exercise**: Cross-Subnet Access Testing
```bash
# Test access from public to private subnet
curl -m 5 http://10.0.2.90

# Expected Result: Connection refused or timeout
```

**Learning Point**: VPC design and subnet isolation

**Exercise**: Security Group Validation
```bash
# Test security group rules
nmap -sT -p 80,443,3306 10.0.2.90

# Expected Result: Ports filtered by security groups
```

**Learning Point**: Security group configuration and microsegmentation

### 4.2 Access Control Testing
**Objective**: Validate authentication and authorization controls

**Exercise**: Unauthorized Access Testing
```bash
# Test access without proper credentials
ssh -o PasswordAuthentication=yes ec2-user@10.0.2.90

# Expected Result: Authentication failure
```

**Learning Point**: Multi-factor authentication and access control enforcement

---

## 📊 Phase 5: Post-Exploitation

### 5.1 Persistence Testing
**Objective**: Test persistence mechanisms

**Exercise**: Backdoor Detection
```bash
# Check for suspicious processes
ps aux | grep -E "(nc|netcat|bash -i)"

# Expected Result: No suspicious processes found
```

**Learning Point**: Process monitoring and anomaly detection

### 5.2 Data Exfiltration Simulation
**Objective**: Test data protection mechanisms

**Exercise**: Sensitive Data Access
```bash
# Attempt to access sensitive files
ls -la /etc/passwd
cat /etc/passwd | head -5

# Expected Result: Read access to public files
```

**Learning Point**: File permissions and data classification

---

## 🚨 Phase 6: Incident Response

### 6.1 Detection Testing
**Objective**: Test security monitoring and alerting

**Exercise**: Suspicious Activity Simulation
```bash
# Generate suspicious network traffic
for i in {1..10}; do
    nc -zv 10.0.2.90 22
    sleep 1
done

# Expected Result: Potential security alerts
```

**Learning Point**: Security monitoring and threat detection

### 6.2 Response Procedures
**Objective**: Practice incident response procedures

**Exercise**: Incident Documentation
```bash
# Document incident details
echo "Incident: Multiple SSH connection attempts detected" > /tmp/incident.log
echo "Time: $(date)" >> /tmp/incident.log
echo "Source: $(whoami)@$(hostname)" >> /tmp/incident.log
```

**Learning Point**: Incident documentation and response procedures

---

## 📋 Exercise Checklist

### Phase 1: Reconnaissance
- [ ] Network discovery completed
- [ ] Port scanning performed
- [ ] Service enumeration completed
- [ ] Network path analysis completed

### Phase 2: Vulnerability Assessment
- [ ] Authentication testing completed
- [ ] Service vulnerability testing completed
- [ ] Network security testing completed

### Phase 3: Exploitation
- [ ] Access vector testing completed
- [ ] Privilege escalation testing completed

### Phase 4: Security Controls Validation
- [ ] Network segmentation testing completed
- [ ] Access control testing completed

### Phase 5: Post-Exploitation
- [ ] Persistence testing completed
- [ ] Data exfiltration simulation completed

### Phase 6: Incident Response
- [ ] Detection testing completed
- [ ] Response procedures practiced

---

## 🎓 Learning Objectives Met

### Technical Skills
- ✅ Network scanning and enumeration
- ✅ Service identification and testing
- ✅ Security group analysis
- ✅ Authentication testing
- ✅ Vulnerability assessment

### Security Concepts
- ✅ Defense in depth
- ✅ Network segmentation
- ✅ Access control
- ✅ Security monitoring
- ✅ Incident response

### Cloud Security
- ✅ VPC design and implementation
- ✅ Security group configuration
- ✅ Network ACL implementation
- ✅ Instance security hardening
- ✅ Monitoring and logging

---

## 🔧 Advanced Exercises (Optional)

### Web Application Security
- SQL injection testing
- Cross-site scripting (XSS) testing
- File upload vulnerability testing
- Session management testing

### Network Security
- Man-in-the-middle attack simulation
- ARP spoofing testing
- DNS spoofing simulation
- VLAN hopping testing

### Social Engineering
- Phishing simulation setup
- Credential harvesting testing
- Social media reconnaissance
- Physical security testing

---

## 📚 Additional Resources

### Tools and References
- **Nmap Documentation**: https://nmap.org/docs.html
- **OWASP Testing Guide**: https://owasp.org/www-project-web-security-testing-guide/
- **MITRE ATT&CK**: https://attack.mitre.org/
- **AWS Security Best Practices**: https://aws.amazon.com/security/security-learning/

### Next Steps
1. Complete all basic exercises
2. Practice advanced techniques
3. Document findings and lessons learned
4. Share knowledge with team members
5. Plan next lab expansion

---

**⚠️ Important Notes:**
- This lab is for educational purposes only
- All activities are performed in isolated environment
- Follow ethical hacking principles
- Document all activities for learning purposes
- Respect security controls and limitations

**Lab Status**: ✅ **OPERATIONAL**
**Last Updated**: August 29, 2025
**Next Review**: September 5, 2025
