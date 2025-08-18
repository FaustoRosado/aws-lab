# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

# EC2 Outputs
output "public_web_instance_id" {
  description = "ID of the public web server instance"
  value       = module.ec2_instances.public_web_instance_id
}

output "public_web_public_ip" {
  description = "Public IP of the web server instance"
  value       = module.ec2_instances.public_web_public_ip
}

output "private_db_instance_id" {
  description = "ID of the private database server instance"
  value       = module.ec2_instances.private_db_instance_id
}

output "private_db_private_ip" {
  description = "Private IP of the database server instance"
  value       = module.ec2_instances.private_db_private_ip
}

# Security Group Outputs
output "public_ec2_sg_id" {
  description = "ID of the public EC2 security group"
  value       = module.security_groups.public_ec2_sg_id
}

output "private_ec2_sg_id" {
  description = "ID of the private EC2 security group"
  value       = module.security_groups.private_ec2_sg_id
}

# S3 Outputs
output "threat_intel_bucket_name" {
  description = "Name of the threat intelligence S3 bucket"
  value       = module.s3_bucket.threat_intel_bucket_name
}

# GuardDuty Outputs
output "guardduty_detector_id" {
  description = "ID of the GuardDuty detector"
  value       = module.guardduty.detector_id
}

# Security Hub Outputs
output "security_hub_account_id" {
  description = "Security Hub account ID"
  value       = module.security_hub.security_hub_account_id
}

# CloudWatch Outputs
output "security_dashboard_name" {
  description = "Name of the security monitoring dashboard"
  value       = module.cloudwatch.security_dashboard
}

# IAM Outputs
output "ec2_instance_profile_arn" {
  description = "ARN of the EC2 instance profile"
  value       = module.iam.ec2_instance_profile_arn
}

# Lab Information
output "lab_info" {
  description = "Information about the deployed lab"
  value = {
    lab_name        = "EC2 Compromise & Remediation Lab"
    environment     = var.environment
    region          = var.aws_region
    web_server_url  = "http://${module.ec2_instances.public_web_public_ip}"
    ssh_command     = "ssh -i terraform/modules/ec2/ssh/lab-key ec2-user@${module.ec2_instances.public_web_public_ip}"
    dashboard_url   = "https://console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${module.cloudwatch.security_dashboard}"
  }
}
