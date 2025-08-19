# S3 Module - Object Storage

## What is S3?

**S3 (Simple Storage Service)** is AWS's **object storage service**. Think of it as a **giant digital warehouse** where you can store any type of file - documents, images, videos, backups, and more - with high availability and durability.

### Real-World Analogy

- **S3 Bucket** = A storage unit in your digital warehouse
- **Objects** = Files you store (documents, images, videos)
- **Bucket Policy** = Security rules for who can access your storage
- **Versioning** = Keeping multiple copies of the same file
- **Encryption** = Locking your storage unit with a key
- **Sample Data** = Example files to test and learn with

---

## What This Module Creates

This module sets up **secure and organized storage** for your AWS environment:

- **S3 Buckets** - Storage containers for your files
- **Bucket Policies** - Security rules controlling access
- **Versioning** - Keep multiple versions of files
- **Encryption** - Secure your data at rest
- **Sample Data** - Example files for testing and learning
- **Access Logging** - Track who accesses your data

---

## Module Structure

```
s3/
├── main.tf      # Creates S3 buckets and security features
├── variables.tf # What the module needs as input
├── outputs.tf   # What the module provides to others
├── README.md    # This file!
└── sample_data/ # Example files for testing
    ├── README.md              # Sample data documentation
    └── threats/               # Security threat examples
        └── malware_indicators.json # Sample malware data
```

---

## Input Variables Explained

### Bucket Configuration

```hcl
variable "bucket_name" {
  description = "Name for the S3 bucket (must be globally unique)"
  type        = string
  default     = "my-security-lab-bucket"
}
```

**What this means:** Your S3 bucket will have this name (must be unique across all AWS accounts)

### Environment Configuration

```hcl
variable "environment" {
  description = "Environment name for tagging and naming"
  type        = string
  default     = "lab"
}
```

**What this means:** All S3 resources get tagged with your environment (dev, staging, prod)

### Security Configuration

```hcl
variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Enable server-side encryption for the S3 bucket"
  type        = bool
  default     = true
}
```

**What this means:** 
- **Versioning:** Keeps multiple versions of files (good for backup and recovery)
- **Encryption:** Protects your data with AWS-managed encryption keys

---

## How It Works (Step by Step)

### Step 1: Create S3 Bucket

```hcl
resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name
  
  tags = {
    Name        = "${var.environment}-s3-bucket"
    Environment = var.environment
    Service     = "S3"
  }
}
```

**What this does:** Creates the main S3 bucket where you'll store your files

### Step 2: Enable Versioning

```hcl
resource "aws_s3_bucket_versioning" "main" {
  count  = var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.main.id
  
  versioning_configuration {
    status = "Enabled"
  }
}
```

**What this does:** Enables versioning so you can keep multiple versions of the same file

### Step 3: Enable Encryption

```hcl
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  count  = var.enable_encryption ? 1 : 0
  bucket = aws_s3_bucket.main.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

**What this does:** Encrypts all files stored in the bucket using AES-256 encryption

### Step 4: Create Bucket Policy

```hcl
resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyUnencryptedObjectUploads"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.main.arn}/*"
        Condition = {
          StringNotEquals = {
            "s3:x-amz-server-side-encryption" = "AES256"
          }
        }
      }
    ]
  })
}
```

**What this does:** Creates a policy that denies uploads of unencrypted files

### Step 5: Upload Sample Data

```hcl
resource "aws_s3_object" "sample_data" {
  for_each = fileset("${path.module}/sample_data", "**/*")
  
  bucket = aws_s3_bucket.main.id
  key    = "sample_data/${each.value}"
  source = "${path.module}/sample_data/${each.value}"
  
  tags = {
    Name        = "${var.environment}-sample-data-${each.value}"
    Environment = var.environment
    Type        = "Sample Data"
  }
}
```

**What this does:** Automatically uploads all files from the sample_data folder to your S3 bucket

---

## S3 Bucket Types and Use Cases

### Standard Storage
- **Use for:** Frequently accessed data, web applications, content distribution
- **Availability:** 99.99% availability
- **Durability:** 99.999999999% (11 9's)
- **Cost:** Standard pricing

### Intelligent Tiering
- **Use for:** Data with unknown or changing access patterns
- **Benefit:** Automatically moves data to cost-effective storage tiers
- **Cost:** Small monthly monitoring fee

### Standard-IA (Infrequent Access)
- **Use for:** Data accessed less frequently but requires rapid access
- **Cost:** Lower than standard storage
- **Retrieval:** Small retrieval fee

### Glacier
- **Use for:** Long-term backup and archival data
- **Cost:** Very low storage cost
- **Retrieval:** Hours to days, with retrieval fees

---

## Security Features

### Server-Side Encryption
- **AES-256 encryption** for all objects
- **AWS-managed keys** (no key management required)
- **Automatic encryption** of all uploads

### Bucket Policies
- **Fine-grained access control** using JSON policies
- **Deny unencrypted uploads** for compliance
- **IP-based restrictions** for additional security

### Versioning
- **Multiple file versions** for backup and recovery
- **Protection against accidental deletion**
- **Compliance requirements** for data retention

### Access Logging
- **Track all bucket access** for security monitoring
- **Audit trail** for compliance requirements
- **Security analysis** and threat detection

---

## What the Module Provides (Outputs)

### Bucket Information

```hcl
output "bucket_id" {
  description = "ID of the created S3 bucket"
  value       = aws_s3_bucket.main.id
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.main.arn
}
```

**Used by:** Other modules that need to reference your S3 bucket

### Bucket URL Information

```hcl
output "bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = aws_s3_bucket.main.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = aws_s3_bucket.main.bucket_regional_domain_name
}
```

**Used by:** Applications that need to access files in your bucket

---

## Customizing Your S3 Setup

### Change Bucket Name

```hcl
variable "bucket_name" {
  description = "Name for the S3 bucket"
  type        = string
  default     = "my-custom-bucket-name"  # Change from default
}
```

### Disable Versioning

```hcl
variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = false  # Change from true to false
}
```

### Add Custom Bucket Policy

```hcl
# Allow specific IAM users to access the bucket
resource "aws_s3_bucket_policy" "custom_access" {
  bucket = aws_s3_bucket.main.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowSpecificUsers"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:user/username"
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.main.arn}/*"
      }
    ]
  })
}
```

### Create Multiple Buckets

```hcl
# Create separate buckets for different purposes
resource "aws_s3_bucket" "logs" {
  bucket = "${var.environment}-logs-bucket"
  
  tags = {
    Name        = "${var.environment}-logs-bucket"
    Environment = var.environment
    Purpose     = "Logs"
  }
}

resource "aws_s3_bucket" "backups" {
  bucket = "${var.environment}-backups-bucket"
  
  tags = {
    Name        = "${var.environment}-backups-bucket"
    Environment = var.environment
    Purpose     = "Backups"
  }
}
```

---

## Common Questions

### "What's the difference between S3 and EBS?"

- **S3:** Object storage for files, documents, backups (accessed via API)
- **EBS:** Block storage for EC2 instances (like a hard drive)

### "How much data can I store in S3?"

**Unlimited storage!** S3 can store virtually unlimited amounts of data with no maximum file size limits.

### "Is S3 data automatically backed up?"

**Yes!** S3 automatically replicates your data across multiple facilities for 99.999999999% durability.

### "Can I access S3 from the internet?"

**Yes, but be careful!** S3 buckets are private by default. You control access through bucket policies and IAM permissions.

### "How do I organize files in S3?"

**Use folders (prefixes):**
- `logs/2024/01/` for log files
- `backups/database/` for database backups
- `documents/projects/` for project files

---

## Troubleshooting

### Error: "Bucket name already exists"
**Solution:** S3 bucket names must be globally unique. Choose a different name.

### Error: "Access denied"
**Solution:** Check your IAM permissions and bucket policies

### Error: "Invalid bucket name"
**Solution:** Bucket names must be 3-63 characters, lowercase, and contain only letters, numbers, hyphens, and periods

### Error: "Versioning not enabled"
**Solution:** Make sure the versioning variable is set to true

---

## Next Steps

1. **Look at the main.tf** to see how S3 resources are created
2. **Modify variables** to customize your storage setup
3. **Deploy the module** to create your S3 infrastructure
4. **Upload files** to test your bucket
5. **Configure additional security** as needed

---

## Security Best Practices

### Do's
- Enable encryption for all buckets
- Use bucket policies to restrict access
- Enable versioning for important data
- Use IAM roles instead of access keys
- Regularly review access logs

### Don'ts
- Don't make buckets publicly accessible unless necessary
- Don't ignore bucket policies
- Don't forget to monitor costs
- Don't skip access logging
- Don't use weak bucket names

---

## Cost Considerations

### S3 Storage Costs
- **Standard Storage:** $0.023 per GB per month
- **Standard-IA:** $0.0125 per GB per month
- **Glacier:** $0.004 per GB per month
- **Intelligent Tiering:** $0.0025 per 1,000 objects per month

### Data Transfer Costs
- **Inbound:** FREE
- **Outbound:** $0.09 per GB (first 1GB free)
- **Between S3 and EC2:** FREE (same region)

### Cost Optimization Tips
- Use appropriate storage classes
- Enable Intelligent Tiering for unknown access patterns
- Compress files before uploading
- Use lifecycle policies to move old data to cheaper storage

---

## Integration with Other Services

### EC2 Instances
- Store application data and backups
- Host static websites
- Store log files and monitoring data

### Lambda Functions
- Process files uploaded to S3
- Generate reports and analytics
- Automate data workflows

### CloudFront
- Distribute S3 content globally
- Reduce latency for users
- Lower data transfer costs

### AWS Glue
- Catalog and analyze S3 data
- Run ETL jobs on stored data
- Prepare data for analytics

---

<div align="center">
  <p><em>Your secure storage is now ready!</em></p>
</div>
