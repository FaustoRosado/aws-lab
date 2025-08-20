# S3 Bucket for threat intelligence and lab artifacts
resource "aws_s3_bucket" "threat_intel" {
  bucket = var.bucket_name

  # Force destroy for fast cleanup - students can recreate
  force_destroy = true

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Purpose     = "Threat Intelligence Storage"
  }
}

# Bucket versioning
resource "aws_s3_bucket_versioning" "threat_intel" {
  bucket = aws_s3_bucket.threat_intel.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Bucket encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "threat_intel" {
  bucket = aws_s3_bucket.threat_intel.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bucket public access block
resource "aws_s3_bucket_public_access_block" "threat_intel" {
  bucket = aws_s3_bucket.threat_intel.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Bucket policy
resource "aws_s3_bucket_policy" "threat_intel" {
  bucket = aws_s3_bucket.threat_intel.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyPublicRead"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.threat_intel.arn}/*"
        Condition = {
          StringEquals = {
            "aws:PrincipalArn" = "arn:aws:iam::*:root"
          }
        }
      }
    ]
  })
}

# Sample threat intelligence files
resource "aws_s3_object" "sample_threats" {
  for_each = toset([
    "threats/malware_indicators.json",
    "threats/ip_blacklist.txt",
    "threats/domain_blacklist.txt",
    "threats/compromise_artifacts.json"
  ])

  bucket = aws_s3_bucket.threat_intel.id
  key    = each.value
  content = templatefile("${path.module}/sample_data/${each.value}", {
    environment = var.environment
  })

  tags = {
    Name        = "sample-${each.value}"
    Environment = var.environment
  }
}
