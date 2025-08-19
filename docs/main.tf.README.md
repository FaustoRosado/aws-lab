# Main.tf Documentation - Infrastructure Configuration Guide

This guide explains the main Terraform configuration file and how it orchestrates the deployment of your AWS Security Lab infrastructure.

## Overview

The `main.tf` file is the central configuration file that defines how all the modules work together to create your complete lab environment. Understanding this file will help you:
- Understand the overall architecture
- Modify the deployment configuration
- Troubleshoot deployment issues
- Customize the lab for your needs

## File Structure

### Provider Configuration

The file begins with AWS provider configuration:

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

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      Owner       = var.owner
      ManagedBy   = "Terraform"
    }
  }
}
```

**Purpose**: Configures the AWS provider and sets default tags
**Key Features**: 
- Version constraints for compatibility
- Default tags applied to all resources
- Region configuration from variables

### Data Sources

Data sources retrieve information about existing AWS resources:

```hcl
data "aws_caller_identity" "current" {
  # Gets information about the current AWS user/role
}

data "aws_availability_zones" "available" {
  state = "available"
}
```

**Purpose**: Get information about your AWS account and available resources
**Usage**: Reference account ID, availability zones, and other existing resources

## Module Configuration

### VPC Module

The VPC module creates the network foundation:

```hcl
module "vpc" {
  source = "./modules/vpc"
  
  environment           = var.environment
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.public_subnet_cidrs
  
  tags = {
    Purpose = "Security Lab Networking"
    Type    = "VPC"
  }
}
```

**Purpose**: Creates VPC, subnets, route tables, and internet connectivity
**Dependencies**: None (first module to deploy)
**Outputs**: VPC ID, subnet IDs, route table IDs

### Security Groups Module

The security groups module defines network security rules:

```hcl
module "security_groups" {
  source = "./modules/security_groups"
  
  environment = var.environment
  vpc_id     = module.vpc.vpc_id
  
  tags = {
    Purpose = "Security Lab Network Security"
    Type    = "Security Groups"
  }
}
```

**Purpose**: Creates security groups with appropriate access rules
**Dependencies**: VPC module (needs VPC ID)
**Outputs**: Security group IDs for different resource types

### EC2 Module

The EC2 module deploys virtual servers:

```hcl
module "ec2" {
  source = "./modules/ec2"
  
  environment           = var.environment
  vpc_id               = module.vpc.vpc_id
  public_subnet_ids    = module.vpc.public_subnet_ids
  private_subnet_ids   = module.vpc.private_subnet_ids
  public_ec2_sg_id     = module.security_groups.public_ec2_sg_id
  private_ec2_sg_id    = module.security_groups.private_ec2_sg_id
  
  instance_type        = var.instance_type
  ami_id               = var.ami_id
  key_pair_name        = var.key_pair_name
  
  tags = {
    Purpose = "Security Lab Compute Resources"
    Type    = "EC2 Instances"
  }
}
```

**Purpose**: Creates web server and database server instances
**Dependencies**: VPC and Security Groups modules
**Outputs**: Instance IDs, IP addresses, connection information

### S3 Module

The S3 module creates secure object storage:

```hcl
module "s3" {
  source = "./modules/s3"
  
  environment  = var.environment
  bucket_name  = var.s3_bucket_name
  
  tags = {
    Purpose = "Security Lab Data Storage"
    Type    = "S3 Bucket"
  }
}
```

**Purpose**: Creates S3 bucket with security features
**Dependencies**: None (can deploy independently)
**Outputs**: Bucket name, ARN, and configuration details

### GuardDuty Module

The GuardDuty module enables threat detection:

```hcl
module "guardduty" {
  source = "./modules/guardduty"
  
  environment = var.environment
  aws_region = var.aws_region
  
  tags = {
    Purpose = "Security Lab Threat Detection"
    Type    = "GuardDuty"
  }
}
```

**Purpose**: Enables continuous security monitoring
**Dependencies**: None (can deploy independently)
**Outputs**: Detector ID and configuration

### Security Hub Module

The Security Hub module centralizes security findings:

```hcl
module "security_hub" {
  source = "./modules/security_hub"
  
  environment = var.environment
  aws_region = var.aws_region
  
  tags = {
    Purpose = "Security Lab Security Management"
    Type    = "Security Hub"
  }
}
```

**Purpose**: Provides centralized security view and compliance monitoring
**Dependencies**: None (can deploy independently)
**Outputs**: Hub ARN and enabled standards

### CloudWatch Module

The CloudWatch module provides monitoring and logging:

```hcl
module "cloudwatch" {
  source = "./modules/cloudwatch"
  
  environment = var.environment
  
  log_retention_days = var.log_retention_days
  enable_detailed_monitoring = var.enable_detailed_monitoring
  
  tags = {
    Purpose = "Security Lab Monitoring"
    Type    = "CloudWatch"
  }
}
```

**Purpose**: Sets up monitoring, logging, and alerting
**Dependencies**: None (can deploy independently)
**Outputs**: Log group names and dashboard ARNs

### IAM Module

The IAM module manages user access and permissions:

```hcl
module "iam" {
  source = "./modules/iam"
  
  environment = var.environment
  users      = var.iam_users
  groups     = var.iam_groups
  
  tags = {
    Purpose = "Security Lab Access Management"
    Type    = "IAM"
  }
}
```

**Purpose**: Creates users, groups, and policies for access control
**Dependencies**: None (can deploy independently)
**Outputs**: User names, group names, and access key information

## Module Dependencies

### Dependency Order

The modules must be deployed in this order due to dependencies:

1. **VPC Module** - Creates network foundation
2. **Security Groups Module** - Depends on VPC ID
3. **EC2 Module** - Depends on VPC and Security Groups
4. **Other Modules** - Can deploy independently or in parallel

### Dependency Management

Terraform automatically manages dependencies when you reference module outputs:

```hcl
# EC2 module depends on VPC and Security Groups
module "ec2" {
  # ... other configuration ...
  
  vpc_id             = module.vpc.vpc_id           # Creates dependency
  public_subnet_ids  = module.vpc.public_subnet_ids # Creates dependency
  public_ec2_sg_id   = module.security_groups.public_ec2_sg_id # Creates dependency
}
```

## Configuration Variables

### Variable References

The main.tf file references variables defined in `variables.tf`:

```hcl
# Environment configuration
environment = var.environment
project_name = var.project_name

# Network configuration
vpc_cidr = var.vpc_cidr
availability_zones = var.availability_zones

# Compute configuration
instance_type = var.instance_type
ami_id = var.ami_id

# Security configuration
enable_ssh_access = var.enable_ssh_access
allowed_ssh_ips = var.allowed_ssh_ips
```

### Variable Usage Patterns

1. **Direct Assignment**: Pass variables directly to modules
2. **Computed Values**: Use variables in calculations
3. **Conditional Logic**: Use variables in conditional statements

## Resource Tagging

### Default Tags

Default tags are applied to all resources:

```hcl
provider "aws" {
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      Owner       = var.owner
      ManagedBy   = "Terraform"
      CreatedAt   = timestamp()
    }
  }
}
```

### Module-Specific Tags

Additional tags can be applied to specific modules:

```hcl
module "vpc" {
  # ... configuration ...
  
  tags = {
    Purpose = "Security Lab Networking"
    Type    = "VPC"
    CostCenter = "Security"
  }
}
```

## Deployment Strategies

### Full Deployment

Deploy all modules at once:

```bash
terraform init
terraform plan
terraform apply
```

### Module-by-Module Deployment

Deploy modules individually:

```bash
# Deploy VPC first
terraform apply -target=module.vpc

# Deploy Security Groups
terraform apply -target=module.security_groups

# Deploy EC2 instances
terraform apply -target=module.ec2

# Deploy remaining modules
terraform apply
```

### Selective Deployment

Deploy only specific modules:

```bash
# Deploy only networking and compute
terraform apply -target=module.vpc -target=module.security_groups -target=module.ec2
```

## Customization Options

### Adding New Modules

To add new functionality:

```hcl
module "new_service" {
  source = "./modules/new_service"
  
  environment = var.environment
  vpc_id     = module.vpc.vpc_id
  
  # Add module-specific variables
  service_config = var.new_service_config
  
  tags = {
    Purpose = "Security Lab New Service"
    Type    = "NewService"
  }
}
```

### Modifying Existing Modules

To customize existing modules:

```hcl
module "ec2" {
  source = "./modules/ec2"
  
  # Override default values
  instance_type = "t3.small"  # Instead of var.instance_type
  instance_count = 3          # Add custom instance count
  
  # ... rest of configuration ...
}
```

### Conditional Module Deployment

Deploy modules based on conditions:

```hcl
module "monitoring" {
  count  = var.enable_monitoring ? 1 : 0
  source = "./modules/monitoring"
  
  environment = var.environment
  # ... other configuration ...
}
```

## Error Handling

### Common Issues

1. **Module Not Found**
   - Check module source path
   - Verify module directory exists
   - Check for typos in module names

2. **Variable Not Found**
   - Check variable definitions in variables.tf
   - Verify variable names match
   - Check for typos in variable references

3. **Dependency Issues**
   - Verify module dependencies are correct
   - Check that required outputs exist
   - Ensure modules are deployed in correct order

### Troubleshooting Steps

1. **Validate Configuration**
   ```bash
   terraform validate
   ```

2. **Check Plan**
   ```bash
   terraform plan
   ```

3. **Review State**
   ```bash
   terraform state list
   terraform show
   ```

4. **Check Logs**
   ```bash
   terraform plan -detailed-exitcode
   ```

## Performance Considerations

### Parallel Deployment

Modules without dependencies can deploy in parallel:

```hcl
# These modules can deploy simultaneously
module "s3" { ... }
module "guardduty" { ... }
module "security_hub" { ... }
module "cloudwatch" { ... }
module "iam" { ... }
```

### Resource Limits

Consider AWS service limits:

```hcl
# Limit concurrent resource creation
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      configuration_aliases = [aws.primary, aws.secondary]
    }
  }
}
```

## Security Considerations

### Access Control

Ensure proper IAM permissions:

```hcl
# Use least privilege principle
# Only grant necessary permissions to Terraform user/role
```

### Resource Isolation

Use tags for resource isolation:

```hcl
tags = {
  Environment = var.environment
  Project     = var.project_name
  Owner       = var.owner
  SecurityLevel = "Lab"
}
```

### Data Protection

Protect sensitive data:

```hcl
# Never hardcode secrets
# Use variables for sensitive values
# Mark sensitive outputs appropriately
```

## Monitoring and Maintenance

### Resource Monitoring

Monitor deployed resources:

```bash
# Check resource status
terraform state list

# View resource details
terraform state show aws_vpc.main

# Check for drift
terraform plan
```

### Configuration Updates

Update configuration safely:

```bash
# Review changes
terraform plan

# Apply updates
terraform apply

# Verify changes
terraform show
```

### Cleanup

Remove resources when done:

```bash
# Destroy all resources
terraform destroy

# Destroy specific modules
terraform destroy -target=module.ec2
```

## Best Practices

### Configuration Management

1. **Use Variables**: Avoid hardcoding values
2. **Consistent Naming**: Use consistent naming conventions
3. **Documentation**: Document complex configurations
4. **Version Control**: Use version control for configuration

### Module Design

1. **Single Responsibility**: Each module has one purpose
2. **Reusability**: Design modules for reuse
3. **Dependency Management**: Minimize unnecessary dependencies
4. **Output Design**: Provide useful outputs

### Security

1. **Least Privilege**: Grant minimal necessary permissions
2. **Resource Tagging**: Tag all resources appropriately
3. **Access Control**: Control who can access resources
4. **Monitoring**: Monitor resource usage and access

## Next Steps

After understanding the main.tf file:

1. **Review Module Configuration** - Understand how each module is configured
2. **Customize Variables** - Modify variables to match your requirements
3. **Add New Modules** - Extend functionality with additional modules
4. **Test Changes** - Validate configuration before applying
5. **Document Customizations** - Keep track of your modifications

---

**Remember**: The main.tf file is the blueprint for your entire infrastructure. Understanding how it works will help you customize and extend your lab environment effectively.
