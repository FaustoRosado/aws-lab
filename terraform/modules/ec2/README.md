# EC2 Module - Virtual Servers

## What is EC2?

**EC2 (Elastic Compute Cloud)** is AWS's **virtual server service**. Think of it as renting computers in the cloud that you can start, stop, and configure however you want.

### Real-World Analogy

- **EC2 Instance** = A computer you rent in the cloud
- **Instance Type** = How powerful your computer is (CPU, RAM, storage)
- **SSH Key** = The key to access your computer remotely
- **User Data** = Instructions that run when your computer starts up
- **Tags** = Labels to organize and identify your computers

---

## What This Module Creates

This module creates **two types of EC2 instances** for your security lab:

- **Web Server Instance** - Public-facing server for web traffic
- **Database Server Instance** - Private server for database storage
- **SSH Key Pair** - Secure access to your instances
- **User Data Scripts** - Automatic server setup and configuration

---

## Module Structure

```
ec2/
├── main.tf           # Creates EC2 instances and SSH keys
├── variables.tf      # What the module needs as input
├── outputs.tf        # What the module provides to others
├── README.md         # This file!
├── ssh/              # SSH key management
│   ├── lab-key       # Private SSH key
│   └── lab-key.pub   # Public SSH key
└── user_data/        # Server setup scripts
    ├── web_server.sh      # Web server configuration
    └── database_server.sh # Database setup
```

---

## Input Variables Explained

### VPC and Network Configuration

```hcl
variable "vpc_id" {
  description = "ID of the VPC where instances will be created"
  type        = string
}
```

**What this means:** Your EC2 instances will be created in the VPC created by the VPC module

### Subnet Configuration

```hcl
variable "public_subnet_ids" {
  description = "IDs of public subnets for web server"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "IDs of private subnets for database server"
  type        = list(string)
}
```

**What this means:** 
- **Web server** goes in public subnets (can access internet)
- **Database server** goes in private subnets (hidden from internet)

### Security Group Configuration

```hcl
variable "public_ec2_sg_id" {
  description = "Security group ID for public EC2 instances"
  type        = string
}

variable "private_ec2_sg_id" {
  description = "Security group ID for private EC2 instances"
  type        = string
}
```

**What this means:** Your instances will use the security groups created by the security groups module

### Environment and Naming

```hcl
variable "environment" {
  description = "Environment name for tagging and naming"
  type        = string
  default     = "lab"
}
```

**What this means:** All EC2 resources get tagged with your environment (dev, staging, prod)

### Instance Configuration

```hcl
variable "instance_type" {
  description = "EC2 instance type (size/power)"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "Amazon Machine Image ID (operating system)"
  type        = string
  default     = "ami-0c02fb55956c7d316"  # Amazon Linux 2
}
```

**What this means:** 
- **Instance Type:** How powerful your server is (t3.micro = small, t3.large = powerful)
- **AMI ID:** Which operating system to use (Amazon Linux 2 is free and AWS-optimized)

---

## How It Works (Step by Step)

### Step 1: Create SSH Key Pair

```hcl
resource "aws_key_pair" "lab_key" {
  key_name   = "${var.environment}-lab-key"
  public_key = file("${path.module}/ssh/lab-key.pub")
  
  tags = {
    Name        = "${var.environment}-lab-key"
    Environment = var.environment
    Type        = "SSH Key"
  }
}
```

**What this does:** Creates an SSH key pair so you can securely connect to your instances

### Step 2: Create Web Server Instance

```hcl
resource "aws_instance" "web_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name              = aws_key_pair.lab_key.key_name
  vpc_security_group_ids = [var.public_ec2_sg_id]
  subnet_id              = var.public_subnet_ids[0]
  
  user_data = file("${path.module}/user_data/web_server.sh")
  
  tags = {
    Name        = "${var.environment}-web-server"
    Environment = var.environment
    Type        = "Web Server"
  }
}
```

**What this does:** Creates a web server in a public subnet with automatic setup scripts

### Step 3: Create Database Server Instance

```hcl
resource "aws_instance" "database_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name              = aws_key_pair.lab_key.key_name
  vpc_security_group_ids = [var.private_ec2_sg_id]
  subnet_id              = var.private_subnet_ids[0]
  
  user_data = file("${path.module}/user_data/database_server.sh")
  
  tags = {
    Name        = "${var.environment}-database-server"
    Environment = var.environment
    Type        = "Database Server"
  }
}
```

**What this does:** Creates a database server in a private subnet for security

---

## What the Module Provides (Outputs)

### Instance Information

```hcl
output "web_server_id" {
  description = "ID of the web server instance"
  value       = aws_instance.web_server.id
}

output "database_server_id" {
  description = "ID of the database server instance"
  value       = aws_instance.database_server.id
}
```

**Used by:** You to know which instances were created

### Connection Information

```hcl
output "web_server_public_ip" {
  description = "Public IP address of the web server"
  value       = aws_instance.web_server.public_ip
}

output "web_server_private_ip" {
  description = "Private IP address of the web server"
  value       = aws_instance.web_server.private_ip
}
```

**Used by:** You to connect to your instances via SSH or web browser

### SSH Key Information

```hcl
output "ssh_key_name" {
  description = "Name of the SSH key pair"
  value       = aws_key_pair.lab_key.key_name
}
```

**Used by:** You to know which SSH key to use for connections

---

## Customizing Your EC2 Setup

### Change Instance Types

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"  # Change from t3.micro to t3.small
}
```

### Use Different Operating Systems

```hcl
variable "ami_id" {
  description = "Amazon Machine Image ID"
  type        = string
  default     = "ami-0c02fb55956c7d316"  # Amazon Linux 2
  # Alternative AMIs:
  # "ami-0c02fb55956c7d316" = Amazon Linux 2 (free)
  # "ami-0c02fb55956c7d317" = Ubuntu 20.04 LTS
  # "ami-0c02fb55956c7d318" = Windows Server 2019
}
```

### Add More Instances

```hcl
# Add a monitoring server
resource "aws_instance" "monitoring_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name              = aws_key_pair.lab_key.key_name
  vpc_security_group_ids = [var.private_ec2_sg_id]
  subnet_id              = var.private_subnet_ids[1]
  
  user_data = file("${path.module}/user_data/monitoring_server.sh")
  
  tags = {
    Name        = "${var.environment}-monitoring-server"
    Environment = var.environment
    Type        = "Monitoring Server"
  }
}
```

---

## Common Questions

### "What's the difference between public and private subnets?"

- **Public Subnets:** Instances here can get public IP addresses and access the internet directly
- **Private Subnets:** Instances here are hidden from the internet and use NAT Gateway for outbound access

### "Which instance type should I choose?"

- **t3.micro:** Good for learning and testing (free tier eligible)
- **t3.small:** Better performance for development
- **t3.medium:** Good for production workloads
- **t3.large:** High performance for demanding applications

### "How do I connect to my instances?"

1. **Web Server:** Use the public IP in your browser
2. **Database Server:** SSH from the web server (same VPC)
3. **SSH Command:** `ssh -i ssh/lab-key ec2-user@[PUBLIC_IP]`

### "What are user data scripts?"

**User Data Scripts** are bash scripts that run automatically when your instance starts up. They install software, configure services, and set up your server without manual intervention.

---

## Troubleshooting

### Error: "Key pair not found"
**Solution:** Make sure the SSH key files exist in the `ssh/` folder

### Error: "Security group not found"
**Solution:** Deploy the security groups module first, then EC2

### Error: "Subnet not found"
**Solution:** Deploy the VPC module first, then EC2

### Error: "AMI not found in region"
**Solution:** Use an AMI that exists in your chosen AWS region

---

## Next Steps

1. **Look at the main.tf** to see how instances are created
2. **Modify variables** to customize your server setup
3. **Deploy the module** to create your EC2 instances
4. **Connect via SSH** to test your setup
5. **Check the web server** in your browser

---

## Security Best Practices

### Do's
- Use private subnets for sensitive resources
- Keep SSH keys secure and never share private keys
- Use security groups to restrict access
- Tag all resources for organization

### Don'ts
- Don't put sensitive data on public instances
- Don't use default security groups
- Don't forget to update user data scripts
- Don't skip instance monitoring

---

## Cost Considerations

### EC2 Instance Costs
- **t3.micro:** Free tier eligible (750 hours/month)
- **t3.small:** ~$0.0208 per hour
- **t3.medium:** ~$0.0416 per hour
- **t3.large:** ~$0.0832 per hour

### Data Transfer Costs
- **Inbound:** FREE
- **Outbound:** $0.09 per GB (first 1GB free)
- **Between instances:** FREE (same VPC)

### Cost Optimization Tips
- Use spot instances for non-critical workloads
- Stop instances when not in use
- Use reserved instances for long-term workloads
- Monitor usage with AWS Cost Explorer

---

## Integration with Other Services

### Security Groups
- Control network access to your instances
- Define which ports are open and to whom

### VPC
- Provides network isolation and routing
- Determines subnet placement and internet access

### User Data Scripts
- Automate server setup and configuration
- Install software and configure services

### CloudWatch
- Monitor instance performance and health
- Set up alarms for resource usage

---

<div align="center">
  <p><em>Your virtual servers are now ready!</em></p>
</div>
