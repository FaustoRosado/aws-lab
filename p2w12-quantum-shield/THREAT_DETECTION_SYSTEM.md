# Advanced Threat Detection System - P2W12 Lab
## Quantum Shield Cyber Range Security Monitoring

**Project**: P2W12 Advanced Cybersecurity Lab  
**Implementation Date**: August 29, 2025  
**Status**: Ready for Implementation  
**Team**: Shannon Kelly, Fausto Rosado, Zeinab Ali, Latrisha Dodson, Javier Acosta

---

## **Threat Detection Architecture**

### **Multi-Layer Security Approach**
1. **Network Layer**: VPC Flow Logs, Security Groups, Network ACLs
2. **Host Layer**: CloudWatch Agent, Custom Security Scripts
3. **Application Layer**: Web Application Firewall, Log Analysis
4. **Behavioral Layer**: Anomaly Detection, Pattern Recognition

---

## **Available Threat Detection Services**

### **Free Tier Available**
- **CloudWatch Logs**: Centralized log collection and analysis
- **CloudWatch Metrics**: System and application monitoring
- **VPC Flow Logs**: Network traffic analysis
- **Security Groups**: Network access control
- **IAM Access Analyzer**: Permission analysis
- **CloudTrail**: API call logging (free tier)

### **Premium Services (Documented)**
- **Amazon GuardDuty**: Intelligent threat detection
- **AWS Security Hub**: Centralized security findings
- **AWS WAF**: Web application firewall
- **Amazon Macie**: Data discovery and classification

---

## **Implementation Plan**

### **Phase 1: Network Traffic Analysis**
1. **Enable VPC Flow Logs** for comprehensive network monitoring
2. **Create Security Group Rules** for traffic pattern analysis
3. **Implement Network ACLs** with logging capabilities
4. **Set up Traffic Mirroring** for deep packet inspection

### **Phase 2: Host-Based Detection**
1. **Enhanced CloudWatch Agent** with security metrics
2. **Custom Security Scripts** for real-time monitoring
3. **File Integrity Monitoring** for critical system files
4. **Process Monitoring** for suspicious activities

### **Phase 3: Application Security**
1. **Web Application Firewall** implementation
2. **Log Analysis** for attack patterns
3. **Rate Limiting** and DDoS protection
4. **Input Validation** monitoring

### **Phase 4: Behavioral Analysis**
1. **Anomaly Detection** algorithms
2. **Pattern Recognition** for known attack signatures
3. **Machine Learning** models for threat classification
4. **Automated Response** mechanisms

---

## **Threat Detection Capabilities**

### **Real-Time Monitoring**
- **Network Traffic**: All VPC traffic analysis
- **System Resources**: CPU, memory, disk, network usage
- **User Activity**: SSH access, file modifications, process creation
- **Application Logs**: Web server, database, custom application logs

### **Threat Intelligence**
- **Known Attack Patterns**: SQL injection, XSS, command injection
- **Behavioral Anomalies**: Unusual resource usage, access patterns
- **Network Anomalies**: Port scanning, DDoS attempts, lateral movement
- **File System Changes**: Critical file modifications, new file creation

### **Automated Response**
- **Alert Generation**: Real-time security notifications
- **Log Correlation**: Cross-reference multiple data sources
- **Incident Documentation**: Automated incident report generation
- **Response Playbooks**: Guided incident response procedures

---

## **🔧 Technical Implementation**

### **VPC Flow Logs Configuration**
```bash
# Enable VPC Flow Logs
aws ec2 create-flow-logs \
  --resource-type VPC \
  --resource-ids vpc-xxxxxxxxx \
  --traffic-type ALL \
  --log-destination-type cloud-watch-logs \
  --log-group-name /aws/vpc/flow-logs \
  --log-format "$${version} $${account-id} $${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status}"
```

### **Enhanced CloudWatch Agent**
```json
{
  "agent": {
    "metrics_collection_interval": 30,
    "run_as_user": "cwagent"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/secure",
            "log_group_name": "/aws/ec2/security/ssh-access",
            "log_stream_name": "{instance_id}",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/httpd/access_log",
            "log_group_name": "/aws/ec2/security/web-access",
            "log_stream_name": "{instance_id}",
            "timezone": "UTC"
          },
          {
            "file_path": "/var/log/messages",
            "log_group_name": "/aws/ec2/security/system-logs",
            "log_stream_name": "{instance_id}",
            "timezone": "UTC"
          }
        ]
      }
    }
  },
  "metrics": {
    "metrics_collected": {
      "cpu": {
        "measurement": ["cpu_usage_idle", "cpu_usage_user", "cpu_usage_system"],
        "metrics_collection_interval": 30
      },
      "disk": {
        "measurement": ["used_percent"],
        "metrics_collection_interval": 30
      },
      "mem": {
        "measurement": ["mem_used_percent"],
        "metrics_collection_interval": 30
      },
      "net": {
        "measurement": ["bytes_sent", "bytes_recv", "packets_sent", "packets_recv"],
        "metrics_collection_interval": 30
      }
    }
  }
}
```

### **Custom Security Monitoring Scripts**
```bash
#!/bin/bash
# Security Monitoring Script

# Monitor for suspicious SSH connections
ssh_connections=$(netstat -an | grep :22 | grep ESTABLISHED | wc -l)
if [ $ssh_connections -gt 5 ]; then
    echo "WARNING: High number of SSH connections detected: $ssh_connections"
fi

# Monitor for failed login attempts
failed_logins=$(grep "Failed password" /var/log/secure | wc -l)
if [ $failed_logins -gt 10 ]; then
    echo "WARNING: High number of failed login attempts: $failed_logins"
fi

# Monitor for unusual process creation
suspicious_processes=$(ps aux | grep -E "(nc|netcat|nmap|hydra)" | wc -l)
if [ $suspicious_processes -gt 0 ]; then
    echo "WARNING: Suspicious processes detected: $suspicious_processes"
fi
```

---

## **📈 Threat Detection Metrics**

### **Key Performance Indicators**
- **Detection Rate**: Percentage of threats detected
- **False Positive Rate**: Incorrect threat alerts
- **Response Time**: Time from detection to response
- **Coverage**: Percentage of infrastructure monitored

### **Security Metrics Dashboard**
- **Network Security**: Traffic analysis, connection monitoring
- **Host Security**: System integrity, process monitoring
- **Application Security**: Web attacks, input validation
- **User Security**: Access patterns, authentication failures

---

## **Threat Response Procedures**

### **Incident Classification**
1. **Low Risk**: Minor security events, informational alerts
2. **Medium Risk**: Potential security threats, investigation required
3. **High Risk**: Active security incidents, immediate response needed
4. **Critical Risk**: Severe security breaches, emergency response

### **Response Workflow**
1. **Detection**: Automated threat identification
2. **Analysis**: Threat assessment and classification
3. **Response**: Immediate containment and mitigation
4. **Recovery**: System restoration and security hardening
5. **Lessons Learned**: Post-incident analysis and improvement

---

## **Security Hardening**

### **Network Security**
- **Microsegmentation**: Strict security group rules
- **Traffic Monitoring**: Comprehensive flow logging
- **Access Control**: Principle of least privilege
- **Encryption**: TLS/SSL for all communications

### **Host Security**
- **System Updates**: Regular security patches
- **File Integrity**: Critical file monitoring
- **Process Control**: Restricted process execution
- **User Management**: Strict access controls

### **Application Security**
- **Input Validation**: Comprehensive input sanitization
- **Output Encoding**: XSS prevention
- **Authentication**: Multi-factor authentication
- **Session Management**: Secure session handling

---

## **Implementation Checklist**

### **Phase 1: Network Monitoring**
- [ ] Enable VPC Flow Logs
- [ ] Configure Security Group logging
- [ ] Set up Network ACL monitoring
- [ ] Implement traffic analysis

### **Phase 2: Host Monitoring**
- [ ] Deploy enhanced CloudWatch agent
- [ ] Install custom security scripts
- [ ] Configure file integrity monitoring
- [ ] Set up process monitoring

### **Phase 3: Application Security**
- [ ] Implement WAF rules
- [ ] Configure log analysis
- [ ] Set up rate limiting
- [ ] Enable input validation monitoring

### **Phase 4: Advanced Features**
- [ ] Deploy anomaly detection
- [ ] Configure automated response
- [ ] Set up threat intelligence feeds
- [ ] Implement machine learning models

---

## **Cost Considerations**

### **Free Tier Services**
- **CloudWatch Logs**: 5GB/month free
- **CloudWatch Metrics**: 10 custom metrics free
- **VPC Flow Logs**: Basic logging included
- **CloudTrail**: Management events free

### **Premium Services**
- **GuardDuty**: $4.00 per 1M events
- **Security Hub**: $0.30 per finding
- **WAF**: $0.60 per million requests
- **Macie**: $0.10 per GB analyzed

---

## **References**

- **AWS Security Best Practices**: https://aws.amazon.com/security/security-learning/
- **CloudWatch Monitoring**: https://docs.aws.amazon.com/AmazonCloudWatch/
- **VPC Flow Logs**: https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html
- **Security Monitoring**: https://aws.amazon.com/security/security-learning/

---

**Document Version**: 1.0  
**Implementation Date**: August 29, 2025  
**Next Review**: September 5, 2025  
**Team Approval**: Pending
