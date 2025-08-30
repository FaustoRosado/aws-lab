# Quantum Shield Cyber Range - Team Documentation
## P2W12 Team Project

**Project**: Advanced Cybersecurity Lab Environment  
**Environment**: AWS Cloud-based Cyber Range  
**Status**: Operational  
**Last Updated**: August 29, 2025

---

## Team Structure

### Shannon Kelly - Lead Cloud Architect
- **Primary Role**: Infrastructure design and AWS architecture
- **Responsibilities**: VPC design, security group configuration, resource planning
- **Contact**: Team lead for technical decisions

### Fausto Rosado - Infrastructure Engineer
- **Primary Role**: Terraform deployment and infrastructure automation
- **Responsibilities**: Infrastructure as Code, deployment procedures, resource management
- **Contact**: Primary contact for deployment issues

### Zeinab Ali - Red Team Engineer
- **Primary Role**: Offensive security testing and attack simulation
- **Responsibilities**: Penetration testing, vulnerability assessment, attack vector development
- **Contact**: Red team operations and testing scenarios

### Latrisha Dodson - Blue Team Engineer
- **Primary Role**: Defensive security and incident response
- **Responsibilities**: Security monitoring, incident response, defensive procedures
- **Contact**: Blue team operations and security controls

### Javier Acosta - Documentation Lead
- **Primary Role**: Project documentation and knowledge management
- **Responsibilities**: Procedure documentation, training materials, project records
- **Contact**: Documentation and training coordination

---

## Lab Environment

### Infrastructure Components
- **VPC**: Quantum Shield Cyber Range network
- **Public Subnet**: Kali attacker machine (54.86.84.45)
- **Private Subnet**: Vulnerable target (10.0.2.90)
- **Security Groups**: Microsegmentation and access control
- **SSH Key**: my-lab-key-new.pem (local access only)

### Access Information
- **Kali Machine**: ssh -i my-lab-key-new.pem ec2-user@54.86.84.45
- **Target Machine**: Accessible from Kali via private IP
- **Web Application**: http://localhost/ (on Kali machine)

---

## Standard Operating Procedures

### Red Team Operations
1. **Reconnaissance**: Network scanning and service enumeration
2. **Vulnerability Assessment**: Identify and categorize weaknesses
3. **Exploitation**: Execute controlled attacks in isolated environment
4. **Documentation**: Record all findings and techniques used

### Blue Team Operations
1. **Monitoring**: Security event monitoring and alerting
2. **Detection**: Threat identification and analysis
3. **Response**: Incident response and containment
4. **Recovery**: System restoration and lessons learned

### Team Coordination
- **Daily Standup**: Brief status update (5 minutes)
- **Weekly Review**: Progress assessment and planning
- **Incident Response**: Immediate notification for security events
- **Documentation**: All activities must be documented

---

## Communication Protocols

### Escalation Procedures
1. **Level 1**: Team member identifies issue
2. **Level 2**: Team lead involvement required
3. **Level 3**: Full team response activation
4. **Level 4**: External support or management notification

### Reporting Structure
- **Daily Reports**: Status updates via team chat
- **Weekly Reports**: Progress summary and metrics
- **Incident Reports**: Immediate documentation of security events
- **Monthly Reviews**: Comprehensive project assessment

---

## Security Guidelines

### Access Control
- **SSH Keys**: Never commit to repository
- **Credentials**: Store securely, rotate regularly
- **Permissions**: Principle of least privilege
- **Monitoring**: Log all access attempts

### Testing Procedures
- **Isolation**: All testing in controlled environment
- **Documentation**: Record all test procedures
- **Safety**: No production systems affected
- **Ethics**: Follow responsible disclosure practices

---

## Project Deliverables

### Completed
- Infrastructure deployment and configuration
- Security group implementation and testing
- Advanced testing environment setup
- Vulnerability assessment procedures

### In Progress
- Team role definition and procedures
- Standard operating procedures
- Communication protocols

### Planned
- Monitoring and alerting setup
- Advanced attack scenarios
- Blue team response procedures
- Final project documentation

---

## Contact Information

### Emergency Contacts
- **Security Incident**: Immediate team notification
- **Infrastructure Issue**: Fausto Rosado (primary)
- **Testing Issues**: Zeinab Ali (Red Team)
- **Defense Issues**: Latrisha Dodson (Blue Team)

### Communication Channels
- **Primary**: Team collaboration platform
- **Emergency**: Direct phone contact
- **Documentation**: Shared project repository
- **Updates**: Weekly team meetings

---

## Notes

- All sensitive information kept local only
- No credentials or keys in repository
- Regular security assessments required
- Continuous improvement process active
- Team training and skill development ongoing

**Document Version**: 1.0  
**Next Review**: September 5, 2025  
**Team Approval**: Pending
