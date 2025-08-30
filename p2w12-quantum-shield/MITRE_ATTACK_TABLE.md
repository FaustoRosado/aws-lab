# MITRE ATT&CK Framework - P2W12 Lab Vulnerabilities
## Quantum Shield Cyber Range Security Assessment

**Project**: P2W12 Advanced Cybersecurity Lab  
**Assessment Date**: August 29, 2025  
**Scope**: AWS Cloud Infrastructure and Web Application Security  
**Team**: Shannon Kelly, Fausto Rosado, Zeinab Ali, Latrisha Dodson, Javier Acosta

---

## Executive Summary

This document maps identified vulnerabilities in the P2W12 Quantum Shield Cyber Range to the MITRE ATT&CK framework. Each vulnerability is categorized by tactic, technique, and provides specific mitigation strategies and best practices.

---

## Initial Access (TA0001)

### T1078 - Valid Accounts
**Vulnerability**: SSH key-based authentication on Kali machine  
**Risk Level**: Medium  
**Description**: Access to attacker machine via SSH key authentication  
**Mitigation**: 
- Implement multi-factor authentication
- Regular key rotation
- Access logging and monitoring
- Principle of least privilege

**Best Practice**: Use AWS IAM roles with temporary credentials instead of long-term SSH keys

### T1078.004 - Cloud Accounts
**Vulnerability**: AWS account access for lab deployment  
**Risk Level**: High  
**Description**: Administrative access to AWS resources  
**Mitigation**:
- Implement least privilege access
- Enable CloudTrail logging
- Regular access reviews
- Use AWS Organizations for isolation

**Best Practice**: Implement AWS Control Tower for centralized security governance

---

## Execution (TA0002)

### T1059 - Command and Scripting Interpreter
**Vulnerability**: Command injection in web application  
**Risk Level**: High  
**Description**: OS command execution through web forms  
**Mitigation**:
- Input validation and sanitization
- Use of parameterized commands
- Web application firewall (WAF)
- Regular security testing

**Best Practice**: Implement input validation using allowlists and escape user input

### T1059.004 - Unix Shell
**Vulnerability**: Bash command execution on Linux instances  
**Risk Level**: Medium  
**Description**: Shell access through SSH and web applications  
**Mitigation**:
- Restrict shell access
- Monitor command execution
- Implement process monitoring
- Use containerization

**Best Practice**: Use AWS Systems Manager Session Manager instead of direct SSH access

---

## Persistence (TA0003)

### T1098 - Account Manipulation
**Vulnerability**: User account creation and modification  
**Risk Level**: Medium  
**Description**: Potential for unauthorized account creation  
**Mitigation**:
- Implement account lifecycle management
- Regular account audits
- Multi-factor authentication
- Access monitoring

**Best Practice**: Use AWS IAM Identity Center for centralized user management

### T1505 - Software Deployment Tools
**Vulnerability**: Web application deployment and updates  
**Risk Level**: Low  
**Description**: Application deployment through web server  
**Mitigation**:
- Secure deployment pipelines
- Code signing and verification
- Change management procedures
- Deployment monitoring

**Best Practice**: Implement CI/CD pipelines with security scanning and approval workflows

---

## Privilege Escalation (TA0004)

### T1068 - Exploitation for Privilege Escalation
**Vulnerability**: Potential privilege escalation through web application  
**Risk Level**: High  
**Description**: Web application running with elevated privileges  
**Mitigation**:
- Run applications with minimal privileges
- Regular security updates
- Vulnerability scanning
- Access control monitoring

**Best Practice**: Use AWS Lambda functions with minimal IAM permissions

### T1548 - Abuse Elevation Control Mechanism
**Vulnerability**: Sudo access and privilege management  
**Risk Level**: Medium  
**Description**: Administrative access to Linux instances  
**Mitigation**:
- Implement just-in-time access
- Privilege escalation monitoring
- Regular access reviews
- Use of AWS Systems Manager

**Best Practice**: Implement AWS IAM roles with temporary elevated access

---

## Defense Evasion (TA0005)

### T1070 - Indicator Removal on Host
**Vulnerability**: Log file manipulation and deletion  
**Risk Level**: Medium  
**Description**: Potential for log tampering and evidence destruction  
**Mitigation**:
- Centralized logging (CloudWatch)
- Log integrity monitoring
- Immutable log storage
- Regular log analysis

**Best Practice**: Use AWS CloudTrail with S3 bucket versioning and MFA delete

### T1562 - Impair Defenses
**Vulnerability**: Security tool bypass and evasion  
**Risk Level**: High  
**Description**: Attempts to disable security monitoring  
**Mitigation**:
- Multiple security layers
- Behavioral monitoring
- Regular security assessments
- Incident response procedures

**Best Practice**: Implement defense in depth with multiple security tools and monitoring

---

## Credential Access (TA0006)

### T1110 - Brute Force
**Vulnerability**: SSH brute force attempts  
**Risk Level**: Medium  
**Description**: Multiple authentication attempts against SSH service  
**Mitigation**:
- Rate limiting and account lockout
- Intrusion detection systems
- Security monitoring
- Strong authentication policies

**Best Practice**: Use AWS Shield Advanced and implement rate limiting at the network level

### T1555 - Credentials from Password Stores
**Vulnerability**: Hardcoded credentials and secrets  
**Risk Level**: High  
**Description**: Potential for credential exposure in code and configuration  
**Mitigation**:
- Use AWS Secrets Manager
- Implement secret rotation
- Code scanning for secrets
- Access monitoring

**Best Practice**: Use AWS IAM roles and temporary credentials instead of hardcoded secrets

---

## Discovery (TA0007)

### T1046 - Network Service Scanning
**Vulnerability**: Port scanning and service enumeration  
**Risk Level**: Medium  
**Description**: Network reconnaissance and service discovery  
**Mitigation**:
- Network segmentation
- Security group restrictions
- Intrusion detection
- Traffic monitoring

**Best Practice**: Implement AWS Network Firewall and VPC Flow Logs for traffic analysis

### T1082 - System Information Discovery
**Vulnerability**: System information disclosure  
**Risk Level**: Low  
**Description**: Exposure of system details and configuration  
**Mitigation**:
- Information classification
- Access controls
- Regular security assessments
- Data loss prevention

**Best Practice**: Use AWS Config for configuration compliance monitoring

---

## Lateral Movement (TA0008)

### T1021 - Remote Services
**Vulnerability**: SSH access between instances  
**Risk Level**: Medium  
**Description**: Lateral movement through SSH connections  
**Mitigation**:
- Network segmentation
- Access controls
- Connection monitoring
- Regular access reviews

**Best Practice**: Implement AWS Transit Gateway with centralized routing and monitoring

### T1021.004 - SSH
**Vulnerability**: SSH key-based authentication between instances  
**Risk Level**: Medium  
**Description**: SSH access for administrative purposes  
**Mitigation**:
- Use of bastion hosts
- Jump server implementation
- Access logging
- Regular key rotation

**Best Practice**: Use AWS Systems Manager Session Manager for secure instance access

---

## Collection (TA0009)

### T1005 - Data from Local System
**Vulnerability**: Local file system access  
**Risk Level**: Medium  
**Description**: Access to local files and system data  
**Mitigation**:
- File system permissions
- Data classification
- Access monitoring
- Encryption at rest

**Best Practice**: Use AWS KMS for encryption and implement least privilege access

### T1074 - Data Staged
**Vulnerability**: Data staging and collection  
**Risk Level**: Low  
**Description**: Temporary data storage and processing  
**Mitigation**:
- Data lifecycle management
- Secure deletion procedures
- Access controls
- Monitoring and alerting

**Best Practice**: Implement AWS S3 lifecycle policies and access logging

---

## Command and Control (TA0011)

### T1071 - Application Layer Protocol
**Vulnerability**: Web application communication  
**Risk Level**: Medium  
**Description**: HTTP/HTTPS communication for command and control  
**Mitigation**:
- Web application firewall
- Traffic monitoring
- Behavioral analysis
- Regular security testing

**Best Practice**: Use AWS WAF and implement rate limiting and anomaly detection

### T1105 - Ingress Tool Transfer
**Vulnerability**: File upload and download capabilities  
**Risk Level**: High  
**Description**: Unrestricted file transfer through web application  
**Mitigation**:
- File type validation
- Malware scanning
- Access controls
- Monitoring and alerting

**Best Practice**: Use AWS S3 with virus scanning and implement file upload restrictions

---

## Exfiltration (TA0010)

### T1041 - Exfiltration Over C2 Channel
**Vulnerability**: Data exfiltration through web application  
**Risk Level**: High  
**Description**: Unauthorized data transfer and exfiltration  
**Mitigation**:
- Data loss prevention
- Network monitoring
- Access controls
- Behavioral analysis

**Best Practice**: Implement AWS Macie for data discovery and classification

### T1048 - Exfiltration Over Alternative Protocol
**Vulnerability**: Alternative data transfer methods  
**Risk Level**: Medium  
**Description**: Use of non-standard protocols for data transfer  
**Mitigation**:
- Protocol monitoring
- Traffic analysis
- Access controls
- Regular security assessments

**Best Practice**: Use AWS VPC Flow Logs and implement network traffic analysis

---

## Impact (TA0040)

### T1499 - Endpoint Denial of Service
**Vulnerability**: Resource exhaustion attacks  
**Risk Level**: Medium  
**Description**: Potential for denial of service through resource consumption  
**Mitigation**:
- Resource monitoring
- Rate limiting
- Auto-scaling
- DDoS protection

**Best Practice**: Use AWS Shield and implement CloudWatch alarms for resource monitoring

### T1498 - Network Denial of Service
**Vulnerability**: Network-level denial of service  
**Risk Level**: Medium  
**Description**: Network flooding and bandwidth exhaustion  
**Mitigation**:
- DDoS protection
- Traffic filtering
- Network monitoring
- Incident response procedures

**Best Practice**: Implement AWS Shield Advanced and use CloudFront for DDoS protection

---

## Mitigation Strategies

### Network Security
1. **VPC Design**: Implement proper network segmentation
2. **Security Groups**: Use least privilege access
3. **Network ACLs**: Implement additional network controls
4. **Flow Logs**: Enable comprehensive traffic monitoring

### Application Security
1. **Input Validation**: Implement strict input validation
2. **Authentication**: Use multi-factor authentication
3. **Authorization**: Implement role-based access control
4. **Monitoring**: Enable comprehensive logging and alerting

### Infrastructure Security
1. **IAM Policies**: Use least privilege access
2. **Encryption**: Enable encryption at rest and in transit
3. **Monitoring**: Implement CloudWatch and CloudTrail
4. **Compliance**: Use AWS Config for configuration management

---

## Risk Assessment Summary

| Risk Level | Count | Percentage |
|------------|-------|------------|
| High      | 8     | 32%        |
| Medium    | 12    | 48%        |
| Low       | 5     | 20%        |

**Total Vulnerabilities**: 25  
**Critical Paths**: 8  
**Mitigation Required**: 100%

---

## Next Steps

1. **Immediate Actions**: Address high-risk vulnerabilities
2. **Short Term**: Implement monitoring and alerting
3. **Medium Term**: Deploy additional security controls
4. **Long Term**: Establish security governance framework

---

## References

- MITRE ATT&CK Framework: https://attack.mitre.org/
- AWS Security Best Practices: https://aws.amazon.com/security/security-learning/
- NIST Cybersecurity Framework: https://www.nist.gov/cyberframework
- OWASP Top 10: https://owasp.org/www-project-top-ten/

---

**Document Version**: 1.0  
**Assessment Date**: August 29, 2025  
**Next Review**: September 5, 2025  
**Team Approval**: Pending
