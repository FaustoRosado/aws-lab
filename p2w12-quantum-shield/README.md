# Quantum Shield Cyber Range - P2W12 Final Project

## Project Overview
This is a comprehensive cybersecurity training environment built on AWS using Terraform Infrastructure as Code. The lab provides a realistic cyber range for offensive and defensive security training, featuring a three-tiered network architecture with attack and target instances.

## Team Members
- **Lead Cloud Architect (Project Lead)**: Shannon Kelly
- **Infrastructure Engineer (Terraform & Automation)**: Fausto Rosado  
- **Red Team Engineer (Offensive Security)**: Zeinab Ali
- **Blue Team Engineer (Defensive Security)**: Latrisha Dodson
- **Documentation & Reporting Lead**: Javier Acosta

## Architecture Overview
The lab implements a three-tiered VPC model:
- **Public Subnet**: Kali Linux attacker instance with internet access
- **Private App Subnet**: Vulnerable target instances for penetration testing
- **Private Data Subnet**: Database and sensitive data instances

## Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform installed (version >= 1.0)
- SSH key pair for EC2 instance access
- Personal IP address for secure SSH access

## Quick Start
1. **Clone the repository**:
   ```bash
   git clone git@github.com:FaustoRosado/aws-lab.git
   cd aws-lab/p2w12-quantum-shield
   ```

2. **Update variables**:
   - Edit `terraform/variables.tf` to set your personal IP address
   - Update SSH key pair names if needed

3. **Deploy the lab**:
   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```

4. **Access instances**:
   - Kali Linux: SSH to the public IP from your personal IP
   - Target instances: Access from Kali Linux instance

5. **Clean up**:
   ```bash
   terraform destroy
   ```

## Security Features
- **Network Segmentation**: Three-tier VPC with proper subnet isolation
- **Security Groups**: Instance-level firewall rules following least privilege
- **IAM Roles**: Temporary credentials for EC2 instances
- **Monitoring**: CloudWatch logging and metrics
- **Compliance**: CIS AWS Foundations Benchmark ready

## Training Scenarios
- **Reconnaissance**: Network scanning and enumeration
- **Exploitation**: Web application and system vulnerabilities
- **Lateral Movement**: Privilege escalation and network traversal
- **Detection**: Security monitoring and alert analysis
- **Incident Response**: Threat hunting and remediation

## File Structure
```
p2w12-quantum-shield/
├── README.md                 # This file
├── .gitignore               # Git ignore rules
└── terraform/               # Terraform configuration
    ├── main.tf              # Provider and version configuration
    ├── variables.tf         # Input variables
    ├── network.tf           # VPC, subnets, and routing
    ├── security.tf          # Security groups and IAM
    ├── instances.tf         # EC2 instances and user data
    └── outputs.tf           # Output values (IPs, etc.)
```

## Cost Management
- **Free Tier Eligible**: t2.micro instances
- **Estimated Cost**: $0.50 - $2.00 per day depending on usage
- **Cleanup**: Always run `terraform destroy` when finished

## Support
For questions or issues, contact the team lead or refer to the project documentation in the `docs/` directory.

## License
This project is for educational purposes as part of the P2W12 cybersecurity course.
