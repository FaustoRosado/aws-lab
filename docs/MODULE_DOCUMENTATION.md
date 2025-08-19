# Module Documentation Guide

This guide explains how to understand and work with the Terraform modules in the AWS Security Lab.

## Overview

The AWS Security Lab uses a modular Terraform architecture where each AWS service is managed by a separate, reusable module. This approach provides:
- Clear separation of concerns
- Reusable infrastructure components
- Easier maintenance and updates
- Better testing and validation

## Module Structure

Each module follows a consistent structure:

```
module_name/
├── main.tf           # Main resource definitions
├── variables.tf      # Input variable definitions
├── outputs.tf        # Output value definitions
└── README.md         # Module documentation
```

## Core Modules

### VPC Module (`modules/vpc/`)

**Purpose**: Creates the network foundation for your lab environment.

**What it creates**:
- Virtual Private Cloud (VPC)
- Public and private subnets
- Internet Gateway and NAT Gateway
- Route tables and routing rules

**Key resources**:
- `aws_vpc.main` - Main VPC resource
- `aws_subnet.public` - Public subnets for internet-facing resources
- `aws_subnet.private` - Private subnets for internal resources
- `aws_internet_gateway.main` - Internet connectivity for public subnets
- `aws_nat_gateway.main` - Outbound internet access for private subnets

**Usage example**:
```hcl
module "vpc" {
  source = "./modules/vpc"
  
  environment = "lab"
  vpc_cidr = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
}
```

### Security Groups Module (`modules/security_groups/`)

**Purpose**: Defines network security rules for your resources.

**What it creates**:
- Security groups for different resource types
- Inbound and outbound traffic rules
- Tagged security groups for organization

**Key resources**:
- `aws_security_group.public_ec2` - Security group for public-facing EC2 instances
- `aws_security_group.private_ec2` - Security group for private EC2 instances
- `aws_security_group.database` - Security group for database resources

**Usage example**:
```hcl
module "security_groups" {
  source = "./modules/security_groups"
  
  environment = "lab"
  vpc_id = module.vpc.vpc_id
}
```

### EC2 Module (`modules/ec2/`)

**Purpose**: Deploys virtual servers for your lab environment.

**What it creates**:
- Web server instance in public subnet
- Database server instance in private subnet
- SSH key pair for secure access
- User data scripts for automatic configuration

**Key resources**:
- `aws_instance.web_server` - Public-facing web server
- `aws_instance.database_server` - Private database server
- `aws_key_pair.lab_key` - SSH key pair for instance access

**Usage example**:
```hcl
module "ec2" {
  source = "./modules/ec2"
  
  environment = "lab"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  public_ec2_sg_id = module.security_groups.public_ec2_sg_id
  private_ec2_sg_id = module.security_groups.private_ec2_sg_id
}
```

### S3 Module (`modules/s3/`)

**Purpose**: Creates secure object storage for your lab data.

**What it creates**:
- S3 bucket with encryption enabled
- Bucket policies for access control
- Versioning for data protection
- Sample data for testing

**Key resources**:
- `aws_s3_bucket.main` - Main S3 bucket
- `aws_s3_bucket_versioning.main` - Versioning configuration
- `aws_s3_bucket_server_side_encryption.main` - Encryption configuration

**Usage example**:
```hcl
module "s3" {
  source = "./modules/s3"
  
  environment = "lab"
  bucket_name = "my-security-lab-bucket"
}
```

### GuardDuty Module (`modules/guardduty/`)

**Purpose**: Enables threat detection and monitoring.

**What it creates**:
- GuardDuty detector for threat detection
- Data source configuration
- SNS topic for security alerts
- IAM roles for service access

**Key resources**:
- `aws_guardduty_detector.main` - Main threat detection service
- `aws_sns_topic.guardduty_alerts` - Topic for security notifications
- `aws_guardduty_member.main` - Account membership configuration

**Usage example**:
```hcl
module "guardduty" {
  source = "./modules/guardduty"
  
  environment = "lab"
  aws_region = "us-east-1"
}
```

### Security Hub Module (`modules/security_hub/`)

**Purpose**: Centralizes security findings and compliance monitoring.

**What it creates**:
- Security Hub service activation
- Security standards enablement
- Integration with other security services
- Compliance monitoring setup

**Key resources**:
- `aws_securityhub_account.main` - Security Hub service account
- `aws_securityhub_standards_subscription.main` - Security standards subscription

**Usage example**:
```hcl
module "security_hub" {
  source = "./modules/security_hub"
  
  environment = "lab"
  aws_region = "us-east-1"
}
```

### CloudWatch Module (`modules/cloudwatch/`)

**Purpose**: Provides monitoring, logging, and alerting capabilities.

**What it creates**:
- CloudWatch log groups
- CloudWatch alarms
- CloudWatch dashboards
- Metric filters and insights

**Key resources**:
- `aws_cloudwatch_log_group.main` - Log groups for resource logging
- `aws_cloudwatch_metric_alarm.main` - Alarms for monitoring
- `aws_cloudwatch_dashboard.main` - Monitoring dashboards

**Usage example**:
```hcl
module "cloudwatch" {
  source = "./modules/cloudwatch"
  
  environment = "lab"
  log_retention_days = 30
}
```

### IAM Module (`modules/iam/`)

**Purpose**: Manages user access and permissions.

**What it creates**:
- IAM users and groups
- IAM policies and permissions
- Access keys for programmatic access
- Role-based access control

**Key resources**:
- `aws_iam_user.main` - IAM user accounts
- `aws_iam_group.main` - IAM groups for permission management
- `aws_iam_policy.main` - Custom IAM policies
- `aws_iam_access_key.main` - Access keys for users

**Usage example**:
```hcl
module "iam" {
  source = "./modules/iam"
  
  environment = "lab"
  users = [
    {
      name = "admin-user"
      groups = ["administrators"]
      access_keys = ["admin-key"]
    }
  ]
}
```

## Module Dependencies

Understanding module dependencies is crucial for proper deployment:

### Dependency Order

1. **VPC Module** - Must be deployed first (network foundation)
2. **Security Groups Module** - Depends on VPC
3. **EC2 Module** - Depends on VPC and Security Groups
4. **S3 Module** - Independent, can be deployed anytime
5. **GuardDuty Module** - Independent, can be deployed anytime
6. **Security Hub Module** - Independent, can be deployed anytime
7. **CloudWatch Module** - Independent, can be deployed anytime
8. **IAM Module** - Independent, can be deployed anytime

### Dependency Management

Terraform automatically manages dependencies when you reference module outputs:

```hcl
# EC2 module depends on VPC and Security Groups
module "ec2" {
  source = "./modules/ec2"
  
  # These create implicit dependencies
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  public_ec2_sg_id = module.security_groups.public_ec2_sg_id
}
```

## Module Configuration

### Variable Types

Each module uses different variable types:

1. **String Variables** - Simple text values
   ```hcl
   variable "environment" {
     description = "Environment name"
     type        = string
     default     = "lab"
   }
   ```

2. **List Variables** - Collections of values
   ```hcl
   variable "availability_zones" {
     description = "AWS availability zones"
     type        = list(string)
     default     = ["us-east-1a", "us-east-1b"]
   }
   ```

3. **Object Variables** - Complex structured data
   ```hcl
   variable "users" {
     description = "IAM users to create"
     type = list(object({
       name = string
       groups = list(string)
       access_keys = list(string)
     }))
   }
   ```

### Output Values

Modules provide outputs for other modules to use:

```hcl
# VPC module outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}
```

## Customizing Modules

### Modifying Existing Modules

To customize a module for your needs:

1. **Edit Variables** - Modify `variables.tf` to add new options
2. **Update Resources** - Modify `main.tf` to add new resources
3. **Add Outputs** - Modify `outputs.tf` to expose new values
4. **Update Documentation** - Modify `README.md` to reflect changes

### Creating New Modules

To create a new module:

1. **Create Directory** - `mkdir modules/new_service`
2. **Create Files** - Copy structure from existing modules
3. **Define Resources** - Add AWS resources in `main.tf`
4. **Define Variables** - Add input parameters in `variables.tf`
5. **Define Outputs** - Add output values in `outputs.tf`
6. **Add Documentation** - Create comprehensive `README.md`

## Testing Modules

### Local Testing

Test modules individually:

```bash
# Navigate to module directory
cd modules/vpc

# Initialize Terraform
terraform init

# Plan deployment
terraform plan

# Apply changes
terraform apply
```

### Integration Testing

Test modules together:

```bash
# From terraform root directory
terraform init
terraform plan
terraform apply
```

## Troubleshooting Modules

### Common Issues

1. **Module Not Found**
   - Check module path in source
   - Verify module directory exists
   - Check for typos in module names

2. **Variable Errors**
   - Check variable types match
   - Verify required variables are provided
   - Check variable validation rules

3. **Resource Conflicts**
   - Check for duplicate resource names
   - Verify resource dependencies
   - Check for conflicting configurations

### Debugging Tips

1. **Use Terraform Plan** - Always run `terraform plan` before apply
2. **Check Logs** - Review Terraform output for error details
3. **Validate Syntax** - Use `terraform validate` to check syntax
4. **Check State** - Use `terraform show` to inspect current state

## Best Practices

### Module Design

1. **Single Responsibility** - Each module should have one clear purpose
2. **Consistent Naming** - Use consistent naming conventions across modules
3. **Proper Documentation** - Document all variables, outputs, and resources
4. **Error Handling** - Include validation and error checking

### Security Considerations

1. **Least Privilege** - Grant minimal necessary permissions
2. **Encryption** - Enable encryption for sensitive data
3. **Access Control** - Use security groups and IAM policies
4. **Monitoring** - Enable logging and monitoring

### Cost Optimization

1. **Resource Tagging** - Tag all resources for cost tracking
2. **Right-sizing** - Use appropriate instance types and sizes
3. **Cleanup** - Implement proper cleanup procedures
4. **Monitoring** - Monitor costs and usage

## Module Versioning

### Version Management

Consider versioning your modules:

1. **Git Tags** - Use semantic versioning (v1.0.0, v1.1.0)
2. **Module Sources** - Reference specific versions in your configurations
3. **Changelog** - Maintain a changelog for each module
4. **Backward Compatibility** - Maintain compatibility when possible

### Example Versioning

```hcl
# Reference specific module version
module "vpc" {
  source = "git::https://github.com/yourusername/aws-security-lab.git//modules/vpc?ref=v1.2.0"
  
  environment = "lab"
}
```

## Next Steps

After understanding the module structure:

1. **Explore Individual Modules** - Review each module's code and documentation
2. **Customize for Your Needs** - Modify modules to fit your requirements
3. **Create New Modules** - Add new services or functionality
4. **Contribute Back** - Share improvements with the community

---

**Remember**: Modules are the building blocks of your infrastructure. Understanding how they work together will help you build more complex and maintainable systems.
