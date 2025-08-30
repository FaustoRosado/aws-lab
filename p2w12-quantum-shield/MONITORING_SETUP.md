# CloudWatch Monitoring Setup - P2W12 Lab
## Quantum Shield Cyber Range Monitoring Configuration

**Project**: P2W12 Advanced Cybersecurity Lab  
**Setup Date**: August 29, 2025  
**Status**: Partially Complete  
**Team**: Shannon Kelly, Fausto Rosado, Zeinab Ali, Latrisha Dodson, Javier Acosta

---

## Current Status

### Completed Components
- **CloudWatch Agent**: Installed on Kali machine (v1.300057.2-1.amzn2)
- **Basic Configuration**: Basic metrics collection configured
- **Service Setup**: Agent service configured and ready
- **Local Monitoring**: System resource monitoring available

### Pending Components
- **AWS Integration**: IAM role and instance profile setup
- **Log Collection**: CloudWatch Logs integration
- **Metrics Dashboard**: CloudWatch dashboard creation
- **Alarms**: Automated alerting configuration

---

## Monitoring Capabilities

### Local Monitoring (Available Now)
1. **System Metrics**: CPU, memory, disk usage
2. **Network Stats**: TCP connections, network traffic
3. **Process Monitoring**: Running processes and resource usage
4. **Log Analysis**: Local log file monitoring
5. **Security Events**: SSH access logs, web server logs

### AWS Integration (Pending)
1. **CloudWatch Metrics**: Centralized metric collection
2. **CloudWatch Logs**: Centralized log management
3. **CloudWatch Alarms**: Automated alerting
4. **CloudWatch Dashboards**: Visual monitoring interface

---

## Setup Instructions

### Step 1: Create IAM Role
```bash
# Create IAM role with CloudWatch permissions
aws iam create-role \
  --role-name CloudWatchAgentRole \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }]
  }'

# Attach CloudWatch policy
aws iam attach-role-policy \
  --role-name CloudWatchAgentRole \
  --policy-arn arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy
```

### Step 2: Create Instance Profile
```bash
# Create instance profile
aws iam create-instance-profile \
  --instance-profile-name CloudWatchAgentInstanceProfile

# Add role to instance profile
aws iam add-role-to-instance-profile \
  --instance-profile-name CloudWatchAgentInstanceProfile \
  --role-name CloudWatchAgentRole
```

### Step 3: Attach to EC2 Instances
```bash
# Attach instance profile to Kali machine
aws ec2 associate-iam-instance-profile \
  --instance-id i-01ae96cd278c3eab8 \
  --iam-instance-profile Name=CloudWatchAgentInstanceProfile

# Attach instance profile to target machine
aws ec2 associate-iam-instance-profile \
  --instance-id i-0571cebc7db367dc5 \
  --iam-instance-profile Name=CloudWatchAgentInstanceProfile
```

### Step 4: Start CloudWatch Agent
```bash
# Start the agent on Kali machine
sudo systemctl start amazon-cloudwatch-agent
sudo systemctl enable amazon-cloudwatch-agent

# Verify status
sudo systemctl status amazon-cloudwatch-agent
```

---

## Monitoring Configuration

### Metrics Collection
- **CPU**: Usage per core, idle time, system/user time
- **Memory**: Used percentage, swap usage
- **Disk**: Used percentage, I/O statistics
- **Network**: Bytes sent/received, packet statistics
- **Processes**: TCP connections, established connections

### Log Collection
- **Security Logs**: /var/log/secure (SSH access)
- **Web Server**: /var/log/httpd/access_log, /var/log/httpd/error_log
- **System Logs**: /var/log/messages
- **Application Logs**: Custom application logs

### Collection Intervals
- **Metrics**: 60 seconds (configurable)
- **Logs**: Real-time collection
- **Alarms**: 5-minute evaluation period

---

## Security Considerations

### IAM Permissions
- **Least Privilege**: Only necessary CloudWatch permissions
- **Resource Scoping**: Limit to specific log groups and metrics
- **Access Monitoring**: CloudTrail logging for all API calls

### Data Protection
- **Encryption**: TLS encryption in transit
- **Access Control**: IAM-based access management
- **Audit Logging**: Comprehensive access logging

---

## Troubleshooting

### Common Issues
1. **Agent Not Starting**: Check IAM role permissions
2. **No Metrics**: Verify agent configuration
3. **Log Collection Failures**: Check file permissions
4. **High Resource Usage**: Adjust collection intervals

### Debug Commands
```bash
# Check agent status
sudo systemctl status amazon-cloudwatch-agent

# View agent logs
sudo tail -f /var/log/amazon/amazon-cloudwatch-agent/amazon-cloudwatch-agent.log

# Test configuration
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s

# Manual start
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start
```

---

## Next Steps

### Immediate Actions
1. **Create IAM Role**: Set up CloudWatch permissions
2. **Attach to Instances**: Associate IAM role with EC2 instances
3. **Start Agent**: Activate CloudWatch monitoring
4. **Verify Collection**: Confirm metrics and logs are being collected

### Short Term Goals
1. **Create Dashboards**: Visual monitoring interface
2. **Set Up Alarms**: Automated alerting for security events
3. **Configure Log Groups**: Organize log collection
4. **Performance Tuning**: Optimize collection intervals

### Long Term Goals
1. **Advanced Analytics**: Machine learning for anomaly detection
2. **Integration**: Connect with other AWS security services
3. **Automation**: Automated response to security events
4. **Compliance**: Meet security and audit requirements

---

## Cost Considerations

### CloudWatch Pricing
- **Metrics**: First 10 custom metrics free per month
- **Logs**: First 5GB ingested free per month
- **Alarms**: First 10 alarm metrics free per month
- **Dashboards**: $3 per dashboard per month

### Optimization Strategies
- **Metric Filtering**: Collect only necessary metrics
- **Log Retention**: Set appropriate retention periods
- **Alarm Optimization**: Use composite alarms where possible
- **Resource Monitoring**: Monitor CloudWatch costs

---

## References

- **AWS CloudWatch Agent**: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html
- **IAM Best Practices**: https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html
- **CloudWatch Pricing**: https://aws.amazon.com/cloudwatch/pricing/
- **Security Best Practices**: https://aws.amazon.com/security/security-learning/

---

**Document Version**: 1.0  
**Setup Date**: August 29, 2025  
**Next Review**: September 5, 2025  
**Team Approval**: Pending
