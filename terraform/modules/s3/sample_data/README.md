# Sample Data - Testing and Learning Materials

## What is Sample Data?

**Sample Data** consists of **example files and datasets** that help you test, learn, and demonstrate the capabilities of your AWS environment. Think of it as **practice materials** that give you realistic data to work with when learning about security tools, data analysis, and AWS services.

### Real-World Analogy

- **Sample Data** = Practice materials for learning and testing
- **Threat Indicators** = Examples of security threats to detect
- **Log Samples** = Sample log files for analysis training
- **Test Files** = Files to practice uploading and processing
- **Documentation** = Examples and templates for your projects

---

## What This Folder Contains

This folder provides **comprehensive testing materials** for your security lab:

- **Threat Data** - Sample malware indicators and security threats
- **Log Samples** - Example log files for analysis training
- **Test Files** - Various file types for testing S3 functionality
- **Documentation** - Templates and examples for your projects
- **Security Scenarios** - Realistic security testing scenarios

---

## Folder Structure

```
sample_data/
├── README.md              # This documentation file
└── threats/               # Security threat examples
    ├── malware_indicators.json    # Sample malware data
    ├── ip_blacklist.txt           # Sample malicious IP addresses
    ├── domain_blacklist.txt       # Sample malicious domains
    └── compromise_artifacts.json  # Sample compromise indicators
```

---

## Threat Data Examples

### Malware Indicators (`threats/malware_indicators.json`)

This file contains **sample threat intelligence data** for testing security tools:

```json
{
  "threats": [
    {
      "id": "THREAT-001",
      "type": "malware",
      "name": "Sample Ransomware",
      "indicators": [
        "192.168.1.100",
        "malware.example.com",
        "5f4dcc3b5aa765d61d8327deb882cf99"
      ],
      "severity": "high",
      "description": "Sample ransomware threat for testing"
    },
    {
      "id": "THREAT-002",
      "type": "phishing",
      "name": "Sample Phishing Campaign",
      "indicators": [
        "phishing.example.com",
        "fake-login.example.org"
      ],
      "severity": "medium",
      "description": "Sample phishing threat for testing"
    }
  ]
}
```

### IP Blacklist (`threats/ip_blacklist.txt`)

This file contains **sample malicious IP addresses** for testing network security tools:

```txt
# IP Blacklist for lab Environment
# Sample malicious IPs for security testing purposes
# DO NOT USE IN PRODUCTION

192.168.1.100
10.0.0.50
172.16.0.25
198.51.100.10
203.0.113.5
```

**Use Cases:**
- **GuardDuty Testing** - Test IP-based threat detection
- **Network Security** - Practice blocking malicious IPs
- **Firewall Rules** - Test security group configurations
- **Threat Intelligence** - Practice with realistic threat data

### Domain Blacklist (`threats/domain_blacklist.txt`)

This file contains **sample malicious domains** for testing DNS security:

```txt
# Domain Blacklist for lab Environment
# Sample malicious domains for security testing purposes
# DO NOT USE IN PRODUCTION

malicious.example.com
evil.test.net
phishing.lab.org
c2server.fake.io
badactor.demo.co
```

**Use Cases:**
- **DNS Security** - Test domain-based threat detection
- **Web Filtering** - Practice blocking malicious domains
- **GuardDuty Testing** - Test domain-based findings
- **Security Analysis** - Practice analyzing domain threats

### Compromise Artifacts (`threats/compromise_artifacts.json`)

This file contains **sample compromise indicators** for testing incident response:

```json
{
  "environment": "lab",
  "threat_type": "compromise_artifacts",
  "description": "Sample compromise artifacts for security testing and training purposes",
  "artifacts": [
    {
      "type": "file_path",
      "value": "/tmp/malicious_script.sh",
      "confidence": "high",
      "description": "Suspicious script in temp directory"
    },
    {
      "type": "registry_key",
      "value": "HKLM\\Software\\Microsoft\\Windows\\CurrentVersion\\Run\\Malware",
      "confidence": "high",
      "description": "Persistence mechanism in registry"
    }
  ]
}
```

**Use Cases:**
- **Incident Response** - Practice analyzing compromise indicators
- **Forensics** - Test artifact analysis workflows
- **Security Monitoring** - Practice detecting suspicious activities
- **Threat Hunting** - Test proactive threat detection

### Use Cases

- **GuardDuty Testing** - Test threat detection capabilities
- **Security Analysis** - Practice analyzing threat data
- **Tool Integration** - Test security tool integrations
- **Training Scenarios** - Create realistic security exercises

---

## Threat Intelligence Files

The threat intelligence files provide realistic security testing data for your lab environment. These files are automatically uploaded to your S3 bucket and can be used with GuardDuty, Security Hub, and other AWS security services.

---

## File Format Examples

The sample data files demonstrate different formats commonly used in security operations:

- **JSON Files** - Structured threat intelligence data
- **Text Files** - Simple lists and configurations
- **Templates** - Reusable data structures for your projects

---

## How to Use Sample Data

### Testing Security Tools

1. **GuardDuty Integration** - Use threat intelligence files to test threat detection
2. **Security Hub Testing** - Test finding aggregation with sample threat data
3. **S3 Security** - Test bucket policies and access controls
4. **Threat Intelligence** - Practice with realistic security indicators

### Learning and Training

1. **Threat Intelligence** - Practice analyzing threat indicators and artifacts
2. **Security Analysis** - Learn to identify and classify security threats
3. **Data Formats** - Practice working with JSON and text-based threat data
4. **Security Tool Integration** - Test how GuardDuty and Security Hub work together

### Development and Testing

1. **Security Workflows** - Test incident response and threat hunting workflows
2. **API Development** - Develop security APIs that process threat intelligence
3. **Automation Testing** - Test automated threat detection and response
4. **Integration Testing** - Test security service integrations

---

## Security Considerations

### Data Classification

- **Public Data** - Safe to share and use in demonstrations
- **Sample Data** - Realistic but not sensitive information
- **Test Data** - Generated data for testing purposes
- **No Real Data** - Never use actual production or sensitive data

### Best Practices

- **Use Sample Data Only** - Never use real production data
- **Sanitize Information** - Remove any potentially sensitive details
- **Regular Updates** - Keep sample data current and relevant
- **Documentation** - Clearly label all sample data files

---

## Customizing Sample Data

### Add New Threat Types

```bash
# Create new threat indicators
cat > threats/new_threats.json << EOF
{
  "threats": [
    {
      "id": "THREAT-003",
      "type": "ddos",
      "name": "Sample DDoS Attack",
      "indicators": ["10.0.0.1", "10.0.0.2"],
      "severity": "critical"
    }
  ]
}
EOF
```

### Create Custom IP Lists

```bash
# Generate custom IP blacklists
echo "192.168.1.200" >> threats/ip_blacklist.txt
echo "10.0.0.100" >> threats/ip_blacklist.txt
```

### Add Different Threat Formats

```bash
# Create sample files of various types
echo "malware.example.org" >> threats/domain_blacklist.txt
echo '{"type": "new_threat", "value": "test"}' > threats/custom_threats.json
```

---

## Integration with AWS Services

### S3 Integration

- **Bucket Organization** - Organize threat intelligence by type and purpose
- **Access Control** - Control who can access threat intelligence data
- **Versioning** - Track changes to threat intelligence over time
- **Lifecycle Policies** - Automate threat data management

### GuardDuty Integration

- **Threat Detection** - Use threat intelligence files to test detection capabilities
- **IP Sets** - Test IP-based threat detection with blacklist files
- **Threat Intel Sets** - Test domain and artifact-based detection
- **Finding Generation** - Generate realistic security findings for testing

### Security Hub Integration

- **Finding Aggregation** - Aggregate findings from multiple security services
- **Threat Intelligence** - Correlate findings with threat intelligence data
- **Security Monitoring** - Monitor security posture with realistic data
- **Incident Response** - Practice incident response with sample threats

---

## Next Steps

1. **Explore the sample data** to understand what's available
2. **Upload to S3** to test storage and access
3. **Process with AWS services** to learn data workflows
4. **Create your own samples** for specific use cases
5. **Integrate with security tools** for realistic testing

---

## Related Documentation

- **S3 Module README** - Learn about S3 storage and management
- **GuardDuty Module README** - Understand threat detection
- **Security Hub Module README** - Learn about security monitoring
- **AWS Documentation** - Official AWS service documentation

---

<div align="center">
  <p><em>Your testing materials are ready!</em></p>
</div>
