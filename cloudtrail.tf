// cloudtrail.tf - CloudTrail Configuration

// Purpose: Sets up API activity logging for your account.
// This is a fundamental security best practice. CloudTrail records every
// API call and event that happens in your AWS account, providing a
// valuable audit trail for security analysis and troubleshooting.


// Creates an S3 bucket to store CloudTrail logs.
resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket = "cloudtrail-logs-${random_pet.pet_name.id}"
}

// Configures the S3 bucket policy to allow CloudTrail to write logs.
resource "aws_s3_bucket_policy" "cloudtrail_logs_policy" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AWSCloudTrailAclCheck",
        Effect    = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action   = "s3:GetBucketAcl",
        Resource = aws_s3_bucket.cloudtrail_logs.arn
      },
      {
        Sid       = "AWSCloudTrailWrite",
        Effect    = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action   = "s3:PutObject",
        Resource = "${aws_s3_bucket.cloudtrail_logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

// Configures the CloudTrail trail.
resource "aws_cloudtrail" "trail" {
  name                          = "my-account-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.id
  include_global_service_events = true
  is_multi_region_trail         = true
}

data "aws_caller_identity" "current" {}

