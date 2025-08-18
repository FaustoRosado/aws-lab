# 🌐 VPC Module - Network Foundation

## 📚 **What is a VPC?**

**VPC (Virtual Private Cloud)** is like your **private network** in AWS. Think of it as your own **gated community** in the cloud where you control who can access what.

### **🏠 Real-World Analogy**

- **🏘️ VPC** = Your gated community
- **🏠 Subnets** = Different neighborhoods within your community
- **🚪 Internet Gateway** = The main entrance/exit to the internet
- **🛣️ Route Tables** = Street signs telling traffic where to go

---

## 🎯 **What This Module Creates**

This module builds the **network foundation** for your entire infrastructure:

- **🌐 VPC** - Your private cloud network
- **🏠 Public Subnets** - Resources that can access the internet directly
- **🏠 Private Subnets** - Resources that are hidden from the internet
- **🚪 Internet Gateway** - Connects your VPC to the internet
- **🛣️ Route Tables** - Directs network traffic

---

## 🏗️ **Module Structure**

```
vpc/
├── main.tf      # 🎯 Creates VPC, subnets, gateway, routes
├── variables.tf # 📝 What the module needs as input
├── outputs.tf   # 📤 What the module provides to others
└── README.md    # 📖 This file!
```

---

## 📝 **Input Variables Explained**

### **🌐 VPC Configuration**

```hcl
variable "vpc_cidr" {
  description = "Main VPC network range (e.g., 10.0.0.0/16)"
  type        = string
  default     = "10.0.0.0/16"
}
```

**What this means:** Your VPC will use the IP range `10.0.0.0` to `10.255.255.255`

### **🌍 Availability Zones**

```hcl
variable "availability_zones" {
  description = "AWS availability zones (e.g., us-east-1a, us-east-1b)"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}
```

**What this means:** Your resources will be spread across 2 different data centers for reliability

### **🏠 Subnet Ranges**

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

## 🔍 **How It Works (Step by Step)**

### **Step 1: Create the VPC**
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

**What this does:** Creates your main network with DNS support enabled

### **Step 2: Create the Internet Gateway**
```hcl
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}
```

**What this does:** Creates the door to the internet for your VPC

### **Step 3: Create Public Subnets**
```hcl
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  
  map_public_ip_on_launch = true  # Resources get public IPs automatically
  
  tags = {
    Name        = "${var.environment}-public-subnet-${count.index + 1}"
    Environment = var.environment
    Type        = "Public"
  }
}
```

**What this does:** Creates 2 public subnets where resources can get internet access

### **Step 4: Create Private Subnets**
```hcl
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
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

**What this does:** Creates 2 private subnets for resources that should be hidden

### **Step 5: Create Route Tables**
```hcl
# Public route table - allows internet access
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  
  route {
    cidr_block = "0.0.0.0/0"           # All internet traffic
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = {
    Name        = "${var.environment}-public-rt"
    Environment = var.environment
  }
}

# Private route table - no internet access
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name        = "${var.environment}-private-rt"
    Environment = var.environment
  }
}
```

**What this does:** 
- **Public routes:** Send internet traffic through the gateway
- **Private routes:** Keep traffic local (no internet access)

---

## 📤 **What the Module Provides (Outputs)**

### **🆔 VPC ID**
```hcl
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}
```

**Used by:** Other modules need this to create resources in your VPC

### **🌐 VPC CIDR Block**
```hcl
output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}
```

**Used by:** Security groups to define network rules

### **🏠 Subnet IDs**
```hcl
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}
```

**Used by:** EC2 instances and other resources to know where to deploy

---

## 🎨 **Customizing Your Network**

### **🌍 Change the Region**
```hcl
variable "availability_zones" {
  default = ["us-west-2a", "us-west-2b"]  # Oregon region
}
```

### **🏠 Change Network Size**
```hcl
variable "vpc_cidr" {
  default = "172.16.0.0/16"  # Different IP range
}

variable "public_subnet_cidrs" {
  default = ["172.16.1.0/24", "172.16.2.0/24"]  # Different subnet ranges
}
```

### **🔢 Add More Subnets**
```hcl
variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]  # 3 zones
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]  # 3 subnets
}
```

---

## 🚨 **Common Questions**

### **❓ "What's the difference between public and private subnets?"**

- **🏠 Public Subnets:** Resources here can access the internet directly
  - Good for: Web servers, load balancers, bastion hosts
  - Security: Less secure, exposed to internet

- **🏠 Private Subnets:** Resources here are hidden from the internet
  - Good for: Database servers, application servers, internal services
  - Security: More secure, no direct internet access

### **❓ "Why do I need multiple availability zones?"**

- **🔄 High Availability:** If one data center fails, your resources in the other zone keep running
- **🌍 Geographic Distribution:** Spreads your resources across different locations
- **📈 Performance:** Can reduce latency for users in different areas

### **❓ "What does CIDR mean?"**

**CIDR (Classless Inter-Domain Routing)** is a way to specify IP address ranges:
- `10.0.0.0/16` means "all IPs from 10.0.0.0 to 10.0.255.255"
- `/16` means the first 16 bits are fixed, last 16 bits can vary
- Smaller numbers (like `/24`) mean smaller ranges

---

## 🔧 **Troubleshooting**

### **🚨 Error: "Subnet CIDR conflicts with VPC CIDR"**
**Solution:** Make sure your subnet ranges are within your VPC range

### **🚨 Error: "Availability zone not supported"**
**Solution:** Check that your region supports the zones you specified

### **🚨 Error: "VPC already exists"**
**Solution:** Use a different VPC CIDR or destroy existing resources first

---

## 🎯 **Next Steps**

1. **🔍 Look at the main.tf** to see how resources are created
2. **📝 Modify variables** to customize your network
3. **🚀 Deploy the module** to see it in action
4. **🔗 Connect other modules** that need network access

---

<div align="center">
  <p><em>🌐 Your network is the foundation of everything else! 🏗️</em></p>
</div>
