# CloudWatch Log Group for Security Lab
resource "aws_cloudwatch_log_group" "security_lab" {
  name              = "/aws/security-lab/${var.environment}"
  retention_in_days = 7

  tags = {
    Name        = "${var.environment}-security-lab-logs"
    Environment = var.environment
  }
}

# CloudWatch Log Group for EC2 instances
resource "aws_cloudwatch_log_group" "ec2_logs" {
  name              = "/aws/ec2/${var.environment}"
  retention_in_days = 7

  tags = {
    Name        = "${var.environment}-ec2-logs"
    Environment = var.environment
  }
}

# CloudWatch Dashboard for Security Monitoring
resource "aws_cloudwatch_dashboard" "security_dashboard" {
  dashboard_name = "${var.environment}-security-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/GuardDuty", "FindingCount", "Environment", var.environment],
            [".", "FindingCount", "Severity", "HIGH"],
            [".", "FindingCount", "Severity", "CRITICAL"]
          ]
          period = 300
          stat   = "Sum"
          region = "us-east-1"
          title  = "GuardDuty Findings"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/SecurityHub", "FindingCount", "Environment", var.environment]
          ]
          period = 300
          stat   = "Sum"
          region = "us-east-1"
          title  = "Security Hub Findings"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "${var.environment}-asg"],
            [".", "NetworkIn", ".", "."],
            [".", "NetworkOut", ".", "."]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "EC2 Performance Metrics"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/VPC", "ActiveConnectionCount", "VPCId", var.vpc_id]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "VPC Network Activity"
        }
      }
    ]
  })
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.environment}-high-cpu-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"
  alarm_description   = "This metric monitors EC2 CPU utilization"
  alarm_actions       = []

  tags = {
    Name        = "${var.environment}-high-cpu-alarm"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_metric_alarm" "guardduty_findings" {
  alarm_name          = "${var.environment}-guardduty-findings-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FindingCount"
  namespace           = "AWS/GuardDuty"
  period              = "300"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "This metric monitors GuardDuty findings"
  alarm_actions       = []

  tags = {
    Name        = "${var.environment}-guardduty-findings-alarm"
    Environment = var.environment
  }
}
