# 💻 EC2 Module - Virtual Servers

## 📚 **What is EC2?**

**EC2 (Elastic Compute Cloud)** are **virtual servers** in AWS. Think of them as **computers in the cloud** that you can start, stop, and configure however you want.

### **🏠 Real-World Analogy**

- **💻 EC2 Instance** = A computer you rent in the cloud
- **🖥️ Instance Type** = How powerful the computer is (CPU, RAM, etc.)
- **🔑 Key Pair** = Your password/access key to log into the computer
- **🏠 Subnet** = Which neighborhood your computer is located in
- **🛡️ Security Group** = Firewall rules for your computer

---

## 🎯 **What This Module Creates**

This module creates **two virtual servers** for your security lab:

- **🌐 Public Web Server** - Accessible from the internet (for testing attacks)
- **🗄️ Private Database Server** - Hidden from the internet (for storing data)
- **🔑 SSH Key Pair** - Secure way to access your servers

---

## 🏗️ **Module Structure**

```
ec2/
├── main.tf              # 🎯 Creates EC2 instances and key pair
├── variables.tf         # 📝 What the module needs as input
├── outputs.tf           # 📤 What the module provides to others
├── user_data/           # 📜 Scripts that run when servers start
│   ├── web_server.sh    # 🌐 Sets up web server with vulnerable app
│   └── database_server.sh # 🗄️ Sets up MySQL database
└── README.md            # 📖 This file!
```

---

## 📝 **Input Variables Explained**

### **🌐 Network Configuration**

```hcl
variable "vpc_id" {
  description = "ID of the VPC where instances will be created"
  type        = string
}
```

**What this means:** Your servers will be created in the VPC created by the VPC module

### **🏠 Subnet Placement**

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

### **🛡️ Security Groups**

```hcl
variable "security_group_ids" {
  description = "Map of security group IDs for different instance types"
  type        = map(string)
}
```

**What this means:** Each server gets specific firewall rules (web server allows HTTP, database server allows MySQL)

### **🔑 SSH Access**

```hcl
variable "key_pair_name" {
  description = "Name for the SSH key pair"
  type        = string
  default     = "lab-key"
}
```

**What this means:** Creates a key pair so you can securely SSH into your servers

### **💪 Server Power**

```hcl
variable "instance_type" {
  description = "EC2 instance type (size/power)"
  type        = string
  default     = "t3.micro"
}
```

**What this means:** How powerful your servers are (t3.micro = small, t3.medium = medium, etc.)

---

## 🔍 **How It Works (Step by Step)**

### **Step 1: Create SSH Key Pair**

```hcl
resource "aws_key_pair" "lab_key" {
  key_name   = var.key_pair_name
  public_key = file("${path.module}/ssh/lab-key.pub")
  
  tags = {
    Name        = "${var.environment}-${var.key_pair_name}"
    Environment = var.environment
  }
}
```

**What this does:** Creates a key pair using the public key file in the ssh/ folder

### **Step 2: Get Latest Amazon Linux 2 AMI**

```hcl
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
```

**What this does:** Automatically finds the newest Amazon Linux 2 operating system image

### **Step 3: Create Public Web Server**

```hcl
resource "aws_instance" "public_web" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name              = aws_key_pair.lab_key.key_name
  subnet_id             = var.public_subnet_ids[0]
  vpc_security_group_ids = [var.security_group_ids["public_ec2"]]
  
  user_data = file("${path.module}/user_data/web_server.sh")
  
  tags = {
    Name        = "${var.environment}-public-web-server"
    Environment = var.environment
    Type        = "Web Server"
    Public      = "true"
  }
}
```

**What this does:** Creates a web server that:
- Uses the latest Amazon Linux 2
- Gets the specified power level
- Uses your SSH key
- Goes in the first public subnet
- Gets web server firewall rules
- Runs the web server setup script when it starts

### **Step 4: Create Private Database Server**

```hcl
resource "aws_instance" "private_db" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name              = aws_key_pair.lab_key.key_name
  subnet_id             = var.private_subnet_ids[0]
  vpc_security_group_ids = [var.security_group_ids["private_ec2"]]
  
  user_data = file("${path.module}/user_data/database_server.sh")
  
  tags = {
    Name        = "${var.environment}-private-db-server"
    Environment = var.environment
    Type        = "Database Server"
    Public      = "false"
  }
}
```

**What this does:** Creates a database server that:
- Uses the same OS and power level
- Goes in the first private subnet (hidden from internet)
- Gets database server firewall rules
- Runs the database setup script when it starts

---

## 📜 **User Data Scripts Explained**

### **🌐 Web Server Setup (web_server.sh)**

When your web server starts, it automatically runs this script:

```bash
#!/bin/bash
# Install Apache web server
yum update -y
yum install -y httpd php

# Start Apache
systemctl start httpd
systemctl enable httpd

# Create a deliberately vulnerable web application
cat > /var/www/html/index.php << 'EOF'
<?php
// This is intentionally vulnerable for security testing
if (isset($_GET['cmd'])) {
    system($_GET['cmd']);
}
?>
<h1>Welcome to the Security Lab!</h1>
<p>This is a deliberately vulnerable web application for learning.</p>
EOF

# Set permissions
chown apache:apache /var/www/html/index.php
chmod 755 /var/www/html/index.php
```

**What this does:** Installs Apache + PHP and creates a vulnerable web app for security testing

### **🗄️ Database Server Setup (database_server.sh)**

When your database server starts, it automatically runs this script:

```bash
#!/bin/bash
# Install MySQL
yum update -y
yum install -y mysql mysql-server

# Start MySQL
systemctl start mysqld
systemctl enable mysqld

# Secure MySQL installation
mysql_secure_installation << EOF
y
y
y
y
y
y
EOF

# Create database and sample data
mysql -u root -e "CREATE DATABASE security_lab;"
mysql -u root -e "USE security_lab; CREATE TABLE users (id INT, name VARCHAR(50));"
mysql -u root -e "INSERT INTO security_lab.users VALUES (1, 'admin'), (2, 'user');"
```

**What this does:** Installs MySQL, secures it, and creates a sample database for testing

---

## 📤 **What the Module Provides (Outputs)**

### **🆔 Instance Information**

```hcl
output "public_web_instance_id" {
  description = "ID of the public web server"
  value       = aws_instance.public_web.id
}

output "public_web_public_ip" {
  description = "Public IP address of the web server"
  value       = aws_instance.public_web.public_ip
}

output "private_db_instance_id" {
  description = "ID of the private database server"
  value       = aws_instance.private_db.id
}

output "private_db_private_ip" {
  description = "Private IP address of the database server"
  value       = aws_instance.private_db.private_ip
}
```

**Used by:** Other modules and scripts to know how to connect to your servers

---

## 🎨 **Customizing Your Servers**

### **💪 Change Server Power**

```hcl
variable "instance_type" {
  default = "t3.small"  # More powerful than t3.micro
}
```

**Available types:**
- **t3.micro** - 2 vCPU, 1 GB RAM (free tier)
- **t3.small** - 2 vCPU, 2 GB RAM
- **t3.medium** - 2 vCPU, 4 GB RAM
- **t3.large** - 2 vCPU, 8 GB RAM

### **🌍 Change Operating System**

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical (Ubuntu)
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-22.04-*-amd64-server-*"]
  }
}
```

### **🔑 Use Your Own SSH Key**

```hcl
variable "key_pair_name" {
  default = "my-personal-key"  # Your existing key pair
}
```

---

## 🚨 **Common Questions**

### **❓ "What's the difference between public and private IPs?"**

- **🌐 Public IP:** Address that can be reached from the internet
  - Good for: Web servers, services that need internet access
  - Security: More exposed to attacks

- **🏠 Private IP:** Address only reachable within your VPC
  - Good for: Database servers, internal services
  - Security: Hidden from internet, more secure

### **❓ "Why do I need user data scripts?"**

- **🚀 Automation:** Servers configure themselves when they start
- **🔄 Consistency:** Same setup every time, no manual configuration
- **⚡ Speed:** Ready to use immediately after creation
- **📝 Documentation:** Your setup process is documented in code

### **❓ "What if I want to connect to the database server?"**

Since the database server is in a private subnet, you need to:
1. **SSH to the web server first** (it's public)
2. **Then SSH from web server to database server** (internal connection)
3. **Or use a bastion host** (jump server) for secure access

---

## 🔧 **Troubleshooting**

### **🚨 Error: "Key pair not found"**
**Solution:** Make sure the SSH key files exist in the ssh/ folder

### **🚨 Error: "Subnet not found"**
**Solution:** Check that the VPC module created subnets before this module

### **🚨 Error: "Security group not found"**
**Solution:** Make sure the security groups module runs before this one

### **🚨 Error: "Instance type not supported"**
**Solution:** Check that your region supports the instance type you specified

---

## 🎯 **Next Steps**

1. **🔍 Look at the user_data scripts** to understand server setup
2. **📝 Modify the scripts** to add your own applications
3. **🚀 Deploy the module** to see your servers in action
4. **🔗 Connect to your servers** using SSH and the key pair

---

## 🔐 **Security Notes**

- **⚠️ The web server is deliberately vulnerable** for security testing
- **🔒 Never use these configurations in production**
- **🛡️ Always destroy resources when done** to avoid security risks
- **📚 This is for learning purposes only**

---

<div align="center">
  <p><em>💻 Your virtual servers are ready to run! 🚀</em></p>
</div>
