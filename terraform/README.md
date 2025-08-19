# Terraform Infrastructure as Code Guide

## What is Terraform?

**Terraform** is an **Infrastructure as Code (IaC)** tool that lets you define and manage your cloud infrastructure using simple, declarative configuration files. Instead of manually clicking through AWS console, you write code to describe what you want, and Terraform makes it happen!

Think of it like a **recipe book for your cloud infrastructure** - you write the recipe once, and Terraform cooks it up perfectly every time.

---

## Why Use Terraform?

- **Speed** - Deploy entire infrastructure in minutes, not hours
- **Consistency** - Same infrastructure every time, no human errors
- **Documentation** - Your infrastructure is self-documenting code
- **Version Control** - Track changes, rollback, collaborate with teams
- **Cost Control** - Easy to destroy and recreate resources
- **Multi-Cloud** - Same tool for AWS, Azure, Google Cloud

---

## Project Structure Explained

```
terraform/
├── main.tf              # Main configuration - orchestrates everything
├── variables.tf         # Input variables - customizable settings
├── outputs.tf          # Output values - what gets returned
├── modules/            # Reusable building blocks
│   ├── vpc/           # Network foundation
│   ├── ec2/           # Virtual servers
│   ├── security_groups/ # Firewall rules
│   ├── s3/            # File storage
│   ├── guardduty/     # Security monitoring
│   ├── security_hub/  # Security compliance
│   ├── cloudwatch/    # Monitoring & alerts
│   └── iam/           # User permissions
└── README.md          # This file!
```

---

## What are Terraform Modules?

**Modules** are like **Lego blocks** for your infrastructure. Each module is a self-contained package that creates a specific set of resources.

### Why Use Modules?

- **Reusability** - Use the same module in different projects
- **Organization** - Keep related resources together
- **Teamwork** - Different team members can work on different modules
- **Testing** - Test modules independently
- **Learning** - Easier to understand what each part does

### Module Structure Example

Each module follows this pattern:
```
module_name/
├── main.tf      # Creates the actual resources
├── variables.tf # What the module needs as input
└── outputs.tf   # What the module provides to others
```

---

## Variables: The ${var.environment} Magic

### What is ${var.environment}?

`${var.environment}` is a **variable reference** in Terraform. It's like a **placeholder** that gets replaced with an actual value when you run Terraform.

### Variable Syntax Breakdown

```hcl
# This is a variable declaration
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# This is how you use it
resource "aws_instance" "example" {
  tags = {
    Name        = "web-server-${var.environment}"
    Environment = var.environment
  }
}
```

### What Happens When You Run It?

If you set `environment = "prod"`, Terraform will create:
```hcl
tags = {
  Name        = "web-server-prod"
  Environment = "prod"
}
```

If you set `environment = "dev"`, Terraform will create:
```hcl
tags = {
  Name        = "web-server-dev"
  Environment = "dev"
}
```

---

## How to Use This Project

### Prerequisites

1. **Install Terraform** - Download from [terraform.io](https://terraform.io)
2. **Install AWS CLI** - Download from [aws.amazon.com](https://aws.amazon.com)
3. **Configure AWS Credentials** - Run `aws configure`

### Step-by-Step Deployment

#### Step 1: Navigate to Terraform Directory
```bash
cd terraform
```

#### Step 2: Initialize Terraform
```bash
terraform init
```
**What this does:** Downloads required providers (AWS, etc.) and sets up your working directory.

#### Step 3: Plan Your Deployment
```bash
terraform plan
```
**What this does:** Shows you exactly what Terraform will create, modify, or delete. **Always run this first!**

#### Step 4: Apply Your Infrastructure
```bash
terraform apply
```
**What this does:** Actually creates your AWS resources. Type `yes` when prompted.

#### Step 5: Destroy When Done (Optional)
```bash
terraform destroy
```
**What this does:** Removes all created resources to avoid AWS charges.

---

## Customizing Your Infrastructure

### Editing Variables

Open `variables.tf` and modify these values:

```hcl
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"  # Change this to your preferred region
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"        # Change to: staging, prod, etc.
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"   # Change to: t3.small, t3.medium, etc.
}
```

### Environment-Specific Deployments

Create different configurations for different environments:

**Development:**
```bash
terraform apply -var="environment=dev" -var="instance_type=t3.micro"
```

**Production:**
```bash
terraform apply -var="environment=prod" -var="instance_type=t3.medium"
```

---

## Clean Infrastructure Code Principles

### 1. Use Meaningful Names

**Bad:**
```hcl
resource "aws_instance" "server" {
  tags = {
    Name = "test"
  }
}
```

**Good:**
```hcl
resource "aws_instance" "web_server" {
  tags = {
    Name        = "web-server-${var.environment}"
    Environment = var.environment
    Project     = "security-lab"
    ManagedBy   = "terraform"
  }
}
```

### 2. Use Variables for Everything

**Bad:**
```hcl
resource "aws_security_group" "web" {
  name        = "web-sg"
  description = "Security group for web servers"
  vpc_id      = "vpc-12345678"
}
```

**Good:**
```hcl
resource "aws_security_group" "web" {
  name        = "${var.environment}-web-sg"
  description = "Security group for ${var.environment} web servers"
  vpc_id      = var.vpc_id
}
```

### 3. Use Modules for Reusability

**Bad:**
```hcl
# Copy-pasting the same security group code everywhere
resource "aws_security_group" "web1" { ... }
resource "aws_security_group" "web2" { ... }
resource "aws_security_group" "web3" { ... }
```

**Good:**
```hcl
# Create a reusable security group module
module "web_security_group" {
  source = "./modules/security_groups"
  
  vpc_id      = var.vpc_id
  environment = var.environment
  name        = "web"
}
```

### 4. Use Data Sources for Dynamic Values

**Bad:**
```hcl
# Hardcoded AMI ID (will break when AWS updates)
resource "aws_instance" "web" {
  ami = "ami-12345678"
}
```

**Good:**
```hcl
# Dynamically get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  ami = data.aws_ami.amazon_linux_2.id
}
```

---

## Understanding the Main Configuration

### main.tf Breakdown

```hcl
# Terraform and AWS Provider Configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider Configuration
provider "aws" {
  region = var.aws_region
}

# VPC Module - Creates your network foundation
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr             = var.vpc_cidr
  environment          = var.environment
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# Security Groups Module - Creates firewall rules
module "security_groups" {
  source = "./modules/security_groups"
  
  vpc_id = module.vpc.vpc_id  # Uses output from VPC module
  environment = var.environment
}

# EC2 Module - Creates your virtual servers
module "ec2" {
  source = "./modules/ec2"
  
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  security_group_ids = module.security_groups.security_group_ids
  key_pair_name = var.key_pair_name
  instance_type = var.instance_type
  environment = var.environment
}
```

---

## Common Mistakes to Avoid

### 1. Not Running `terraform plan`
**Always** run `terraform plan` before `terraform apply` to see what will happen!

### 2. Hardcoding Values
Don't hardcode IDs, names, or other values. Use variables instead.

### 3. Not Using Tags
Always tag your resources for cost tracking and organization.

### 4. Ignoring State Files
Don't delete `.tfstate` files - they track your infrastructure!

### 5. Running Terraform from Multiple Places
Only run Terraform from one location to avoid conflicts.

---

## Troubleshooting Common Issues

### Error: "Provider configuration not found"
**Solution:** Run `terraform init` to download providers.

### Error: "Access denied"
**Solution:** Check your AWS credentials with `aws sts get-caller-identity`.

### Error: "Resource already exists"
**Solution:** Import existing resources or destroy them first.

### Error: "Invalid region"
**Solution:** Check your `aws_region` variable in `variables.tf`.

---

## Learning Resources

- **Official Docs:** [terraform.io/docs](https://terraform.io/docs)
- **HashiCorp Learn:** [learn.hashicorp.com](https://learn.hashicorp.com)
- **GitHub Examples:** [github.com/hashicorp/terraform](https://github.com/hashicorp/terraform)
- **Community:** [discuss.hashicorp.com](https://discuss.hashicorp.com)

---

## Next Steps

1. **Deploy this infrastructure** using the steps above
2. **Explore the modules** to understand how they work
3. **Modify variables** to customize your setup
4. **Create your own modules** for new resources
5. **Read the official Terraform documentation**

---

## Need Help?

- **Check this README** first
- **Look at the module READMEs** in each module folder
- **Ask questions** in the project discussions
- **Report issues** if you find bugs

---

**Happy Infrastructure Building! Remember: Infrastructure as Code is a journey, not a destination!**