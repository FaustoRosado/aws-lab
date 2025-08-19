# Security Groups Module - Firewall Rules

## What are Security Groups?

**Security Groups** are like **firewalls** for your AWS resources. They control what network traffic can come in and go out of your instances, subnets, and other resources.

### Real-World Analogy

- **Security Group** = A security guard at your building entrance
- **Inbound Rules** = Who can come into your building
- **Outbound Rules** = Who can leave your building
- **Port Numbers** = Which doors/entrances are open
- **IP Addresses** = Which people/places are allowed

---

## What This Module Creates

This module creates **three security groups** with different security levels:

- **Public EC2 Security Group** - Allows web traffic (HTTP/HTTPS) and SSH
- **Private EC2 Security Group** - Allows only internal traffic and SSH
- **VPC Endpoints Security Group** - Allows internal VPC communication

---

## Module Structure

```
security_groups/
├── main.tf      # Creates security groups with rules
├── variables.tf # What the module needs as input
├── outputs.tf   # What the module provides to others
└── README.md    # This file!
```

---

## Input Variables Explained

### VPC Configuration

```hcl
variable "vpc_id" {
  description = "ID of the VPC where security groups will be created"
  type        = string
}
```

**What this means:** Your security groups will be created in the VPC created by the VPC module

### Environment Tagging

```hcl
variable "environment" {
  description = "Environment name for tagging"
  type        = string
}
```

**What this means:** All security groups get tagged with your environment (dev, staging, prod)

### VPC CIDR Blocks

```hcl
variable "vpc_cidr_blocks" {
  description = "List of VPC CIDR blocks for internal traffic"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}
```

**What this means:** Defines which IP ranges are considered "internal" to your VPC

---

## How It Works (Step by Step)

### Step 1: Create Public EC2 Security Group

```hcl
resource "aws_security_group" "public_ec2" {
  name        = "${var.environment}-public-ec2-sg"
  description = "Security group for public EC2 instances (web servers)"
  vpc_id      = var.vpc_id
  
  # INBOUND RULES - What traffic can come IN
  
  # Allow SSH from anywhere (for lab purposes)
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 0.0.0.0/0 = anywhere on internet
  }
  
  # Allow HTTP from anywhere
  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # Allow HTTPS from anywhere
  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  # OUTBOUND RULES - What traffic can go OUT
  
  # Allow all outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 = all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name        = "${var.environment}-public-ec2-sg"
    Environment = var.environment
    Type        = "Public EC2"
  }
}
```

**What this does:** Creates a security group that:
- **Allows SSH (port 22)** from anywhere (for remote access)
- **Allows HTTP (port 80)** from anywhere (for web traffic)
- **Allows HTTPS (port 443)** from anywhere (for secure web traffic)
- **Allows all outbound traffic** (instances can reach internet)

### Step 2: Create Private EC2 Security Group

```hcl
resource "aws_security_group" "private_ec2" {
  name        = "${var.environment}-private-ec2-sg"
  description = "Security group for private EC2 instances (database servers)"
  vpc_id      = var.vpc_id
  
  # INBOUND RULES - What traffic can come IN
  
  # Allow SSH from VPC only
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_blocks  # Only from your VPC
  }
  
  # Allow MySQL from VPC only
  ingress {
    description = "MySQL from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_blocks  # Only from your VPC
  }
  
  # OUTBOUND RULES - What traffic can go OUT
  
  # Allow all outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name        = "${var.environment}-private-ec2-sg"
    Environment = var.environment
    Type        = "Private EC2"
  }
}
```

**What this does:** Creates a security group that:
- **Allows SSH (port 22)** only from within your VPC
- **Allows MySQL (port 3306)** only from within your VPC
- **Allows all outbound traffic** (for updates, etc.)

### Step 3: Create VPC Endpoints Security Group

```hcl
resource "aws_security_group" "vpc_endpoints" {
  name        = "${var.environment}-vpc-endpoints-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = var.vpc_id
  
  # INBOUND RULES - What traffic can come IN
  
  # Allow HTTPS from VPC only
  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.vpc_cidr_blocks
  }
  
  # OUTBOUND RULES - What traffic can go OUT
  
  # Allow all outbound traffic
  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name        = "${var.environment}-vpc-endpoints-sg"
    Environment = var.environment
    Type        = "VPC Endpoints"
  }
}
```

**What this does:** Creates a security group for VPC endpoints that:
- **Allows HTTPS (port 443)** only from within your VPC
- **Allows all outbound traffic**

---

## Security Rules Explained

### Port Numbers

- **Port 22** = SSH (Secure Shell) - for remote access
- **Port 80** = HTTP - for web traffic
- **Port 443** = HTTPS - for secure web traffic
- **Port 3306** = MySQL - for database connections

### CIDR Blocks

- **`0.0.0.0/0`** = Anywhere on the internet (least secure)
- **`10.0.0.0/16`** = Only from your VPC (more secure)
- **`10.0.1.0/24`** = Only from a specific subnet (most secure)

### Protocols

- **`tcp`** = Transmission Control Protocol (reliable, ordered)
- **`udp`** = User Datagram Protocol (fast, unordered)
- **`-1`** = All protocols (everything)

---

## What the Module Provides (Outputs)

### Security Group IDs

```hcl
output "public_ec2_sg_id" {
  description = "ID of the public EC2 security group"
  value       = aws_security_group.public_ec2.id
}

output "private_ec2_sg_id" {
  description = "ID of the private EC2 security group"
  value       = aws_security_group.private_ec2.id
}

output "vpc_endpoints_sg_id" {
  description = "ID of the VPC endpoints security group"
  value       = aws_security_group.vpc_endpoints.id
}
```

**Used by:** EC2 module to assign security groups to instances

### Security Group Map

```hcl
output "security_group_ids" {
  description = "Map of security group IDs"
  value = {
    public_ec2    = aws_security_group.public_ec2.id
    private_ec2   = aws_security_group.private_ec2.id
    vpc_endpoints = aws_security_group.vpc_endpoints.id
  }
}
```

**Used by:** Main configuration to pass security groups to other modules

---

## Customizing Your Security Groups

### Make Public Group More Secure

```hcl
# Only allow SSH from your IP address
ingress {
  description = "SSH from my IP only"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["203.0.113.0/32"]  # Replace with your IP
}
```

### Allow Specific Countries/Regions

```hcl
# Allow HTTP only from specific IP ranges
ingress {
  description = "HTTP from specific regions"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = [
    "10.0.0.0/8",    # Private networks
    "172.16.0.0/12", # Private networks
    "192.168.0.0/16" # Private networks
  ]
}
```

### Add More Database Ports

```hcl
# Allow PostgreSQL connections
ingress {
  description = "PostgreSQL from VPC"
  from_port   = 5432
  to_port     = 5432
  protocol    = "tcp"
  cidr_blocks = var.vpc_cidr_blocks
}
```

---

## Common Questions

### "Why does the public group allow SSH from anywhere?"

- **Lab Purpose:** This is a security lab for learning
- **Production Warning:** In real production, you'd restrict SSH to specific IPs
- **Security Note:** The private group is more restrictive

### "What's the difference between ingress and egress?"

- **Ingress:** Traffic coming **INTO** your resource (inbound)
- **Egress:** Traffic going **OUT OF** your resource (outbound)

### "Why do I need outbound rules?"

- **Updates:** Instances need to download security updates
- **Internet:** Web servers need to make API calls
- **Communication:** Instances need to talk to AWS services

### "Can I have multiple security groups on one instance?"

**Yes!** You can assign multiple security groups to an instance:
- **Additive:** Rules from all groups are combined
- **Most Restrictive:** If any group blocks traffic, it's blocked
- **Best Practice:** Use multiple groups for different purposes

---

## Troubleshooting

### Error: "Security group not found"
**Solution:** Make sure the VPC module runs before this one

### Error: "Invalid CIDR block"
**Solution:** Check that your VPC CIDR blocks are valid IP ranges

### Error: "Port already in use"
**Solution:** Each port can only be used once per security group

### Error: "Cannot delete security group"
**Solution:** Remove all references to the security group first

---

## Next Steps

1. **Look at the main.tf** to see how security groups are created
2. **Modify the rules** to add/remove access as needed
3. **Deploy the module** to see your firewall rules in action
4. **Test connectivity** to ensure your rules work correctly

---

## Security Best Practices

### Do's
- **Restrict SSH access** to specific IPs in production
- **Use descriptive names** for security groups
- **Document your rules** with clear descriptions
- **Review rules regularly** for security gaps

### Don'ts
- **Don't use 0.0.0.0/0** for SSH in production
- **Don't forget outbound rules** (instances need internet access)
- **Don't mix public/private rules** in the same group
- **Don't ignore security group limits** (5 per network interface)

---

**Your firewall rules are ready to protect your infrastructure!**