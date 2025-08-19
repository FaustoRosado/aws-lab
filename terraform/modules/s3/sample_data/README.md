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
├── threats/               # Security threat examples
│   └── malware_indicators.json # Sample malware data
├── logs/                  # Sample log files
│   ├── web_access.log     # Web server access logs
│   ├── security.log       # Security event logs
│   └── system.log         # System activity logs
├── documents/             # Sample documents
│   ├── report.pdf         # Sample PDF document
│   ├── data.csv           # Sample CSV data file
│   └── config.yaml        # Sample configuration file
└── templates/             # Reusable templates
    ├── threat_report.md   # Threat report template
    └── log_analysis.md    # Log analysis template
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

### Use Cases

- **GuardDuty Testing** - Test threat detection capabilities
- **Security Analysis** - Practice analyzing threat data
- **Tool Integration** - Test security tool integrations
- **Training Scenarios** - Create realistic security exercises

---

## Log Sample Files

### Web Access Logs (`logs/web_access.log`)

Sample web server access logs for analysis training:

```log
192.168.1.100 - - [01/Jan/2024:10:00:00 +0000] "GET / HTTP/1.1" 200 2326
192.168.1.101 - - [01/Jan/2024:10:00:01 +0000] "GET /admin HTTP/1.1" 403 1234
192.168.1.102 - - [01/Jan/2024:10:00:02 +0000] "POST /login HTTP/1.1" 200 567
```

### Security Event Logs (`logs/security.log`)

Sample security event logs for monitoring practice:

```log
[2024-01-01 10:00:00] SECURITY: Failed login attempt from 192.168.1.100
[2024-01-01 10:00:01] SECURITY: User admin logged in from 192.168.1.101
[2024-01-01 10:00:02] SECURITY: File access denied: /etc/passwd
```

### System Activity Logs (`logs/system.log`)

Sample system activity logs for analysis:

```log
Jan 1 10:00:00 server1 kernel: CPU temperature above threshold
Jan 1 10:00:01 server1 systemd: Started Apache Web Server
Jan 1 10:00:02 server1 sshd: Accepted password for user from 192.168.1.100
```

---

## Document Samples

### Sample Reports (`documents/report.pdf`)

Example PDF documents for testing file processing:

- **Security Assessment Reports** - Sample security findings
- **Compliance Documents** - Example compliance reports
- **Technical Documentation** - Sample technical guides

### Data Files (`documents/data.csv`)

Sample CSV data for analysis practice:

```csv
timestamp,ip_address,user_agent,status_code,response_time
2024-01-01 10:00:00,192.168.1.100,Mozilla/5.0,200,150
2024-01-01 10:00:01,192.168.1.101,Chrome/91.0,404,200
2024-01-01 10:00:02,192.168.1.102,Safari/14.0,200,120
```

### Configuration Files (`documents/config.yaml`)

Sample configuration files for testing:

```yaml
application:
  name: "Sample Security App"
  version: "1.0.0"
  environment: "development"

security:
  enabled: true
  log_level: "info"
  max_attempts: 3
```

---

## How to Use Sample Data

### Testing Security Tools

1. **Upload to S3** - Use sample data to test S3 functionality
2. **Process with Lambda** - Test data processing workflows
3. **Analyze with Athena** - Practice SQL queries on sample data
4. **Monitor with CloudWatch** - Test log monitoring and alerting

### Learning and Training

1. **Security Analysis** - Practice analyzing threat indicators
2. **Log Analysis** - Learn to read and interpret log files
3. **Data Processing** - Practice working with different file formats
4. **Tool Integration** - Test how different AWS services work together

### Development and Testing

1. **Application Testing** - Test applications with realistic data
2. **API Development** - Develop APIs that process sample data
3. **Workflow Testing** - Test data processing pipelines
4. **Performance Testing** - Test system performance with sample data

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

### Add New Data Types

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

### Create Custom Log Formats

```bash
# Generate custom log entries
for i in {1..10}; do
  echo "$(date): Sample log entry $i" >> logs/custom.log
done
```

### Add Different File Types

```bash
# Create sample files of various types
echo "Sample text content" > documents/sample.txt
echo '{"key": "value"}' > documents/sample.json
echo "Sample XML content" > documents/sample.xml
```

---

## Integration with AWS Services

### S3 Integration

- **Bucket Organization** - Organize sample data by type and purpose
- **Access Control** - Control who can access sample data
- **Versioning** - Track changes to sample data over time
- **Lifecycle Policies** - Automate data management

### Lambda Functions

- **Data Processing** - Process sample data with serverless functions
- **Format Conversion** - Convert between different data formats
- **Validation** - Validate sample data structure and content
- **Enrichment** - Add additional context to sample data

### CloudWatch

- **Log Monitoring** - Monitor sample log files for patterns
- **Metrics** - Create metrics from sample data
- **Alarms** - Set up alerts based on sample data analysis
- **Dashboards** - Visualize sample data trends

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
