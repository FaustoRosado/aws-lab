# Enable Security Hub
resource "aws_securityhub_account" "main" {
  enable_default_standards = true
  auto_enable_controls     = true

  tags = {
    Name        = "${var.environment}-security-hub"
    Environment = var.environment
  }
}

# Security Hub Standards
resource "aws_securityhub_standards_subscription" "cis_aws_foundations" {
  depends_on = [aws_securityhub_account.main]
  
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
}

resource "aws_securityhub_standards_subscription" "aws_foundational_security" {
  depends_on = [aws_securityhub_account.main]
  
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/aws-foundational-security-best-practices/v/1.0.0"
}

# Security Hub Actions
resource "aws_securityhub_action_target" "guardduty_findings" {
  name        = "${var.environment}-guardduty-findings-action"
  identifier  = "GuardDutyFindings"
  description = "Action target for GuardDuty findings"

  tags = {
    Name        = "${var.environment}-guardduty-findings-action"
    Environment = var.environment
  }
}

# Security Hub Insights
resource "aws_securityhub_insight" "high_severity_findings" {
  group_by_attribute = "SeverityLabel"
  name              = "${var.environment}-high-severity-findings"

  filters {
    severity_label {
      eq = ["HIGH", "CRITICAL"]
    }
  }

  tags = {
    Name        = "${var.environment}-high-severity-findings"
    Environment = var.environment
  }
}

resource "aws_securityhub_insight" "guardduty_findings" {
  group_by_attribute = "ProductName"
  name              = "${var.environment}-guardduty-findings"

  filters {
    product_name {
      eq = ["GuardDuty"]
    }
  }

  tags = {
    Name        = "${var.environment}-guardduty-findings"
    Environment = var.environment
  }
}

# Data source for current region
data "aws_region" "current" {}
