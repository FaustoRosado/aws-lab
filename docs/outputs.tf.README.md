# Outputs.tf Documentation - Resource Information Guide

This guide explains the output values provided by the AWS Security Lab Terraform configuration and how to use them effectively.

## Overview

The `outputs.tf` file defines what information is exposed after your infrastructure is deployed. These outputs provide:
- Resource identifiers for further configuration
- Connection information for accessing your resources
- Status information for monitoring and troubleshooting
- Data for integration with other tools and services

## Output Categories

### Network Information

These outputs provide details about your VPC and networking setup.

#### VPC Information
```hcl
output "vpc_id" {
  description = "ID of the main VPC"
  value       = module.vpc.vpc_id
}

output "vpc_arn" {
  description = "ARN of the main VPC"
  value       = module.vpc.vpc_arn
}

output "vpc_cidr_block" {
  description = "CIDR block of the main VPC"
  value       = module.vpc.vpc_cidr_block
}
```

**Usage**: Use these values to reference your VPC in other configurations
**Example**: Reference VPC ID in security group rules or route table configurations

#### Subnet Information
```hcl
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_cidr_blocks" {
  description = "CIDR blocks of the public subnets"
  value       = module.vpc.public_subnet_cidr_blocks
}
```

**Usage**: Use subnet IDs to place resources in specific network locations
**Example**: Place web servers in public subnets and databases in private subnets

#### Route Table Information
```hcl
output "public_route_table_id" {
  description = "ID of the public route table"
  value       = module.vpc.public_route_table_id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = module.vpc.private_route_table_id
}
```

**Usage**: Use these IDs to configure routing for additional resources
**Example**: Add custom routes or modify existing routing behavior

### Compute Resources

These outputs provide information about your EC2 instances and related resources.

#### Instance Information
```hcl
output "web_server_instance_id" {
  description = "ID of the web server instance"
  value       = module.ec2.web_server_instance_id
}

output "database_server_instance_id" {
  description = "ID of the database server instance"
  value       = module.ec2.database_server_instance_id
}
```

**Usage**: Use instance IDs for management operations
**Example**: Stop, start, or terminate specific instances

#### Connection Information
```hcl
output "web_server_public_ip" {
  description = "Public IP address of the web server"
  value       = module.ec2.web_server_public_ip
}

output "web_server_public_dns" {
  description = "Public DNS name of the web server"
  value       = module.ec2.web_server_public_dns
}

output "web_server_private_ip" {
  description = "Private IP address of the web server"
  value       = module.ec2.web_server_private_ip
}
```

**Usage**: Use these values to connect to your instances
**Example**: SSH to web server using public IP, connect to database using private IP

#### SSH Key Information
```hcl
output "ssh_key_name" {
  description = "Name of the SSH key pair"
  value       = module.ec2.ssh_key_name
}

output "ssh_key_fingerprint" {
  description = "Fingerprint of the SSH key pair"
  value       = module.ec2.ssh_key_fingerprint
}
```

**Usage**: Use key name for SSH connections
**Example**: `ssh -i ssh/lab-key ec2-user@[PUBLIC_IP]`

### Security Resources

These outputs provide information about your security configuration.

#### Security Group Information
```hcl
output "public_ec2_sg_id" {
  description = "ID of the public EC2 security group"
  value       = module.security_groups.public_ec2_sg_id
}

output "private_ec2_sg_id" {
  description = "ID of the private EC2 security group"
  value       = module.security_groups.private_ec2_sg_id
}

output "database_sg_id" {
  description = "ID of the database security group"
  value       = module.security_groups.database_sg_id
}
```

**Usage**: Use security group IDs to apply security rules to new resources
**Example**: Apply existing security groups to additional instances

#### Security Group Rules
```hcl
output "public_ec2_sg_rules" {
  description = "Security group rules for public EC2 instances"
  value       = module.security_groups.public_ec2_sg_rules
}
```

**Usage**: Review security group configuration for compliance
**Example**: Verify that only necessary ports are open

### Storage Resources

These outputs provide information about your S3 buckets and storage configuration.

#### S3 Bucket Information
```hcl
output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3.bucket_name
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = module.s3.bucket_arn
}

output "s3_bucket_region" {
  description = "Region of the S3 bucket"
  value       = module.s3.bucket_region
}
```

**Usage**: Use bucket information for data uploads and access
**Example**: Upload files to your S3 bucket using the bucket name

#### S3 Configuration
```hcl
output "s3_bucket_versioning" {
  description = "Versioning status of the S3 bucket"
  value       = module.s3.bucket_versioning
}

output "s3_bucket_encryption" {
  description = "Encryption configuration of the S3 bucket"
  value       = module.s3.bucket_encryption
}
```

**Usage**: Verify S3 bucket security configuration
**Example**: Ensure versioning and encryption are properly configured

### Security Services

These outputs provide information about your security monitoring services.

#### GuardDuty Information
```hcl
output "guardduty_detector_id" {
  description = "ID of the GuardDuty detector"
  value       = module.guardduty.detector_id
}

output "guardduty_detector_arn" {
  description = "ARN of the GuardDuty detector"
  value       = module.guardduty.detector_arn
}
```

**Usage**: Use detector ID to check for security findings
**Example**: Query GuardDuty for security threats and anomalies

#### Security Hub Information
```hcl
output "security_hub_hub_arn" {
  description = "ARN of the Security Hub"
  value       = module.security_hub.hub_arn
}

output "security_hub_enabled_standards" {
  description = "List of enabled security standards"
  value       = module.security_hub.enabled_standards
}
```

**Usage**: Use Security Hub information for compliance monitoring
**Example**: Check compliance status and review security findings

#### CloudWatch Information
```hcl
output "cloudwatch_log_groups" {
  description = "Names of CloudWatch log groups"
  value       = module.cloudwatch.log_group_names
}

output "cloudwatch_dashboard_arn" {
  description = "ARN of the CloudWatch dashboard"
  value       = module.cloudwatch.dashboard_arn
}
```

**Usage**: Use CloudWatch information for monitoring and logging
**Example**: View logs and metrics in the CloudWatch console

### IAM Resources

These outputs provide information about your identity and access management setup.

#### User Information
```hcl
output "iam_user_names" {
  description = "Names of created IAM users"
  value       = module.iam.user_names
}

output "iam_user_arns" {
  description = "ARNs of created IAM users"
  value       = module.iam.user_arns
}
```

**Usage**: Use user information for access management
**Example**: Grant additional permissions or create access keys

#### Group Information
```hcl
output "iam_group_names" {
  description = "Names of created IAM groups"
  value       = module.iam.group_names
}

output "iam_group_arns" {
  description = "ARNs of created IAM groups"
  value       = module.iam.group_arns
}
```

**Usage**: Use group information for permission management
**Example**: Add users to groups or modify group policies

#### Access Key Information
```hcl
output "access_key_ids" {
  description = "Access key IDs for created users"
  value       = module.iam.access_key_ids
}

output "secret_access_keys" {
  description = "Secret access keys for created users"
  value       = module.iam.secret_access_keys
  sensitive   = true
}
```

**Usage**: Use access keys for programmatic access
**Example**: Configure AWS CLI or SDK with new access keys

## Using Outputs

### Command Line Access

View outputs after deployment:

```bash
# View all outputs
terraform output

# View specific output
terraform output vpc_id

# View output in JSON format
terraform output -json

# View output in raw format
terraform output -raw vpc_id
```

### Programmatic Access

Use outputs in other Terraform configurations:

```hcl
# Reference VPC ID in another module
module "additional_resources" {
  source = "./modules/additional_resources"
  
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
}
```

### Integration with Other Tools

Use outputs with external tools and scripts:

```bash
# Get VPC ID for use in scripts
VPC_ID=$(terraform output -raw vpc_id)

# Use in AWS CLI commands
aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID"

# Use in other tools
echo "VPC ID: $VPC_ID" >> config.txt
```

## Output Customization

### Adding New Outputs

To add new outputs for your specific needs:

```hcl
# Add custom output
output "custom_resource_id" {
  description = "ID of custom resource"
  value       = aws_resource.custom.id
}

# Add computed output
output "resource_count" {
  description = "Total number of resources created"
  value       = length(aws_instance.main)
}

# Add formatted output
output "connection_string" {
  description = "Database connection string"
  value       = "mysql://${module.ec2.database_server_private_ip}:3306/labdb"
}
```

### Modifying Existing Outputs

To modify existing outputs:

```hcl
# Change output description
output "vpc_id" {
  description = "ID of the main VPC for the lab environment"
  value       = module.vpc.vpc_id
}

# Add additional formatting
output "web_server_url" {
  description = "URL to access the web server"
  value       = "http://${module.ec2.web_server_public_ip}"
}
```

### Conditional Outputs

Use conditional logic for outputs:

```hcl
# Output based on condition
output "monitoring_enabled" {
  description = "Whether monitoring is enabled"
  value       = var.enable_monitoring ? "Yes" : "No"
}

# Output based on resource existence
output "load_balancer_dns" {
  description = "DNS name of the load balancer"
  value       = var.enable_load_balancer ? module.lb.dns_name : "Not configured"
}
```

## Output Security

### Sensitive Outputs

Mark sensitive outputs appropriately:

```hcl
output "database_password" {
  description = "Database administrator password"
  value       = random_password.db_password.result
  sensitive   = true
}

output "api_key" {
  description = "API key for external services"
  value       = random_string.api_key.result
  sensitive   = true
}
```

**Security Benefits**:
- Prevents accidental exposure in logs
- Hides sensitive values in console output
- Protects credentials and secrets

### Access Control

Control who can view outputs:

```hcl
# Output only for administrators
output "admin_credentials" {
  description = "Administrator access credentials"
  value       = module.iam.admin_credentials
  sensitive   = true
  
  # Only show to users with admin role
  depends_on = [module.iam.admin_role]
}
```

## Output Validation

### Output Validation Rules

Ensure outputs meet your requirements:

```hcl
output "instance_count" {
  description = "Number of instances created"
  value       = length(module.ec2.instance_ids)
  
  # Validate output value
  validation {
    condition     = length(module.ec2.instance_ids) >= 1
    error_message = "At least one instance must be created."
  }
}
```

### Common Validation Patterns

1. **Range Validation**
   ```hcl
   validation {
     condition     = var.output_value >= 1 && var.output_value <= 100
     error_message = "Output value must be between 1 and 100."
   }
   ```

2. **Format Validation**
   ```hcl
   validation {
     condition     = can(regex("^[a-z0-9-]+$", var.output_value))
     error_message = "Output value must contain only lowercase letters, numbers, and hyphens."
   }
   ```

3. **Dependency Validation**
   ```hcl
   validation {
     condition     = var.dependency_resource != null
     error_message = "Dependency resource must exist before output can be created."
   }
   ```

## Troubleshooting Outputs

### Common Issues

1. **Output Not Found**
   ```bash
   # Check if output exists
   terraform output -json | jq 'keys'
   
   # Check output definition
   grep -r "output \"output_name\"" .
   ```

2. **Output Value is Null**
   ```bash
   # Check resource state
   terraform show
   
   # Check for resource creation errors
   terraform plan
   ```

3. **Output Format Issues**
   ```bash
   # Check output format
   terraform output -json output_name
   
   # Use raw output for simple values
   terraform output -raw output_name
   ```

### Debugging Tips

1. **Use Terraform Console**
   ```bash
   terraform console
   > module.vpc.vpc_id
   > module.ec2.web_server_public_ip
   ```

2. **Check Resource State**
   ```bash
   # View current state
   terraform state list
   
   # View specific resource
   terraform state show aws_vpc.main
   ```

3. **Validate Configuration**
   ```bash
   # Check syntax
   terraform validate
   
   # Check plan
   terraform plan
   ```

## Best Practices

### Output Design

1. **Use Descriptive Names**
   - Good: `web_server_public_ip`
   - Bad: `ip`

2. **Provide Clear Descriptions**
   - Explain what the output represents
   - Include usage examples when helpful

3. **Group Related Outputs**
   - Network outputs together
   - Security outputs together
   - Compute outputs together

### Output Organization

1. **Logical Grouping**
   - Group outputs by service or function
   - Use consistent naming conventions
   - Order outputs logically

2. **Documentation**
   - Document each output's purpose
   - Provide usage examples
   - Include troubleshooting tips

3. **Maintenance**
   - Review outputs regularly
   - Remove unused outputs
   - Update descriptions as needed

## Integration Examples

### AWS CLI Integration

Use outputs with AWS CLI:

```bash
# Get VPC ID and list resources
VPC_ID=$(terraform output -raw vpc_id)
aws ec2 describe-instances --filters "Name=vpc-id,Values=$VPC_ID"

# Get subnet IDs and create resources
SUBNET_IDS=$(terraform output -json private_subnet_ids | jq -r '.[]')
aws ec2 create-instance --subnet-id $SUBNET_IDS
```

### Script Integration

Use outputs in scripts:

```bash
#!/bin/bash
# Get infrastructure information
WEB_SERVER_IP=$(terraform output -raw web_server_public_ip)
DB_SERVER_IP=$(terraform output -raw database_server_private_ip)

# Test connectivity
echo "Testing web server connectivity..."
curl -s "http://$WEB_SERVER_IP" > /dev/null && echo "Web server accessible" || echo "Web server not accessible"

echo "Testing database connectivity..."
ssh -i ssh/lab-key ec2-user@$WEB_SERVER_IP "ping -c 1 $DB_SERVER_IP" && echo "Database accessible" || echo "Database not accessible"
```

### CI/CD Integration

Use outputs in CI/CD pipelines:

```yaml
# GitHub Actions example
- name: Get Infrastructure Info
  run: |
    echo "VPC_ID=$(terraform output -raw vpc_id)" >> $GITHUB_ENV
    echo "WEB_SERVER_IP=$(terraform output -raw web_server_public_ip)" >> $GITHUB_ENV

- name: Run Tests
  run: |
    curl -f "http://${{ env.WEB_SERVER_IP }}/health" || exit 1
```

## Next Steps

After understanding the outputs:

1. **Review Available Outputs** - See what information is exposed
2. **Customize Outputs** - Add outputs for your specific needs
3. **Integrate with Tools** - Use outputs with scripts and other tools
4. **Monitor Changes** - Track output values as infrastructure changes
5. **Document Usage** - Document how outputs are used in your environment

---

**Remember**: Outputs are the bridge between your infrastructure and the tools that use it. Understanding and customizing them will help you integrate your lab with other systems and automate your workflows.
