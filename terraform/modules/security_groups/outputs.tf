output "public_ec2_sg_id" {
  description = "ID of the public EC2 security group"
  value       = aws_security_group.public_ec2.id
}

output "private_ec2_sg_id" {
  description = "ID of the private EC2 security group"
  value       = aws_security_group.private_ec2.id
}

output "vpc_endpoints_sg_id" {
  description = "ID of the VPC endpoints security group"
  value       = aws_security_group.vpc_endpoints.id
}

output "security_group_ids" {
  description = "Map of security group names to IDs"
  value = {
    public_ec2    = aws_security_group.public_ec2.id
    private_ec2   = aws_security_group.private_ec2.id
    vpc_endpoints = aws_security_group.vpc_endpoints.id
  }
}
