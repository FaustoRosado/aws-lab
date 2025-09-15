# Console Checkpoint Guide

## When to Direct Students to Console

### Checkpoint 1: After Infrastructure Deploy
**TIMING**: Right after `03_apply.sh` completes
**SAY**: "Students - refresh your EC2 console now"
**STUDENTS SEE**: 
- 2 new instances appearing
- Names: lab-public-web-server, lab-private-db-server
- States changing from "pending" to "running"

### Checkpoint 2: After Red Team Recon
**TIMING**: After nmap scan
**SAY**: "Go to GuardDuty in your console"
**STUDENTS SEE**:
- Detector enabled
- Possible new findings (may take 2-3 minutes)
- Finding types: Recon:EC2/Portscan

### Checkpoint 3: After Blue Team CLI Check
**TIMING**: After `04_verify_cli.sh`
**SAY**: "Refresh Security Hub in your console"
**STUDENTS SEE**:
- Enabled standards (CIS + AWS Foundational)
- Compliance findings
- Security score dashboard

### Checkpoint 4: VPC Tour
**TIMING**: During console tour phase
**SAY**: "Navigate to VPC in your console"
**STUDENTS SEE**:
- lab-vpc with 10.0.0.0/16 CIDR
- Public subnets (10.0.1.0/24, 10.0.2.0/24)
- Private subnets (10.0.10.0/24, 10.0.11.0/24)
- Route tables showing IGW vs NAT routing

### Checkpoint 5: Final Cleanup
**TIMING**: During `06_destroy.sh`
**SAY**: "Watch your EC2 console - instances terminating"
**STUDENTS SEE**:
- Instance states changing to "shutting-down"
- Resources disappearing
- Clean environment

## Console Navigation Tips for Students
- Use the search bar at top: type "EC2", "GuardDuty", etc.
- Refresh pages to see real-time changes
- Switch regions if needed (should be us-east-1)
- Read-only access means you can explore safely
