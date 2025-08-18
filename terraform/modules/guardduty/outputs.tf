output "detector_id" {
  description = "ID of the GuardDuty detector"
  value       = aws_guardduty_detector.main.id
}

output "detector_arn" {
  description = "ARN of the GuardDuty detector"
  value       = aws_guardduty_detector.main.arn
}

output "sns_topic_arn" {
  description = "ARN of the GuardDuty findings SNS topic"
  value       = aws_sns_topic.guardduty_findings.arn
}
