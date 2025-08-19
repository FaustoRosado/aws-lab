# VPC Module - Network Foundation

## What is a VPC?

**VPC (Virtual Private Cloud)** is like your **private network** in AWS. Think of it as your own **gated community** in the cloud where you control who can access what.

### Real-World Analogy

- **VPC** = Your gated community
- **Subnets** = Different neighborhoods within your community
- **Internet Gateway** = The main entrance/exit to the internet
- **Route Tables** = Street signs telling traffic where to go

---

## What This Module Creates

This module builds the **network foundation** for your entire infrastructure:

- **VPC** - Your private cloud network
- **Public Subnets** - Resources that can access the internet directly
- **Private Subnets** - Resources that are hidden from the internet
- **Internet Gateway** - Connects your VPC to the internet
- **Route Tables** - Directs network traffic

---

## Module Structure

```
vpc/
├── main.tf      # Creates VPC, subnets, gateway, routes
├── variables.tf # What the module needs as input
├── outputs.tf   # What the module provides to others
└── README.md    # This file!
```

---

## Input Variables Explained

### VPC Configuration

```hcl
variable "vpc_cidr" {
  description = "Main VPC network range (e.g., 10.0.0.0/16)"
  type        = string
  default     = "10.0.0.0/16"
}
```

**What this means:** Your VPC will use the IP range `10.0.0.0` to `10.255.255.255`

### Availability Zones

```hcl
variable "availability_zones" {
  description = "AWS availability zones (e.g., us-east-1a, us-east-1b)"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}
```

**What this means:** Your resources will be spread across 2 different data centers for reliability

### Subnet Ranges

```hcl
variable "public_subnet_cidrs" {
  description = "IP ranges for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "IP ranges for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}
```

**What this means:**
- **Public subnets:** `10.0.1.0` to `10.0.1.255` and `10.0.2.0` to `10.0.2.255`
- **Private subnets:** `10.0.10.0` to `10.0.10.255` and `10.0.20.0` to `10.0.20.255`

---

## How It Works (Step by Step)

### Step 1: Create the VPC
```hcl
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}
```

**What this does:** Creates your main VPC network with DNS support enabled

### Step 2: Create Public Subnets
```hcl
resource "aws_subnet" "public" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  
  map_public_ip_on_launch = true
  
  tags = {
    Name        = "${var.environment}-public-subnet-${count.index + 1}"
    Environment = var.environment
    Type        = "Public"
  }
}
```

**What this does:** Creates public subnets where resources can get public IP addresses

### Step 3: Create Private Subnets
```hcl
resource "aws_subnet" "private" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  
  tags = {
    Name        = "${var.environment}-private-subnet-${count.index + 1}"
    Environment = var.environment
    Type        = "Private"
  }
}
```

**What this does:** Creates private subnets where resources are hidden from the internet

### Step 4: Create Internet Gateway
```hcl
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}
```

**What this does:** Creates the gateway that connects your VPC to the internet

### Step 5: Create Route Tables
```hcl
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = {
    Name        = "${var.environment}-public-rt"
    Environment = var.environment
    Type        = "Public"
  }
}
```

**What this does:** Creates routing rules that send internet traffic through the gateway

---

## What the Module Provides (Outputs)

### VPC Information
```hcl
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}
```

**Used by:** Other modules that need to know your VPC ID and network range

### Subnet Information
```hcl
output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = aws_subnet.private[*].id
}
```

**Used by:** EC2 and other modules that need to place resources in specific subnets

### Gateway Information
```hcl
output "internet_gateway_id" {
  description = "ID of the internet gateway"
  value       = aws_internet_gateway.main.id
}
```

**Used by:** Route tables and other networking components

---

## Customizing Your VPC Setup

### Change Network Ranges
```hcl
variable "vpc_cidr" {
  description = "Main VPC network range"
  type        = string
  default     = "172.16.0.0/16"  # Change from 10.0.0.0/16
}
```

### Add More Availability Zones
```hcl
variable "availability_zones" {
  description = "AWS availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]  # Add third AZ
}
```

### Custom Subnet Ranges
```hcl
variable "public_subnet_cidrs" {
  description = "IP ranges for public subnets"
  type        = list(string)
  default     = ["172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "IP ranges for private subnets"
  type        = list(string)
  default     = ["172.16.10.0/24", "172.16.20.0/24", "172.16.30.0/24"]
}
```

---

## Common Questions

### "What's the difference between public and private subnets?"

- **Public Subnets:** Resources here can get public IP addresses and access the internet directly
- **Private Subnets:** Resources here are hidden from the internet and use NAT Gateway for outbound access

### "How many subnets should I create?"

- **Minimum:** 2 public + 2 private (one per availability zone)
- **Recommended:** 2 public + 2 private for high availability
- **Advanced:** 6+ subnets for complex applications with different security requirements

### "Can I change the VPC CIDR after creation?"

**No, you cannot change the VPC CIDR after creation.** You would need to create a new VPC and migrate resources.

---

## Troubleshooting

### Error: "VPC CIDR overlaps with existing VPC"
**Solution:** Choose a different CIDR range that doesn't conflict with existing VPCs

### Error: "Subnet CIDR not within VPC CIDR"
**Solution:** Ensure your subnet CIDRs are subsets of your VPC CIDR

### Error: "Availability zone not supported"
**Solution:** Check which AZs are available in your region and use those

---

## Next Steps

1. **Look at the main.tf** to see how the VPC is created
2. **Modify variables** to customize your network setup
3. **Deploy the module** to create your VPC infrastructure
4. **Check the AWS Console** to see your VPC in action
5. **Move to the next module** (Security Groups or EC2)

---

## Security Best Practices

### Do's
- Use private subnets for sensitive resources
- Enable DNS hostnames and support
- Tag all resources for organization
- Use descriptive naming conventions

### Don'ts
- Don't use overly broad CIDR ranges
- Don't put sensitive resources in public subnets
- Don't forget to tag resources
- Don't skip availability zone planning

---

## Cost Considerations

### VPC Costs
- **VPC itself:** FREE
- **Subnets:** FREE
- **Internet Gateway:** FREE
- **Route Tables:** FREE

### Related Costs
- **NAT Gateway:** ~$0.045 per hour + data processing
- **Data Transfer:** Standard AWS data transfer costs
- **VPC Endpoints:** $0.01 per VPC endpoint per hour

---

## Integration with Other Services

### Security Groups
- VPC provides the network foundation for security group rules
- Security groups control traffic within your VPC

### EC2 Instances
- Instances are placed in subnets within your VPC
- VPC determines network isolation and routing

### Load Balancers
- Load balancers are placed in subnets
- VPC routing determines traffic flow

---

<div align="center">
  <p><em>Your network foundation is now ready!</em></p>
</div>
