# Enable GuardDuty
resource "aws_guardduty_detector" "main" {
  enable = true

  tags = {
    Name        = "${var.environment}-guardduty-detector"
    Environment = var.environment
  }
}

# GuardDuty Findings SNS Topic
resource "aws_sns_topic" "guardduty_findings" {
  name = "${var.environment}-guardduty-findings"

  tags = {
    Name        = "${var.environment}-guardduty-findings"
    Environment = var.environment
  }
}

# SNS Topic Policy
resource "aws_sns_topic_policy" "guardduty_findings" {
  arn = aws_sns_topic.guardduty_findings.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "guardduty.amazonaws.com"
        }
        Action = "SNS:Publish"
        Resource = aws_sns_topic.guardduty_findings.arn
      }
    ]
  })
}

# GuardDuty Publishing Destination
resource "aws_guardduty_publishing_destination" "main" {
  detector_id     = aws_guardduty_detector.main.id
  destination_arn = aws_sns_topic.guardduty_findings.arn
  kms_key_arn     = "alias/aws/guardduty"
}

# GuardDuty Threat Intel Set (Sample malicious IPs)
resource "aws_guardduty_threat_intel_set" "malicious_ips" {
  activate    = true
  detector_id = aws_guardduty_detector.main.id
  format      = "TXT"
  location    = "https://s3.amazonaws.com/${var.s3_bucket_name}/threats/ip_blacklist.txt"
  name        = "${var.environment}-malicious-ips"

  tags = {
    Name        = "${var.environment}-malicious-ips"
    Environment = var.environment
  }
}

# GuardDuty IP Set (Sample trusted IPs)
resource "aws_guardduty_ip_set" "trusted_ips" {
  activate    = true
  detector_id = aws_guardduty_detector.main.id
  format      = "TXT"
  location    = "https://s3.amazonaws.com/${var.s3_bucket_name}/threats/trusted_ips.txt"
  name        = "${var.environment}-trusted-ips"

  tags = {
    Name        = "${var.environment}-trusted-ips"
    Environment = var.environment
  }
}
