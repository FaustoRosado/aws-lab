# Instructor Access Configuration - P2W12 Lab
# Provides secure, temporary access for instructors to view lab environment

# ========================================
# INSTRUCTOR IAM USER (Temporary Access)
# ========================================

# Temporary IAM user for instructor access
resource "aws_iam_user" "instructor" {
  name = "p2w12-instructor-${formatdate("YYYYMMDD", timestamp())}"
  
  tags = {
    Name        = "P2W12-Instructor-Access"
    Project     = "Quantum-Shield-Cyber-Range"
    Team        = "P2W12"
    Environment = "Lab"
    Purpose     = "Instructor-Demo-Access"
    Expires     = formatdate("YYYY-MM-DD", timeadd(timestamp(), "20d"))
    ManagedBy   = "Terraform"
  }
}

# IAM policy for instructor console access
resource "aws_iam_user_policy" "instructor_console_access" {
  name = "instructor-console-access-policy"
  user = aws_iam_user.instructor.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeRouteTables",
          "ec2:DescribeNetworkAcls",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeVolumes",
          "ec2:DescribeTags",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeImages",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeRegions",
          "ec2:DescribeAvailabilityZones"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:GetMetricData",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricStatistics"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "iam:GetUser",
          "iam:ListAttachedUserPolicies",
          "iam:ListUserPolicies"
        ]
        Resource = aws_iam_user.instructor.arn
      }
    ]
  })
}

# ========================================
# INSTRUCTOR IAM ROLE (Cross-Account Access)
# ========================================

# IAM role for cross-account instructor access
resource "aws_iam_role" "instructor_role" {
  name = "p2w12-instructor-role-${formatdate("YYYYMMDD", timestamp())}"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::*:root"  # Allow any AWS account to assume
        }
        Action = "sts:AssumeRole"
        Condition = {
          StringEquals = {
            "aws:RequestTag/Project" = "Quantum-Shield-Cyber-Range"
          }
          StringLike = {
            "aws:PrincipalTag/Instructor" = "true"
          }
        }
      }
    ]
  })

  tags = {
    Name        = "P2W12-Instructor-Role"
    Project     = "Quantum-Shield-Cyber-Range"
    Team        = "P2W12"
    Environment = "Lab"
    Purpose     = "Cross-Account-Instructor-Access"
    Expires     = formatdate("YYYY-MM-DD", timeadd(timestamp(), "20d"))
    ManagedBy   = "Terraform"
  }
}

# Policy for the instructor role
resource "aws_iam_role_policy" "instructor_role_policy" {
  name = "instructor-role-policy"
  role = aws_iam_role.instructor_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeVpcs",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeRouteTables",
          "ec2:DescribeNetworkAcls",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeVolumes",
          "ec2:DescribeTags",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeImages",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeRegions",
          "ec2:DescribeAvailabilityZones"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:GetMetricData",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:ListMetrics",
          "cloudwatch:GetMetricStatistics"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents",
          "logs:FilterLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

# ========================================
# ACCESS CREDENTIALS OUTPUT
# ========================================

# Output instructor access information
output "instructor_access_info" {
  description = "Information for instructor access to AWS Console"
  value = {
    iam_user_name = aws_iam_user.instructor.name
    iam_user_arn  = aws_iam_user.instructor.arn
    iam_role_name = aws_iam_role.instructor_role.name
    iam_role_arn  = aws_iam_role.instructor_role.arn
    access_expires = formatdate("YYYY-MM-DD HH:mm:ss UTC", timeadd(timestamp(), "20d"))
    console_url    = "https://console.aws.amazon.com/"
  }
}

# Output the assume role command for instructors
output "instructor_assume_role_command" {
  description = "Command for instructors to assume the role"
  value = "aws sts assume-role --role-arn ${aws_iam_role.instructor_role.arn} --role-session-name InstructorDemo --tags Key=Project,Value=Quantum-Shield-Cyber-Range Key=Instructor,Value=true"
}
