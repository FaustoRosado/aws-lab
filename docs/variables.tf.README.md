# Variables.tf Documentation - Configuration Guide

This guide explains the variables used in the AWS Security Lab Terraform configuration and how to customize them for your needs.

## Overview

The `variables.tf` file defines all the input parameters that control how your infrastructure is deployed. Understanding these variables will help you:
- Customize your lab environment
- Control costs and resource usage
- Adapt the configuration for different scenarios
- Troubleshoot configuration issues

## Variable Categories

### Environment Configuration

These variables control the overall lab environment and naming conventions.

#### Environment Name
```hcl
variable "environment" {
  description = "Environment name for resource tagging and naming"
  type        = string
  default     = "lab"
}
```

**Purpose**: Sets the environment name used for all resources
**Usage**: Change to "dev", "staging", "prod", or any custom name
**Impact**: Affects resource names, tags, and organization

#### Project Name
```hcl
variable "project_name" {
  description = "Project name for resource identification"
  type        = string
  default     = "aws-security-lab"
}
```

**Purpose**: Identifies the project for resource management
**Usage**: Change to match your project or organization
**Impact**: Used in resource naming and tagging

#### Owner
```hcl
variable "owner" {
  description = "Resource owner for cost tracking and management"
  type        = string
  default     = "your-name"
}
```

**Purpose**: Identifies who owns the resources
**Usage**: Set to your name, team, or organization
**Impact**: Used for cost allocation and resource ownership

### AWS Configuration

These variables control AWS-specific settings and regions.

#### AWS Region
```hcl
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}
```

**Purpose**: Determines which AWS region hosts your resources
**Usage**: Change to any AWS region (e.g., "us-west-2", "eu-west-1")
**Impact**: Affects resource location, pricing, and availability

#### AWS Profile
```hcl
variable "aws_profile" {
  description = "AWS CLI profile to use for authentication"
  type        = string
  default     = "default"
}
```

**Purpose**: Specifies which AWS credentials to use
**Usage**: Change to match your AWS CLI profile name
**Impact**: Controls which AWS account and permissions are used

### Network Configuration

These variables control your VPC and networking setup.

#### VPC CIDR Block
```hcl
variable "vpc_cidr" {
  description = "Main VPC network range"
  type        = string
  default     = "10.0.0.0/16"
}
```

**Purpose**: Defines the IP address range for your VPC
**Usage**: Change to any private IP range (e.g., "172.16.0.0/16")
**Impact**: Determines available IP addresses and subnet ranges

#### Availability Zones
```hcl
variable "availability_zones" {
  description = "AWS availability zones to deploy subnets into"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}
```

**Purpose**: Specifies which availability zones to use
**Usage**: Change to match your region's available AZs
**Impact**: Affects high availability and resource distribution

#### Public Subnet CIDRs
```hcl
variable "public_subnet_cidrs" {
  description = "IP ranges for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
```

**Purpose**: Defines IP ranges for internet-facing subnets
**Usage**: Ensure these are subsets of your VPC CIDR
**Impact**: Controls public subnet IP addressing

#### Private Subnet CIDRs
```hcl
variable "private_subnet_cidrs" {
  description = "IP ranges for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}
```

**Purpose**: Defines IP ranges for internal subnets
**Usage**: Ensure these are subsets of your VPC CIDR
**Impact**: Controls private subnet IP addressing

### EC2 Configuration

These variables control your virtual server setup.

#### Instance Type
```hcl
variable "instance_type" {
  description = "EC2 instance type (size/power)"
  type        = string
  default     = "t3.micro"
}
```

**Purpose**: Determines the size and capabilities of your instances
**Usage**: Change based on your needs (e.g., "t3.small", "t3.medium")
**Impact**: Affects performance, cost, and resource limits

#### AMI ID
```hcl
variable "ami_id" {
  description = "Amazon Machine Image ID (operating system)"
  type        = string
  default     = "ami-0c02fb55956c7d316"  # Amazon Linux 2
}
```

**Purpose**: Specifies which operating system to use
**Usage**: Change to different AMIs for different OS versions
**Impact**: Affects OS features, security, and compatibility

#### Key Pair Name
```hcl
variable "key_pair_name" {
  description = "Name of the SSH key pair for instance access"
  type        = string
  default     = "lab-key"
}
```

**Purpose**: Specifies which SSH key to use for instance access
**Usage**: Change to match your existing key pair or create a new one
**Impact**: Controls SSH access to your instances

### Security Configuration

These variables control security settings and access controls.

#### Enable SSH Access
```hcl
variable "enable_ssh_access" {
  description = "Enable SSH access to instances"
  type        = bool
  default     = true
}
```

**Purpose**: Controls whether SSH access is allowed
**Usage**: Set to false to disable SSH access for security
**Impact**: Affects instance security and remote access

#### Allowed SSH IPs
```hcl
variable "allowed_ssh_ips" {
  description = "IP addresses allowed to SSH to instances"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # WARNING: Allows all IPs
}
```

**Purpose**: Restricts SSH access to specific IP addresses
**Usage**: Change to your IP address or office network range
**Impact**: Significantly improves security when restricted

#### Enable Web Access
```hcl
variable "enable_web_access" {
  description = "Enable web access to instances"
  type        = bool
  default     = true
}
```

**Purpose**: Controls whether web traffic is allowed
**Usage**: Set to false to disable web access
**Impact**: Affects web server accessibility

### Monitoring Configuration

These variables control monitoring and logging settings.

#### Enable CloudWatch Logs
```hcl
variable "enable_cloudwatch_logs" {
  description = "Enable CloudWatch logging for instances"
  type        = bool
  default     = true
}
```

**Purpose**: Controls whether instance logs are sent to CloudWatch
**Usage**: Set to false to disable logging (not recommended)
**Impact**: Affects monitoring capabilities and troubleshooting

#### Log Retention Days
```hcl
variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 30
}
```

**Purpose**: Controls how long logs are kept
**Usage**: Change based on compliance and storage requirements
**Impact**: Affects storage costs and log availability

#### Enable Detailed Monitoring
```hcl
variable "enable_detailed_monitoring" {
  description = "Enable detailed CloudWatch monitoring"
  type        = bool
  default     = false
}
```

**Purpose**: Controls monitoring granularity
**Usage**: Set to true for production environments
**Impact**: Affects monitoring costs and detail level

### Cost Control

These variables help manage costs and resource usage.

#### Enable Auto Scaling
```hcl
variable "enable_auto_scaling" {
  description = "Enable auto scaling for instances"
  type        = bool
  default     = false
}
```

**Purpose**: Controls whether instances can scale automatically
**Usage**: Set to true for production workloads
**Impact**: Affects costs and resource management

#### Instance Count
```hcl
variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 2
  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}
```

**Purpose**: Controls how many instances are created
**Usage**: Change based on your needs and budget
**Impact**: Directly affects costs and resource usage

#### Enable Spot Instances
```hcl
variable "enable_spot_instances" {
  description = "Use spot instances for cost savings"
  type        = bool
  default     = false
}
```

**Purpose**: Controls whether to use spot instances
**Usage**: Set to true for non-critical workloads
**Impact**: Can significantly reduce costs but may cause interruptions

## Variable Validation

### Input Validation

Terraform provides validation rules to ensure variables meet your requirements:

```hcl
variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 2
  
  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}
```

### Common Validation Patterns

1. **Range Validation**
   ```hcl
   validation {
     condition     = var.value >= 1 && var.value <= 100
     error_message = "Value must be between 1 and 100."
   }
   ```

2. **String Pattern Validation**
   ```hcl
   validation {
     condition     = can(regex("^[a-z0-9-]+$", var.name))
     error_message = "Name must contain only lowercase letters, numbers, and hyphens."
   }
   ```

3. **List Length Validation**
   ```hcl
   validation {
     condition     = length(var.subnets) >= 2
     error_message = "At least 2 subnets are required for high availability."
   }
   ```

## Variable Overrides

### Command Line Overrides

Override variables when running Terraform commands:

```bash
# Override single variable
terraform apply -var="instance_type=t3.small"

# Override multiple variables
terraform apply -var="instance_type=t3.small" -var="instance_count=3"

# Override with file
terraform apply -var-file="production.tfvars"
```

### Variable Files

Create `.tfvars` files for different environments:

```hcl
# development.tfvars
environment = "dev"
instance_type = "t3.micro"
instance_count = 1
enable_detailed_monitoring = false

# production.tfvars
environment = "prod"
instance_type = "t3.medium"
instance_count = 3
enable_detailed_monitoring = true
```

### Environment Variables

Use environment variables for sensitive values:

```bash
# Set environment variables
export TF_VAR_db_password="secret123"
export TF_VAR_api_key="key456"

# Run Terraform
terraform apply
```

## Best Practices

### Variable Naming

1. **Use Descriptive Names**
   - Good: `web_server_instance_type`
   - Bad: `wst`

2. **Use Consistent Conventions**
   - Use snake_case for variable names
   - Use descriptive prefixes for related variables

3. **Group Related Variables**
   - Network variables: `vpc_*`, `subnet_*`
   - Security variables: `security_*`, `access_*`
   - Monitoring variables: `monitoring_*`, `log_*`

### Default Values

1. **Provide Sensible Defaults**
   - Use values that work for most users
   - Avoid requiring users to set every variable

2. **Document Defaults**
   - Explain what each default value means
   - Provide examples of when to change defaults

3. **Use Conditional Defaults**
   ```hcl
   variable "instance_type" {
     description = "EC2 instance type"
     type        = string
     default     = var.environment == "prod" ? "t3.medium" : "t3.micro"
   }
   ```

### Security Considerations

1. **Never Hardcode Secrets**
   - Use environment variables or secret management
   - Avoid committing sensitive values to version control

2. **Validate Inputs**
   - Use validation rules to prevent invalid values
   - Sanitize user inputs to prevent injection attacks

3. **Use Least Privilege**
   - Only request necessary permissions
   - Document why each permission is needed

## Troubleshooting Variables

### Common Issues

1. **Variable Not Found**
   ```bash
   # Check variable definition
   grep -r "variable \"variable_name\"" .
   
   # Check variable usage
   grep -r "var.variable_name" .
   ```

2. **Type Mismatch**
   ```bash
   # Validate configuration
   terraform validate
   
   # Check variable types
   terraform console
   > var.variable_name
   ```

3. **Validation Errors**
   ```bash
   # Check validation rules
   terraform plan
   
   # Review error messages
   # Fix validation conditions
   ```

### Debugging Tips

1. **Use Terraform Console**
   ```bash
   terraform console
   > var.environment
   > var.instance_count
   ```

2. **Check Variable Values**
   ```bash
   # Show all variable values
   terraform plan -var-file="debug.tfvars"
   ```

3. **Use Output Variables**
   ```hcl
   output "debug_variables" {
     value = {
       environment = var.environment
       instance_type = var.instance_type
       instance_count = var.instance_count
     }
   }
   ```

## Customization Examples

### Development Environment

```hcl
# development.tfvars
environment = "dev"
instance_type = "t3.micro"
instance_count = 1
enable_detailed_monitoring = false
log_retention_days = 7
allowed_ssh_ips = ["192.168.1.0/24"]
```

### Production Environment

```hcl
# production.tfvars
environment = "prod"
instance_type = "t3.medium"
instance_count = 3
enable_detailed_monitoring = true
log_retention_days = 90
allowed_ssh_ips = ["10.0.0.0/8"]
```

### Testing Environment

```hcl
# testing.tfvars
environment = "test"
instance_type = "t3.nano"
instance_count = 2
enable_detailed_monitoring = false
log_retention_days = 1
allowed_ssh_ips = ["0.0.0.0/0"]
```

## Next Steps

After understanding the variables:

1. **Review Current Values** - Check what values are currently set
2. **Customize for Your Needs** - Modify variables to match your requirements
3. **Create Environment Files** - Set up different configurations for different environments
4. **Test Changes** - Validate your configuration before applying
5. **Document Your Setup** - Keep track of your customizations

---

**Remember**: Variables are the control knobs of your infrastructure. Understanding and customizing them will help you create the exact environment you need for learning and experimentation.
