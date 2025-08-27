# s3.tf

# This resource creates the S3 bucket where you will store your threat intelligence list.

resource "aws_s3_bucket" "threat_intel_bucket" {
  bucket = "seize-the-bucket"

  tags = {
    Name = "GuardDuty Threat Intel"
  }
}

# This resource creates a specific S3 object (the file) within your bucket.
# You can use this to upload a static list of IPs directly with Terraform.

resource "aws_s3_object" "threat_list_file" {
  bucket = aws_s3_bucket.threat_intel_bucket.id
  key    = "Threatlists.txt"
  
  # Use the `content` argument to embed the file content directly
  content = <<EOT
192.0.2.1/32
192.168.10.7
198.51.100.0/24
203.0.113.5/32
EOT
}

# This is the S3 bucket policy that grants GuardDuty the permissions to read your threat list file.
resource "aws_s3_bucket_policy" "threat_intel_policy" {
  bucket = aws_s3_bucket.threat_intel_bucket.id

  # The 'jsonencode' function helps format the policy document correctly.
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "GuardDutyThreatIntel",
        Effect = "Allow",
        Principal = {
          Service = "guardduty.amazonaws.com"
        },
        Action = "s3:GetObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.threat_intel_bucket.id}/${aws_s3_object.threat_list_file.key}"
      }
    ]
  })
}
