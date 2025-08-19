# Main.tf - The Infrastructure Conductor

## What is main.tf?

**main.tf** is like the **conductor of an orchestra** - it doesn't play the instruments itself, but it tells everyone when to start, how to work together, and what the final result should sound like.

In Terraform terms, `main.tf` is the **orchestrator** that:
- **Defines the overall structure** of your infrastructure
- **Connects all the modules** together
- **Sets the order** of operations
- **Determines the final result**

---

## Why This Architecture Matters for Learning

### Modular Thinking
Instead of one giant, confusing file, you have:
- **Small, focused modules** - Each does one thing well
- **Clear responsibilities** - VPC handles networking, EC2 handles servers
- **Reusable components** - Use the same VPC module in different projects

### Understanding Dependencies
Learn how infrastructure components depend on each other:
- **VPC must exist** before you can create subnets
- **Security groups need VPC ID** to be created
- **EC2 instances need** subnets and security groups

### Progressive Learning
- **Start simple** - Understand one module at a time
- **Build complexity** - See how modules work together
- **Master the whole** - Understand the complete architecture

---

## How main.tf Works (Step by Step)

### Step 1: Terraform Configuration
```hcl
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

**What this does:**
- **Sets minimum Terraform version** (ensures compatibility)
- **Specifies AWS provider** (the tool that talks to AWS)
- **Sets provider version** (ensures consistent behavior)

**Why this matters for learning:**
- **Version control** - Different Terraform versions behave differently
- **Provider management** - Understand how Terraform connects to cloud services
- **Compatibility** - Learn to specify requirements clearly

### Step 2: AWS Provider Configuration
```hcl
provider "aws" {
  region = var.aws_region
}
```

**What this does:**
- **Tells Terraform** which AWS region to use
- **Uses a variable** instead of hardcoding the region

**Why this matters for learning:**
- **Provider concept** - Terraform needs to know which cloud service to use
- **Variable usage** - Shows how to make configurations flexible
- **Region awareness** - Different regions have different features and costs

### Step 3: VPC Module (Network Foundation)
```hcl
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr             = var.vpc_cidr
  environment          = var.environment
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}
```

**What this does:**
- **Creates the VPC module** - Your network foundation
- **Passes variables** to configure the VPC
- **Uses relative path** `./modules/vpc` to find the module

**Why this matters for learning:**
- **Module syntax** - Learn how to call modules
- **Variable passing** - See how data flows from main config to modules
- **Source paths** - Understand how Terraform finds your modules

### Step 4: Security Groups Module (Firewall Rules)
```hcl
module "security_groups" {
  source = "./modules/security_groups"
  
  vpc_id     = module.vpc.vpc_id
  environment = var.environment
}
```

**What this does:**
- **Creates security groups** - Your network firewall rules
- **References VPC ID** from the VPC module output
- **Waits for VPC** to be created first

**Why this matters for learning:**
- **Module dependencies** - See how modules reference each other
- **Output usage** - Learn how modules share information
- **Order of operations** - Understand what must happen first

### Step 5: EC2 Module (Virtual Servers)
```hcl
module "ec2" {
  source = "./modules/ec2"
  
  vpc_id               = module.vpc.vpc_id
  public_subnet_ids    = module.vpc.public_subnet_ids
  private_subnet_ids   = module.vpc.private_subnet_ids
  public_ec2_sg_id     = module.security_groups.public_ec2_sg_id
  private_ec2_sg_id    = module.security_groups.private_ec2_sg_id
  
  instance_type        = var.instance_type
  ami_id               = var.ami_id
  key_pair_name        = var.key_pair_name
}
```

**What this does:**
- **Creates EC2 instances** - Your virtual servers
- **References multiple outputs** from VPC and Security Groups modules
- **Waits for all dependencies** to be ready

**Why this matters for learning:**
- **Complex dependencies** - See how one module needs multiple others
- **Resource placement** - Learn how to put resources in specific subnets
- **Security integration** - Understand how security groups protect instances

---

## Module Dependencies Explained

### The Dependency Chain
```
VPC Module → Security Groups Module → EC2 Module
    ↓              ↓                    ↓
  Creates      Needs VPC ID        Needs VPC, Subnets, and Security Groups
  VPC &        to create           to place instances and apply security rules
  Subnets      security groups
```

### Why This Order Matters
1. **VPC First**: Creates the network foundation
2. **Security Groups Second**: Creates firewall rules within the VPC
3. **EC2 Third**: Places servers in the network with proper security

### What Happens If You Change the Order?
- **Terraform will fail** if you try to create security groups before VPC
- **Error messages** will tell you what's missing
- **Automatic ordering** - Terraform figures out the right order automatically

---

## Variables and Configuration

### How Variables Flow
```
variables.tf → main.tf → modules → AWS resources
     ↓            ↓         ↓          ↓
  Define      Pass to    Use to    Create
  values      modules    create    actual
  here       here       resources resources
```

### Example Variable Flow
```hcl
# In variables.tf
variable "instance_type" {
  default = "t3.micro"
}

# In main.tf
module "ec2" {
  instance_type = var.instance_type  # Passes "t3.micro"
}

# In modules/ec2/main.tf
resource "aws_instance" "web_server" {
  instance_type = var.instance_type  # Receives "t3.micro"
}
```

### Why Variables Matter
- **Flexibility**: Change values without editing code
- **Reusability**: Use same modules with different settings
- **Environment management**: Different values for dev, staging, prod

---

## Understanding Module Outputs

### What Are Outputs?
Outputs are like **return values** from modules - they give you information about what was created.

### Example Outputs
```hcl
# VPC module outputs
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}
```

### How Outputs Are Used
```hcl
# EC2 module uses VPC outputs
module "ec2" {
  vpc_id            = module.vpc.vpc_id           # Gets VPC ID
  public_subnet_ids = module.vpc.public_subnet_ids # Gets subnet IDs
}
```

### Why This Pattern Matters
- **Information sharing**: Modules can share data with each other
- **Dependency management**: Terraform knows what order to create things
- **Resource references**: Connect resources that need to work together

---

## Common Patterns You'll See

### Pattern 1: Module Configuration
```hcl
module "service_name" {
  source = "./modules/service_name"
  
  # Pass variables
  environment = var.environment
  vpc_id     = module.vpc.vpc_id
  
  # Add tags
  tags = {
    Purpose = "Security Lab"
    Type    = "Service"
  }
}
```

### Pattern 2: Variable References
```hcl
# Always use variables, never hardcode
region = var.aws_region        # Good
region = "us-east-1"          # Bad (hardcoded)
```

### Pattern 3: Module Output References
```hcl
# Reference outputs from other modules
vpc_id = module.vpc.vpc_id
subnet_ids = module.vpc.private_subnet_ids
```

---

## What Happens When You Run Terraform

### Phase 1: Planning
1. **Reads main.tf** - Understands what you want to build
2. **Checks dependencies** - Figures out what order to create things
3. **Creates execution plan** - Shows what will happen

### Phase 2: Execution
1. **Creates VPC** - Network foundation
2. **Creates Security Groups** - Firewall rules
3. **Creates EC2 instances** - Virtual servers
4. **Applies security** - Connects everything together

### Phase 3: Verification
1. **Checks resources** - Verifies everything was created
2. **Shows outputs** - Gives you connection information
3. **Updates state** - Remembers what was created

---

## Troubleshooting Common Issues

### Issue: Module Not Found
**Problem**: Terraform can't find your module
**Solution**: Check the source path in your module call
```hcl
# Make sure this path exists
source = "./modules/vpc"
```

### Issue: Variable Not Found
**Problem**: Terraform can't find a variable you're referencing
**Solution**: Check that the variable is defined in variables.tf
```hcl
# This must exist in variables.tf
variable "instance_type" { ... }
```

### Issue: Dependency Error
**Problem**: Terraform tries to create resources in wrong order
**Solution**: Check that you're referencing module outputs correctly
```hcl
# This creates the right dependency
vpc_id = module.vpc.vpc_id
```

---

## Best Practices for Learning

### Start Simple
1. **Understand one module** at a time
2. **See how it works** in isolation
3. **Then see how** it connects to others

### Use the Plan Command
```bash
terraform plan
```
This shows you exactly what will happen without making changes.

### Read Error Messages Carefully
- **Error messages** tell you exactly what's wrong
- **Line numbers** point to the problem
- **Suggestions** often tell you how to fix it

### Experiment Safely
- **Make small changes** and test them
- **Use terraform plan** before applying
- **Keep backups** of working configurations

---

## Next Steps

### What to Do Next
1. **Read the module files** - Understand what each module does
2. **Try changing variables** - See how it affects your infrastructure
3. **Add new modules** - Extend your lab with additional services
4. **Practice troubleshooting** - Learn from common mistakes

### Learning Path
1. **Basic concepts** - Understand Terraform syntax
2. **Module usage** - Learn how to use existing modules
3. **Module creation** - Create your own modules
4. **Advanced patterns** - Master complex configurations

---

## Summary

**main.tf** is your infrastructure blueprint that:
- **Orchestrates** all the modules
- **Manages dependencies** between components
- **Provides flexibility** through variables
- **Creates a complete** lab environment

Understanding this file helps you:
- **Modify** your lab configuration
- **Troubleshoot** deployment issues
- **Extend** functionality with new modules
- **Learn** infrastructure as code concepts

Remember: **Start simple, build complexity gradually, and always use terraform plan before applying changes.**

---

**Your infrastructure conductor is ready to orchestrate your AWS Security Lab!**
