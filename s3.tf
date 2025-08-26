// s3.tf - S3 Bucket Configuration

// This file defines an AWS S3 bucket to be created and managed by Terraform.
// S3 is an object storage service that can be used for various purposes,
// such as a backend for your website, file storage, or data archiving.

// It is best practice to use a random suffix to ensure the bucket name is globally unique.

resource "aws_s3_bucket" "my_app_bucket" {
  bucket = "${var.s3_bucket_name}-${random_string.suffix.result}"

  tags = {
    Name        = var.s3_bucket_name
    Environment = "prod"
  }
}

// Blocks public access to the bucket to enhance security.

resource "aws_s3_bucket_public_access_block" "my_app_bucket" {
  bucket = aws_s3_bucket.my_app_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

// Provides a random suffix for the bucket name to ensure global uniqueness.

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}
