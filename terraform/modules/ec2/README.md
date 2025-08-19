# 🖥️ EC2 Module - Virtual Servers

## 📚 **What is EC2?**

**EC2 (Elastic Compute Cloud)** is AWS's **virtual server service**. Think of it as renting computers in the cloud that you can start, stop, and configure however you want.

### **🏠 Real-World Analogy**

- **🖥️ EC2 Instance** = A computer you rent in the cloud
- **💾 Instance Type** = How powerful your computer is (CPU, RAM, storage)
- **🔑 SSH Key** = The key to access your computer remotely
- **📝 User Data** = Instructions that run when your computer starts up
- **🏷️ Tags** = Labels to organize and identify your computers

---

## 🎯 **What This Module Creates**

This module creates **two types of EC2 instances** for your security lab:

- **🌐 Web Server Instance** - Public-facing server for web traffic
- **🗄️ Database Server Instance** - Private server for database storage
- **🔑 SSH Key Pair** - Secure access to your instances
- **📝 User Data Scripts** - Automatic server setup and configuration

---

## 🏗️ **Module Structure**

```
ec2/
├── main.tf           # 🎯 Creates EC2 instances and SSH keys
├── variables.tf      # 📝 What the module needs as input
├── outputs.tf        # 📤 What the module provides to others
├── README.md         # 📖 This file!
├── ssh/              # 🔑 SSH key management
│   ├── lab-key       # Private SSH key
│   └── lab-key.pub   # Public SSH key
└── user_data/        # 📝 Server setup scripts
    ├── web_server.sh      # Web server configuration
    └── database_server.sh # Database setup
```

---

## 📝 **Input Variables Explained**

### **🌐 VPC and Network Configuration**

```hcl
variable "vpc_id" {
  description = "ID of the VPC where instances will be created"
  type        = string
}
```

**What this means:** Your EC2 instances will be created in the VPC created by the VPC module

### **🏠 Subnet Configuration**

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

### **🛡️ Security Group Configuration**

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

### **🏷️ Environment and Naming**

```hcl
variable "environment" {
  description = "Environment name for tagging and naming"
  type        = string
  default     = "lab"
}
```

**What this means:** All instances get tagged with your environment (dev, staging, prod)

---

## 🔍 **How It Works (Step by Step)**

### **Step 1: Create SSH Key Pair**

```hcl
resource "aws_key_pair" "lab_key" {
  key_name   = "${var.environment}-lab-key"
  public_key = file("${path.module}/ssh/lab-key.pub")
  
  tags = {
    Name        = "${var.environment}-lab-key"
    Environment = var.environment
  }
}
```

**What this does:** Creates an SSH key pair so you can securely connect to your instances

### **Step 2: Create Web Server Instance**

```hcl
resource "aws_instance" "web_server" {
  ami                    = var.web_server_ami
  instance_type          = var.web_server_instance_type
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

**What this does:** Creates a web server that:
- **Uses the specified AMI** (Amazon Machine Image - like an operating system)
- **Has the specified size** (CPU, RAM, storage)
- **Uses your SSH key** for secure access
- **Gets the public security group** (allows web traffic)
- **Goes in a public subnet** (can access internet)
- **Runs the web server setup script** when it starts

### **Step 3: Create Database Server Instance**

```hcl
resource "aws_instance" "database_server" {
  ami                    = var.database_server_ami
  instance_type          = var.database_server_instance_type
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

**What this does:** Creates a database server that:
- **Uses the specified AMI** (different from web server)
- **Has the specified size** (optimized for database workloads)
- **Uses your SSH key** for secure access
- **Gets the private security group** (restricts access)
- **Goes in a private subnet** (hidden from internet)
- **Runs the database setup script** when it starts

---

## 📝 **User Data Scripts Explained**

### **🌐 Web Server Setup (`web_server.sh`)**

```bash
#!/bin/bash
# Update system packages
yum update -y

# Install web server (Apache)
yum install -y httpd

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Create a simple web page
echo "<h1>Welcome to AWS Security Lab!</h1>" > /var/www/html/index.html
echo "<p>This is your web server running in the cloud.</p>" >> /var/www/html/index.html
```

**What this does:** When your web server starts, it automatically:
- **Updates the system** with latest security patches
- **Installs Apache web server**
- **Starts the web service**
- **Creates a welcome page**

### **🗄️ Database Server Setup (`database_server.sh`)**

```bash
#!/bin/bash
# Update system packages
yum update -y

# Install MySQL database
yum install -y mysql-server

# Start and enable MySQL
systemctl start mysqld
systemctl enable mysqld

# Secure the MySQL installation
mysql_secure_installation
```

**What this does:** When your database server starts, it automatically:
- **Updates the system** with latest security patches
- **Installs MySQL database server**
- **Starts the database service**
- **Secures the MySQL installation**

---

## 🔑 **SSH Key Management**

### **🔐 Key Pair Structure**

```
ssh/
├── lab-key       # 🔒 Private key (keep secret!)
└── lab-key.pub   # 🔓 Public key (safe to share)
```

### **🔑 How SSH Keys Work**

1. **Private Key** (`lab-key`): Stays on your computer, never share this
2. **Public Key** (`lab-key.pub`): Gets uploaded to AWS, safe to share
3. **Authentication**: AWS uses the public key to verify your private key

### **🔐 Connecting to Your Instances**

```bash
# Connect to web server
ssh -i ssh/lab-key ec2-user@[WEB_SERVER_PUBLIC_IP]

# Connect to database server (from web server)
ssh -i ssh/lab-key ec2-user@[DATABASE_SERVER_PRIVATE_IP]
```

---

## 📤 **What the Module Provides (Outputs)**

### **🆔 Instance IDs**

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

**Used by:** Other modules or scripts that need to reference your instances

### **🌐 Public IP Addresses**

```hcl
output "web_server_public_ip" {
  description = "Public IP address of the web server"
  value       = aws_instance.web_server.public_ip
}

output "web_server_public_dns" {
  description = "Public DNS name of the web server"
  value       = aws_instance.web_server.public_dns
}
```

**Used by:** You to access your web server from the internet

### **🔑 SSH Key Information**

```hcl
output "ssh_key_name" {
  description = "Name of the SSH key pair"
  value       = aws_key_pair.lab_key.key_name
}
```

**Used by:** You to know which SSH key to use for connections

---

## 🎨 **Customizing Your Instances**

### **🖥️ Change Instance Types**

```hcl
variable "web_server_instance_type" {
  description = "EC2 instance type for web server"
  type        = string
  default     = "t3.micro"  # Change to t3.small, t3.medium, etc.
}

variable "database_server_instance_type" {
  description = "EC2 instance type for database server"
  type        = string
  default     = "t3.micro"  # Change to t3.small, t3.medium, etc.
}
```

**Instance Type Guide:**
- **t3.micro**: 2 vCPU, 1 GB RAM (good for learning)
- **t3.small**: 2 vCPU, 2 GB RAM (good for small workloads)
- **t3.medium**: 2 vCPU, 4 GB RAM (good for medium workloads)

### **🖼️ Change Operating System**

```hcl
variable "web_server_ami" {
  description = "AMI ID for web server"
  type        = string
  default     = "ami-0c02fb55956c7d316"  # Amazon Linux 2
}

variable "database_server_ami" {
  description = "AMI ID for database server"
  type        = string
  default     = "ami-0c02fb55956c7d316"  # Amazon Linux 2
}
```

**Popular AMIs:**
- **Amazon Linux 2**: Good for beginners, AWS-optimized
- **Ubuntu**: Popular Linux distribution
- **Windows Server**: If you need Windows

### **📝 Customize User Data Scripts**

You can modify the scripts in the `user_data/` folder to:
- **Install different software**
- **Configure specific services**
- **Set up monitoring tools**
- **Create custom web pages**

---

## 🚨 **Common Questions**

### **❓ "What's the difference between public and private subnets?"**

- **🌐 Public Subnets:** Instances here can access the internet directly
  - Good for: Web servers, load balancers, bastion hosts
  - Security: Less secure, exposed to internet

- **🏠 Private Subnets:** Instances here are hidden from the internet
  - Good for: Database servers, application servers, internal services
  - Security: More secure, no direct internet access

### **❓ "Why do I need SSH keys?"**

- **🔐 Security:** More secure than passwords
- **🔑 Automation:** Scripts can connect without manual input
- **👥 Team Access:** Multiple people can use the same key
- **🚫 No Password Sharing:** Eliminates password security risks

### **❓ "What happens if I lose my SSH key?"**

- **🚨 Problem:** You can't connect to your instances
- **🔧 Solution:** Create a new key pair and update your instances
- **💡 Prevention:** Keep your private key safe and backed up

### **❓ "Can I change instance types after creation?"**

**Yes!** You can:
- **Stop the instance** (not terminate)
- **Change the instance type** in Terraform
- **Apply the changes** to resize your instance
- **Start the instance** with new specifications

---

## 🔧 **Troubleshooting**

### **🚨 Error: "AMI not found"**
**Solution:** Check that your AMI ID is correct and available in your region

### **🚨 Error: "Instance type not supported"**
**Solution:** Verify the instance type is available in your region

### **🚨 Error: "Subnet not found"**
**Solution:** Make sure the VPC and subnet modules run before this one

### **🚨 Error: "Security group not found"**
**Solution:** Ensure the security groups module runs before this one

### **🚨 Error: "SSH connection failed"**
**Solution:** 
1. Check that your security group allows SSH (port 22)
2. Verify you're using the correct SSH key
3. Wait a few minutes for the instance to fully start

---

## 🎯 **Next Steps**

1. **🔍 Look at the main.tf** to see how instances are created
2. **📝 Modify variables** to customize your instances
3. **🚀 Deploy the module** to see your servers in action
4. **🔗 Connect to your instances** using SSH
5. **🌐 Test your web server** by visiting the public IP

---

## 🔐 **Security Best Practices**

### **✅ Do's**
- **🔒 Use SSH keys** instead of passwords
- **🏷️ Tag your instances** for organization
- **🛡️ Use security groups** to control access
- **📝 Keep user data scripts** simple and secure

### **❌ Don'ts**
- **🚫 Don't share private SSH keys**
- **🚫 Don't put sensitive data** in user data scripts
- **🚫 Don't forget to stop instances** when not using them
- **🚫 Don't ignore security group rules**

---

## 💰 **Cost Considerations**

### **💰 Instance Pricing**
- **t3.micro**: ~$8-10/month (good for learning)
- **t3.small**: ~$16-20/month (good for small workloads)
- **t3.medium**: ~$32-40/month (good for medium workloads)

### **💡 Cost Optimization Tips**
- **🛑 Stop instances** when not using them
- **🏷️ Use tags** to track costs
- **📊 Monitor usage** with AWS Cost Explorer
- **🔄 Use spot instances** for non-critical workloads

---

<div align="center">
  <p><em>🖥️ Your virtual servers are ready to run! 🚀</em></p>
</div>
