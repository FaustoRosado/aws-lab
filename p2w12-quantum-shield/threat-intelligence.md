# Threat Intelligence Integration - P2W12 Lab
## Quantum Shield Cyber Range Threat Detection

**Project**: P2W12 Advanced Cybersecurity Lab  
**Implementation Date**: August 29, 2025  
**Status**: Ready for Implementation  
**Team**: Shannon Kelly, Fausto Rosado, Zeinab Ali, Latrisha Dodson, Javier Acosta

---

## **Threat Intelligence Sources**

### **Free Threat Feeds**
1. **AbuseIPDB**: Known malicious IP addresses
2. **URLhaus**: Malicious URL database
3. **PhishTank**: Phishing website database
4. **OpenPhish**: Phishing URL repository
5. **MalwareBazaar**: Malware sample database

### **Custom Threat Indicators**
1. **Lab-Specific Threats**: Known attack patterns from our environment
2. **Behavioral Patterns**: Anomaly detection based on normal operations
3. **Network Signatures**: Suspicious traffic patterns
4. **Process Signatures**: Known malicious process names

---

## **Threat Detection Rules**

### **Network-Based Detection**
```yaml
# Suspicious Network Activity
- name: "Port Scanning Detection"
  condition: "Multiple connection attempts to different ports from single source"
  threshold: "5 ports in 60 seconds"
  action: "Alert and log source IP"

- name: "DDoS Detection"
  condition: "High volume of requests from single source"
  threshold: "100 requests per minute"
  action: "Block source IP temporarily"

- name: "Lateral Movement Detection"
  condition: "SSH connections between instances"
  threshold: "Any unauthorized SSH connection"
  action: "Immediate alert and connection termination"
```

### **Host-Based Detection**
```yaml
# Suspicious Process Activity
- name: "Penetration Testing Tools"
  condition: "Execution of known pentest tools"
  threshold: "Any execution of nmap, hydra, john, etc."
  action: "Log and alert (expected in lab environment)"

- name: "Privilege Escalation"
  condition: "Multiple sudo/su attempts"
  threshold: "10 attempts in 5 minutes"
  action: "Alert and investigate"

- name: "File System Changes"
  condition: "Modification of critical system files"
  threshold: "Any change to /etc/passwd, /etc/shadow"
  action: "Immediate alert and file integrity check"
```

### **Application-Based Detection**
```yaml
# Web Application Attacks
- name: "SQL Injection Attempts"
  condition: "SQL keywords in web requests"
  threshold: "Any attempt with UNION, SELECT, INSERT"
  action: "Log and alert"

- name: "Cross-Site Scripting"
  condition: "Script tags in web requests"
  threshold: "Any attempt with <script>, javascript:"
  action: "Log and alert"

- name: "Command Injection"
  condition: "OS commands in web requests"
  threshold: "Any attempt with ;, |, &&, ||"
  action: "Log and alert"
```

---

## **Threat Scoring System**

### **Risk Levels**
1. **Low (1-3)**: Informational events, expected behavior
2. **Medium (4-6)**: Suspicious activity, investigation required
3. **High (7-8)**: Potential security threat, immediate attention
4. **Critical (9-10)**: Active security incident, emergency response

### **Scoring Factors**
- **Source Reputation**: Known malicious IPs, domains
- **Attack Sophistication**: Complexity of attack technique
- **Target Sensitivity**: Criticality of targeted resources
- **Attack Volume**: Number of attempts, frequency
- **Historical Context**: Previous similar attacks

---

## **🔧 Implementation Components**

### **Threat Feed Integration**
```bash
#!/bin/bash
# Threat Intelligence Feed Updater

# Update AbuseIPDB blocklist
curl -s "https://api.abuseipdb.com/api/v2/blacklist" \
  -H "Key: YOUR_API_KEY" \
  -H "Accept: application/json" \
  -d "confidenceMinimum=90" > /tmp/abuseipdb_blacklist.json

# Update URLhaus malicious URLs
curl -s "https://urlhaus.abuse.ch/downloads/csv_recent/" > /tmp/urlhaus_recent.csv

# Update PhishTank phishing URLs
curl -s "https://data.phishtank.com/data/online-valid.json" > /tmp/phishing_urls.json

# Process and integrate threat data
python3 /usr/local/bin/process_threat_feeds.py
```

### **Custom Threat Detection Scripts**
```python
#!/usr/bin/env python3
# Custom Threat Detection Engine

import json
import re
import requests
from datetime import datetime, timedelta

class ThreatDetector:
    def __init__(self):
        self.threat_patterns = self.load_threat_patterns()
        self.whitelist = self.load_whitelist()
        
    def load_threat_patterns(self):
        return {
            'sql_injection': [
                r'union\s+select',
                r'insert\s+into',
                r'drop\s+table',
                r'exec\s*\(',
                r'xp_cmdshell'
            ],
            'xss': [
                r'<script[^>]*>',
                r'javascript:',
                r'onload\s*=',
                r'onerror\s*='
            ],
            'command_injection': [
                r';\s*\w+',
                r'\|\s*\w+',
                r'&&\s*\w+',
                r'\|\|\s*\w+'
            ]
        }
    
    def analyze_request(self, request_data):
        threats = []
        
        for threat_type, patterns in self.threat_patterns.items():
            for pattern in patterns:
                if re.search(pattern, request_data, re.IGNORECASE):
                    threats.append({
                        'type': threat_type,
                        'pattern': pattern,
                        'timestamp': datetime.now().isoformat(),
                        'risk_level': self.calculate_risk_level(threat_type)
                    })
        
        return threats
    
    def calculate_risk_level(self, threat_type):
        risk_levels = {
            'sql_injection': 8,
            'xss': 6,
            'command_injection': 9
        }
        return risk_levels.get(threat_type, 5)
    
    def generate_alert(self, threat):
        alert = {
            'timestamp': threat['timestamp'],
            'threat_type': threat['type'],
            'risk_level': threat['risk_level'],
            'description': f"{threat['type'].upper()} attempt detected",
            'recommendation': self.get_recommendation(threat['type'])
        }
        return alert
    
    def get_recommendation(self, threat_type):
        recommendations = {
            'sql_injection': 'Implement parameterized queries and input validation',
            'xss': 'Implement output encoding and Content Security Policy',
            'command_injection': 'Implement strict input validation and command allowlisting'
        }
        return recommendations.get(threat_type, 'Investigate and implement appropriate controls')

# Usage example
detector = ThreatDetector()
threats = detector.analyze_request("user=admin' UNION SELECT * FROM users--")
for threat in threats:
    alert = detector.generate_alert(threat)
    print(json.dumps(alert, indent=2))
```

---

## **📈 Threat Response Automation**

### **Automated Actions**
1. **Immediate Response**: Block IP, terminate connection
2. **Alert Generation**: Create security incident ticket
3. **Log Enrichment**: Add threat intelligence context
4. **Response Playbook**: Execute predefined response procedures

### **Response Workflows**
```yaml
# High-Risk Threat Response
- trigger: "Risk level >= 8"
  actions:
    - "Generate critical alert"
    - "Block source IP/domain"
    - "Create incident ticket"
    - "Notify security team"
    - "Initiate response playbook"

# Medium-Risk Threat Response
- trigger: "Risk level 4-7"
  actions:
    - "Generate warning alert"
    - "Log detailed information"
    - "Monitor for escalation"
    - "Schedule investigation"

# Low-Risk Threat Response
- trigger: "Risk level 1-3"
  actions:
    - "Log event"
    - "Add to watchlist"
    - "Monitor trends"
```

---

## **Integration with AWS Services**

### **CloudWatch Integration**
- **Custom Metrics**: Threat detection events and risk scores
- **Log Processing**: Real-time log analysis and correlation
- **Alarms**: Automated alerting based on threat thresholds

### **Lambda Functions**
- **Threat Analysis**: Process and analyze security events
- **Response Automation**: Execute automated response actions
- **Feed Updates**: Update threat intelligence feeds

### **S3 Integration**
- **Threat Data Storage**: Store threat intelligence feeds
- **Log Archival**: Long-term security log storage
- **Data Lake**: Security analytics and machine learning

---

## **Implementation Checklist**

### **Phase 1: Basic Threat Detection**
- [ ] Deploy custom security monitoring scripts
- [ ] Configure CloudWatch log analysis
- [ ] Set up basic alerting rules
- [ ] Implement threat scoring system

### **Phase 2: Threat Intelligence Integration**
- [ ] Integrate external threat feeds
- [ ] Create custom threat detection rules
- [ ] Implement automated response actions
- [ ] Set up threat data storage

### **Phase 3: Advanced Analytics**
- [ ] Deploy machine learning models
- [ ] Implement behavioral analysis
- [ ] Create predictive threat detection
- [ ] Set up advanced response automation

---

## **Cost Considerations**

### **Free Services**
- **Custom Scripts**: No additional cost
- **CloudWatch Basic**: Included in free tier
- **Lambda**: 1M requests/month free
- **S3**: 5GB storage free

### **Premium Services**
- **GuardDuty**: $4.00 per 1M events
- **Security Hub**: $0.30 per finding
- **Machine Learning**: Pay-per-use pricing
- **Advanced Analytics**: Custom pricing

---

## **References**

- **MITRE ATT&CK**: https://attack.mitre.org/
- **OWASP Top 10**: https://owasp.org/www-project-top-ten/
- **AbuseIPDB API**: https://docs.abuseipdb.com/
- **URLhaus**: https://urlhaus.abuse.ch/
- **PhishTank**: https://www.phishtank.com/

---

**Document Version**: 1.0  
**Implementation Date**: August 29, 2025  
**Next Review**: September 5, 2025  
**Team Approval**: Pending
