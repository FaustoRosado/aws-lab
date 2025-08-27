// security.tf (Updated) - Security Resources

// Purpose: Consolidates all security-related infrastructure.
// This file defines services like GuardDuty and Security Hub that monitor
// and protect your AWS account and resources. It also includes security
// groups and key pairs.

// Creates a CloudWatch Log Group to store logs from your application.
resource "aws_cloudwatch_log_group" "my_app_log_group" {
  name              = "/aws/ec2/my-app-${random_pet.pet_name.id}"
  retention_in_days = 30 // Retain logs for 30 days

  tags = {
    Name = "My App Log Group"
  }
}

// Creates the GuardDuty detector, which is a required component for the service.
resource "aws_guardduty_detector" "main" {
  enable = true
}

// NOTE: This resource has been commented out because the 'location' URL
// provided was a placeholder that is not a valid threat feed.
// You can uncomment this block and replace the 'location' URL with a
// valid publicly accessible threat feed file to enable this functionality.

resource "aws_guardduty_threatintelset" "threat_intel_set" {
  detector_id = aws_guardduty_detector.main.id
  name        = "my-threat-intel-set"
  format      = "TXT" 
  location    = "https://s3.us-east-1.amazonaws.com/${aws_s3_bucket.threat_intel_bucket.id}/${aws_s3_object.threat_list_file.key}"
  activate    = true
}

// A random name generator to ensure unique resource names.
// This helps prevent naming conflicts, especially for resources like S3 buckets.
resource "random_pet" "pet_name" {
  length = 2
}
