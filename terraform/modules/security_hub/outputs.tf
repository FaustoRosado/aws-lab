output "security_hub_account_id" {
  description = "Security Hub account ID"
  value       = aws_securityhub_account.main.id
}

output "security_hub_arn" {
  description = "Security Hub ARN"
  value       = aws_securityhub_account.main.arn
}
