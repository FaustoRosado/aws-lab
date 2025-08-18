output "security_lab_log_group" {
  description = "Security lab CloudWatch log group"
  value       = aws_cloudwatch_log_group.security_lab.name
}

output "ec2_log_group" {
  description = "EC2 CloudWatch log group"
  value       = aws_cloudwatch_log_group.ec2_logs.name
}

output "security_dashboard" {
  description = "Security monitoring dashboard"
  value       = aws_cloudwatch_dashboard.security_dashboard.dashboard_name
}
