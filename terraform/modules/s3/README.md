# 🗄️ S3 Module - Object Storage

## 📚 **What is S3?**

**S3 (Simple Storage Service)** is AWS's **object storage service**. Think of it as a **giant digital warehouse** where you can store any type of file - documents, images, videos, backups, and more. It's designed to be highly available, secure, and scalable.

### **🏠 Real-World Analogy**

- **🗄️ S3 Bucket** = A storage unit in your digital warehouse
- **📁 Objects** = Individual files you store (documents, images, etc.)
- **🔐 Access Control** = Security rules for who can access what
- **🌍 Regions** = Different warehouse locations around the world
- **📊 Versioning** = Keeping multiple copies of the same file
- **🔒 Encryption** = Locking your files with digital keys

---

## 🎯 **What This Module Creates**

This module sets up **S3 storage infrastructure** for your security lab:

- **🗄️ S3 Buckets** - Storage containers for your files
- **🔐 Bucket Policies** - Security rules for access control
- **📊 Versioning** - File history and recovery capabilities
- **🔒 Encryption** - Data protection at rest and in transit
- **📝 Sample Data** - Example files for testing and learning
- **🏷️ Tags** - Organization and cost tracking

---

## 🏗️ **Module Structure**

```
s3/
├── main.tf           # 🎯 Creates S3 buckets and configurations
├── variables.tf      # 📝 What the module needs as input
├── outputs.tf        # 📤 What the module provides to others
├── README.md         # 📖 This file!
└── sample_data/      # 📝 Example files for testing
    └── threats/      # 🚨 Sample threat data
        └── malware_indicators.json # Example malware data
```

---

## 📝 **Input Variables Explained**

### **🏷️ Environment and Naming**

```hcl
variable "environment" {
  description = "Environment name for tagging and naming"
  type        = string
  default     = "lab"
}
```

**What this means:** All S3 resources get tagged with your environment (dev, staging, prod)

### **🗄️ Bucket Configuration**

```hcl
variable "bucket_names" {
  description = "List of S3 bucket names to create"
  type        = list(string)
  default     = ["lab-data", "lab-backups", "lab-logs"]
}
```

**What this means:** Defines which S3 buckets to create for different purposes

### **🔐 Security Settings**

```hcl
variable "enable_versioning" {
  description = "Enable versioning for all buckets"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Enable server-side encryption for all buckets"
  type        = bool
  default     = true
}
```

**What this means:** Controls security features like file versioning and encryption

---

## 🔍 **How It Works (Step by Step)**

### **Step 1: Create S3 Buckets**

```hcl
resource "aws_s3_bucket" "buckets" {
  for_each = toset(var.bucket_names)
  
  bucket = "${var.environment}-${each.value}-${random_string.bucket_suffix.result}"
  
  tags = {
    Name        = "${var.environment}-${each.value}-bucket"
    Environment = var.environment
    Type        = "Data Storage"
  }
}
```

**What this does:** Creates multiple S3 buckets with unique names for different purposes

### **Step 2: Enable Versioning**

```hcl
resource "aws_s3_bucket_versioning" "versioning" {
  for_each = aws_s3_bucket.buckets
  
  bucket = each.value.id
  
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"
  }
}
```

**What this does:** Enables file versioning so you can recover previous versions of files

### **Step 3: Configure Encryption**

```hcl
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  for_each = aws_s3_bucket.buckets
  
  bucket = each.value.id
  
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
```

**What this does:** Encrypts all files stored in the buckets using AES-256 encryption

### **Step 4: Set Bucket Policies**

```hcl
resource "aws_s3_bucket_policy" "bucket_policies" {
  for_each = aws_s3_bucket.buckets
  
  bucket = each.value.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyUnencryptedObjectUploads"
        Effect = "Deny"
        Principal = "*"
        Action = "s3:PutObject"
        Resource = "${each.value.arn}/*"
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

**What this does:** Creates security policies that enforce encryption and control access

### **Step 5: Upload Sample Data**

```hcl
resource "aws_s3_object" "sample_data" {
  for_each = fileset("${path.module}/sample_data", "**/*")
  
  bucket = aws_s3_bucket.buckets["lab-data"].id
  key    = "sample_data/${each.value}"
  source = "${path.module}/sample_data/${each.value}"
  
  tags = {
    Name        = "sample-data-${each.value}"
    Environment = var.environment
    Type        = "Sample Data"
  }
}
```

**What this does:** Uploads example files to help you test and learn about S3 functionality

---

## 🗄️ **S3 Bucket Types and Purposes**

### **📊 Data Bucket (`lab-data`)**

**Purpose:** Store application data, user uploads, and working files
**Features:**
- **Versioning enabled** for file recovery
- **Encryption enabled** for data protection
- **Sample data included** for testing
- **Access logging** for audit trails

**Use cases:**
- Application data storage
- User file uploads
- Working documents
- Sample datasets

### **💾 Backups Bucket (`lab-backups`)**

**Purpose:** Store system backups, snapshots, and recovery data
**Features:**
- **Versioning enabled** for backup history
- **Encryption enabled** for data security
- **Lifecycle policies** for cost optimization
- **Cross-region replication** for disaster recovery

**Use cases:**
- Database backups
- System snapshots
- Configuration backups
- Disaster recovery data

### **📝 Logs Bucket (`lab-logs`)**

**Purpose:** Store application logs, audit trails, and monitoring data
**Features:**
- **Log delivery** from CloudWatch and other services
- **Retention policies** for compliance
- **Access logging** for security monitoring
- **Cost optimization** through lifecycle policies

**Use cases:**
- Application logs
- Security audit logs
- Performance metrics
- Compliance data

---

## 🔐 **Security Features Explained**

### **🔒 Server-Side Encryption**

**What it does:**
- **Encrypts files** when they're stored in S3
- **Uses AES-256** encryption algorithm
- **Automatic encryption** for all new files
- **No additional cost** for encryption

**Benefits:**
- **Data protection** at rest
- **Compliance** with security standards
- **Automatic key management** by AWS
- **Transparent** to applications

### **📊 Versioning**

**What it does:**
- **Keeps multiple versions** of the same file
- **Prevents accidental deletion** of important data
- **Enables file recovery** from any point in time
- **Tracks file changes** over time

**Use cases:**
- **File recovery** after accidental deletion
- **Rollback** to previous versions
- **Audit trails** of file changes
- **Compliance** with data retention requirements

### **🛡️ Bucket Policies**

**What they do:**
- **Control access** to bucket contents
- **Enforce security** requirements
- **Prevent unauthorized** access
- **Ensure compliance** with security policies

**Example policies:**
- **Deny unencrypted uploads** (enforce encryption)
- **Restrict access** to specific IP ranges
- **Require specific headers** for uploads
- **Log all access** for security monitoring

---

## 📤 **What the Module Provides (Outputs)**

### **🗄️ Bucket Information**

```hcl
output "bucket_names" {
  description = "Names of created S3 buckets"
  value       = [for bucket in aws_s3_bucket.buckets : bucket.bucket]
}

output "bucket_arns" {
  description = "ARNs of created S3 buckets"
  value       = { for k, v in aws_s3_bucket.buckets : k => v.arn }
}
```

**Used by:** Other modules or scripts that need to reference your S3 buckets

### **🔐 Security Information**

```hcl
output "encryption_status" {
  description = "Encryption status for each bucket"
  value       = { for k, v in aws_s3_bucket.buckets : k => var.enable_encryption }
}

output "versioning_status" {
  description = "Versioning status for each bucket"
  value       = { for k, v in aws_s3_bucket.buckets : k => var.enable_versioning }
}
```

**Used by:** Security monitoring and compliance reporting

### **📝 Sample Data Information**

```hcl
output "sample_data_keys" {
  description = "Keys of uploaded sample data files"
  value       = [for obj in aws_s3_object.sample_data : obj.key]
}
```

**Used by:** You to know what sample files are available for testing

---

## 🎨 **Customizing Your S3 Setup**

### **🗄️ Add More Buckets**

```hcl
variable "bucket_names" {
  description = "List of S3 bucket names to create"
  type        = list(string)
  default     = [
    "lab-data",
    "lab-backups", 
    "lab-logs",
    "lab-archives",    # New bucket for long-term storage
    "lab-temp"         # New bucket for temporary files
  ]
}
```

### **🔐 Customize Security Settings**

```hcl
variable "encryption_algorithm" {
  description = "Encryption algorithm to use"
  type        = string
  default     = "AES256"  # Options: AES256, aws:kms
}

variable "enable_public_access" {
  description = "Allow public access to buckets (not recommended for production)"
  type        = bool
  default     = false
}
```

### **📊 Configure Lifecycle Policies**

```hcl
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  for_each = aws_s3_bucket.buckets
  
  bucket = each.value.id
  
  rule {
    id     = "cost_optimization"
    status = "Enabled"
    
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    
    transition {
      days          = 90
      storage_class = "GLACIER"
    }
    
    expiration {
      days = 365
    }
  }
}
```

---

## 🚨 **Common Questions**

### **❓ "How much does S3 cost?"**

**Storage costs:**
- **Standard storage:** $0.023 per GB per month
- **Standard-IA:** $0.0125 per GB per month (30+ days)
- **Glacier:** $0.004 per GB per month (90+ days)
- **Data transfer:** $0.09 per GB out

**Other costs:**
- **PUT/COPY/POST requests:** $0.0005 per 1,000 requests
- **GET requests:** $0.0004 per 10,000 requests
- **Versioning:** Pay for all versions stored

### **❓ "What's the difference between bucket policies and IAM policies?"**

- **🪣 Bucket Policies:** Attached to S3 buckets, control access to bucket contents
- **👤 IAM Policies:** Attached to users/roles, control what AWS services they can access
- **🔄 Best Practice:** Use bucket policies for bucket-specific rules, IAM policies for user permissions

### **❓ "How do I recover a deleted file?"**

**If versioning is enabled:**
1. **Go to S3 console** and navigate to your bucket
2. **Show versions** to see all file versions
3. **Select the deleted version** you want to recover
4. **Click "Delete"** on the current version (if it exists)
5. **Click "Restore"** on the version you want to recover

**If versioning is disabled:**
- **File recovery is not possible** after deletion
- **Enable versioning** to prevent this in the future

### **❓ "Can I use S3 for hosting a website?"**

**Yes!** S3 can host static websites:
- **Enable static website hosting** on your bucket
- **Upload HTML, CSS, and JavaScript files**
- **Access via the S3 website endpoint**
- **Use CloudFront** for better performance and HTTPS

---

## 🔧 **Troubleshooting**

### **🚨 Error: "Bucket name already exists"**
**Solution:** S3 bucket names must be globally unique. Use a random suffix or different names.

### **🚨 Error: "Access denied"**
**Solution:** Check your IAM permissions and bucket policies. Ensure you have `s3:*` permissions.

### **🚨 Error: "Invalid bucket name"**
**Solution:** Bucket names must:
- Be 3-63 characters long
- Contain only lowercase letters, numbers, dots, and hyphens
- Start and end with a letter or number
- Not be formatted as an IP address

### **🚨 Error: "Encryption configuration failed"**
**Solution:** Ensure your IAM user has `s3:PutEncryptionConfiguration` permission.

---

## 🎯 **Next Steps**

1. **🔍 Look at the main.tf** to see how S3 buckets are created
2. **📝 Modify variables** to customize your storage setup
3. **🚀 Deploy the module** to create your S3 infrastructure
4. **📁 Upload files** to test your buckets
5. **🔐 Test security** by trying to access files without proper permissions

---

## 🔐 **Security Best Practices**

### **✅ Do's**
- **🔒 Enable encryption** for all buckets
- **📊 Enable versioning** for important data
- **🛡️ Use bucket policies** to enforce security
- **🏷️ Tag resources** for cost tracking and organization
- **📝 Enable access logging** for security monitoring

### **❌ Don'ts**
- **🚫 Don't make buckets public** unless absolutely necessary
- **🚫 Don't disable encryption** for sensitive data
- **🚫 Don't ignore access logs** - monitor for suspicious activity
- **🚫 Don't forget lifecycle policies** - they can save significant costs
- **🚫 Don't use root credentials** - create IAM users with specific permissions

---

## 💰 **Cost Optimization**

### **💰 Storage Class Selection**
- **Standard:** For frequently accessed data
- **Standard-IA:** For infrequently accessed data (30+ days)
- **Glacier:** For long-term archival data (90+ days)
- **Intelligent Tiering:** Automatic cost optimization

### **💡 Cost Saving Tips**
- **📊 Use lifecycle policies** to move data to cheaper storage classes
- **🗑️ Delete unused versions** if versioning is enabled
- **📁 Organize data** to apply different policies to different types
- **🌍 Choose appropriate regions** to minimize data transfer costs
- **📝 Monitor usage** with AWS Cost Explorer

---

## 🔗 **Integration with Other Services**

### **🛡️ GuardDuty**
- **Monitor S3 access** for suspicious activity
- **Detect data exfiltration** attempts
- **Alert on unusual** access patterns

### **📊 CloudWatch**
- **Monitor bucket metrics** (requests, errors, latency)
- **Set up alarms** for unusual activity
- **Create dashboards** for storage monitoring

### **🔐 IAM Access Analyzer**
- **Review S3 permissions** for security gaps
- **Identify overly permissive** bucket policies
- **Optimize access** based on actual usage

---

<div align="center">
  <p><em>🗄️ Your S3 storage is now configured! 📁</em></p>
</div>
