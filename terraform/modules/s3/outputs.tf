output "threat_intel_bucket_name" {
  description = "Name of the threat intelligence S3 bucket"
  value       = aws_s3_bucket.threat_intel.bucket
}

output "threat_intel_bucket_arn" {
  description = "ARN of the threat intelligence S3 bucket"
  value       = aws_s3_bucket.threat_intel.arn
}
