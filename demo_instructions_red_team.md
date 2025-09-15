# Red Team Demo Instructions

## Setup
- Target Web Server: `<PUBLIC_IP>` (get from Terraform output)
- Target DB Server: `<PRIVATE_IP>` (private, access via web server)

## Red Team Flow (3-4 minutes)

### 1. Basic Reconnaissance
```bash
TARGET="<PUBLIC_IP_FROM_TERRAFORM>"
echo "Scanning target: $TARGET"
```

**PAUSE: Tell students "We're starting with basic reconnaissance"**

```bash
# Quick port scan
nmap -sV -p 22,80,443 "$TARGET"
```

**PAUSE: Show students the nmap output - explain open ports**

### 2. Web Application Testing
```bash
# Check what's running
curl -s "http://$TARGET" | head -5
```

**PAUSE: "This shows we have a web application running"**

```bash
# Test for SQL injection
curl -s "http://$TARGET/?id=1' OR '1'='1" | head -3
```

**PAUSE: "We're testing for SQL injection vulnerabilities"**

### 3. Brute Force Simulation (if time permits)
```bash
# Simple login test
curl -s "http://$TARGET/login" -d "user=admin&pass=password" | head -3
```

**PAUSE: "This simulates a brute force attack attempt"**

## Key Points to Explain
- Each attack generates logs and potential alerts
- GuardDuty monitors network activity
- Security Hub aggregates findings
- CloudWatch captures application logs
