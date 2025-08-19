# 🔐 IAM Module - Identity & Access Management

## 📚 **What is IAM?**

**IAM (Identity and Access Management)** is AWS's **permission and user management service**. Think of it as the **security system** for your AWS account that controls who can access what resources and what they can do with them.

### **🏠 Real-World Analogy**

- **🔐 IAM** = The security system for your building
- **👤 Users** = People who need access to your building
- **🔑 Access Keys** = Key cards that let people in
- **📋 Policies** = Rules about what each person can do
- **👥 Groups** = Teams of people with similar access needs
- **🎭 Roles** = Temporary access for specific tasks

---

## 🎯 **What This Module Creates**

This module sets up **IAM security infrastructure** for your security lab:

- **👤 IAM Users** - Individual accounts for team members
- **🔑 Access Keys** - Programmatic access to AWS services
- **📋 IAM Policies** - Rules defining what users can do
- **👥 IAM Groups** - Collections of users with similar permissions
- **🎭 IAM Roles** - Temporary access for specific services
- **🏷️ Tags** - Organization and cost tracking

---

## 🏗️ **Module Structure**

```
iam/
├── main.tf      # 🎯 Creates IAM users, groups, policies, and roles
├── variables.tf # 📝 What the module needs as input
├── outputs.tf   # 📤 What the module provides to others
└── README.md    # 📖 This file!
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

**What this means:** All IAM resources get tagged with your environment (dev, staging, prod)

### **👥 User Configuration**

```hcl
variable "users" {
  description = "List of IAM users to create"
  type = list(object({
    name = string
    groups = list(string)
    access_keys = bool
  }))
  default = [
    {
      name = "lab-admin"
      groups = ["Administrators"]
      access_keys = true
    },
    {
      name = "lab-user"
      groups = ["Users"]
      access_keys = true
    }
  ]
}
```

**What this means:** Defines which users to create, what groups they belong to, and whether they need programmatic access

### **📋 Policy Configuration**

```hcl
variable "policies" {
  description = "Map of IAM policies to create"
  type = map(object({
    description = string
    policy = string
  }))
}
```

**What this means:** Defines custom IAM policies with specific permissions for your lab

---

## 🔍 **How It Works (Step by Step)**

### **Step 1: Create IAM Groups**

```hcl
resource "aws_iam_group" "administrators" {
  name = "${var.environment}-administrators"
  
  tags = {
    Name        = "${var.environment}-administrators-group"
    Environment = var.environment
    Type        = "Administrators"
  }
}

resource "aws_iam_group" "users" {
  name = "${var.environment}-users"
  
  tags = {
    Name        = "${var.environment}-users-group"
    Environment = var.environment
    Type        = "Users"
  }
}
```

**What this does:** Creates two groups:
- **Administrators group** - For users who need full access
- **Users group** - For users who need limited access

### **Step 2: Create IAM Policies**

```hcl
resource "aws_iam_policy" "lab_admin_policy" {
  name        = "${var.environment}-admin-policy"
  description = "Full access policy for lab administrators"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "*"
        Resource = "*"
      }
    ]
  })
  
  tags = {
    Name        = "${var.environment}-admin-policy"
    Environment = var.environment
    Type        = "Administrator"
  }
}

resource "aws_iam_policy" "lab_user_policy" {
  name        = "${var.environment}-user-policy"
  description = "Limited access policy for lab users"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "ec2:Get*",
          "s3:Get*",
          "s3:List*"
        ]
        Resource = "*"
      }
    ]
  })
  
  tags = {
    Name        = "${var.environment}-user-policy"
    Environment = var.environment
    Type        = "User"
  }
}
```

**What this does:** Creates two policies:
- **Admin Policy** - Full access to all AWS services (for administrators)
- **User Policy** - Limited access to read-only operations (for regular users)

### **Step 3: Attach Policies to Groups**

```hcl
resource "aws_iam_group_policy_attachment" "admin_policy" {
  group      = aws_iam_group.administrators.name
  policy_arn = aws_iam_policy.lab_admin_policy.arn
}

resource "aws_iam_group_policy_attachment" "user_policy" {
  group      = aws_iam_group.users.name
  policy_arn = aws_iam_policy.lab_user_policy.arn
}
```

**What this does:** Connects the policies to the appropriate groups so users get the right permissions

### **Step 4: Create IAM Users**

```hcl
resource "aws_iam_user" "users" {
  for_each = { for user in var.users : user.name => user }
  
  name = each.value.name
  
  tags = {
    Name        = each.value.name
    Environment = var.environment
    Type        = "IAM User"
  }
}
```

**What this does:** Creates individual IAM users based on your configuration

### **Step 5: Add Users to Groups**

```hcl
resource "aws_iam_user_group_membership" "user_groups" {
  for_each = { for user in var.users : user.name => user }
  
  user   = aws_iam_user.users[each.key].name
  groups = each.value.groups
}
```

**What this does:** Assigns each user to their specified groups, giving them the appropriate permissions

### **Step 6: Create Access Keys (if needed)**

```hcl
resource "aws_iam_access_key" "user_keys" {
  for_each = { for user in var.users : user.name => user if user.access_keys }
  
  user = aws_iam_user.users[each.key].name
  
  tags = {
    Name        = "${each.key}-access-key"
    Environment = var.environment
    Type        = "Access Key"
  }
}
```

**What this does:** Creates access keys for users who need programmatic access to AWS services

---

## 🔐 **IAM Security Concepts Explained**

### **👤 IAM Users**

**What they are:**
- **Individual accounts** for people or applications
- **Long-term credentials** that don't expire
- **Unique usernames** and passwords/access keys

**Best practices:**
- **One user per person** (don't share accounts)
- **Use strong passwords** and enable MFA
- **Regular access reviews** to remove unused users

### **🔑 Access Keys**

**What they are:**
- **Programmatic access** to AWS services
- **API credentials** for scripts and applications
- **Secret access key** (never share this!)

**Best practices:**
- **Rotate regularly** (every 90 days)
- **Use least privilege** (only necessary permissions)
- **Monitor usage** for suspicious activity

### **📋 IAM Policies**

**What they are:**
- **JSON documents** defining permissions
- **Allow/Deny statements** for specific actions
- **Resource-based** or **identity-based** permissions

**Policy structure:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::my-bucket/*"
    }
  ]
}
```

### **👥 IAM Groups**

**What they are:**
- **Collections of users** with similar access needs
- **Easier management** than individual user policies
- **Consistent permissions** across team members

**Best practices:**
- **Group by function** (developers, admins, auditors)
- **Use descriptive names** (e.g., "EC2-Developers")
- **Regular membership reviews**

### **🎭 IAM Roles**

**What they are:**
- **Temporary credentials** for specific tasks
- **No long-term access keys** to manage
- **Assumed by users or services** as needed

**Common use cases:**
- **EC2 instances** accessing S3 buckets
- **Lambda functions** calling other AWS services
- **Cross-account access** for temporary collaboration

---

## 📤 **What the Module Provides (Outputs)**

### **👤 User Information**

```hcl
output "user_names" {
  description = "List of created IAM user names"
  value       = [for user in aws_iam_user.users : user.name]
}

output "user_arns" {
  description = "Map of IAM user names to ARNs"
  value       = { for k, v in aws_iam_user.users : k => v.arn }
}
```

**Used by:** Other modules or scripts that need to reference your IAM users

### **🔑 Access Key Information**

```hcl
output "access_keys" {
  description = "Map of usernames to access key IDs"
  value       = { for k, v in aws_iam_access_key.user_keys : k => v.id }
  sensitive   = true
}
```

**Used by:** You to know which access keys belong to which users

### **👥 Group Information**

```hcl
output "group_names" {
  description = "List of created IAM group names"
  value       = [aws_iam_group.administrators.name, aws_iam_group.users.name]
}

output "group_arns" {
  description = "Map of group names to ARNs"
  value = {
    administrators = aws_iam_group.administrators.arn
    users         = aws_iam_group.users.arn
  }
}
```

**Used by:** Other modules that need to reference your IAM groups

---

## 🎨 **Customizing Your IAM Setup**

### **👤 Add More Users**

```hcl
variable "users" {
  description = "List of IAM users to create"
  type = list(object({
    name = string
    groups = list(string)
    access_keys = bool
  }))
  default = [
    {
      name = "lab-admin"
      groups = ["Administrators"]
      access_keys = true
    },
    {
      name = "lab-user"
      groups = ["Users"]
      access_keys = true
    },
    {
      name = "lab-developer"
      groups = ["Developers"]
      access_keys = true
    },
    {
      name = "lab-auditor"
      groups = ["Auditors"]
      access_keys = false
    }
  ]
}
```

### **📋 Create Custom Policies**

```hcl
variable "policies" {
  description = "Map of IAM policies to create"
  type = map(object({
    description = string
    policy = string
  }))
  default = {
    "ec2-developer" = {
      description = "Policy for EC2 developers"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "ec2:*",
              "elasticloadbalancing:*",
              "autoscaling:*"
            ]
            Resource = "*"
          }
        ]
      })
    }
  }
}
```

### **🔐 Enable MFA for Users**

```hcl
resource "aws_iam_user" "users" {
  for_each = { for user in var.users : user.name => user }
  
  name = each.value.name
  
  # Force MFA for all users
  force_detach_policies = true
  
  tags = {
    Name        = each.value.name
    Environment = var.environment
    Type        = "IAM User"
    MFA         = "Required"
  }
}
```

---

## 🚨 **Common Questions**

### **❓ "What's the difference between users and roles?"**

- **👤 Users:** Long-term accounts for people, have permanent credentials
- **🎭 Roles:** Temporary access for specific tasks, no permanent credentials
- **🔄 Best Practice:** Use roles for temporary access, users for long-term access

### **❓ "How do I know what permissions a user has?"**

- **📋 Check Groups:** See what groups the user belongs to
- **🔍 Check Policies:** Look at policies attached to those groups
- **📊 AWS Console:** Use the IAM console to see effective permissions
- **🔧 AWS CLI:** Use `aws iam get-user-policy` and `aws iam list-attached-user-policies`

### **❓ "What if I accidentally give someone too many permissions?"**

- **🚨 Immediate:** Remove the user from admin groups
- **🔍 Review:** Check what they accessed in CloudTrail logs
- **🔄 Fix:** Adjust group memberships and policies
- **📝 Document:** Record what happened and how you fixed it

### **❓ "How often should I rotate access keys?"**

**AWS recommends:**
- **🔑 Access Keys:** Every 90 days
- **🔐 Passwords:** Every 90 days
- **🎭 Role Sessions:** Use shortest duration possible
- **📅 Regular Reviews:** Monthly access reviews

---

## 🔧 **Troubleshooting**

### **🚨 Error: "User already exists"**
**Solution:** Either delete the existing user or use a different username

### **🚨 Error: "Policy not found"**
**Solution:** Make sure the policy exists before attaching it to groups

### **🚨 Error: "Insufficient permissions"**
**Solution:** Ensure your AWS user has IAM permissions:
- `iam:CreateUser`
- `iam:CreateGroup`
- `iam:CreatePolicy`
- `iam:AttachGroupPolicy`

### **🚨 Error: "Access key limit exceeded"**
**Solution:** Each user can only have 2 access keys. Delete old ones before creating new ones.

---

## 🎯 **Next Steps**

1. **🔍 Look at the main.tf** to see how IAM resources are created
2. **📝 Modify variables** to customize your users and permissions
3. **🚀 Deploy the module** to create your IAM infrastructure
4. **🔐 Test access** to ensure permissions work correctly
5. **📊 Monitor usage** to track who's accessing what

---

## 🔐 **Security Best Practices**

### **✅ Do's**
- **🔐 Use least privilege** - only give necessary permissions
- **🔄 Rotate credentials regularly** - access keys and passwords
- **📱 Enable MFA** - multi-factor authentication for all users
- **🏷️ Use consistent tagging** - for cost tracking and organization
- **📊 Regular access reviews** - remove unused permissions

### **❌ Don'ts**
- **🚫 Don't use root credentials** - create IAM users instead
- **🚫 Don't share access keys** - each user should have their own
- **🚫 Don't give admin access** - unless absolutely necessary
- **🚫 Don't ignore access logs** - monitor for suspicious activity
- **🚫 Don't forget to rotate** - credentials should expire

---

## 💰 **Cost Considerations**

### **💰 IAM Costs**
- **✅ IAM is FREE** - no charges for users, groups, or policies
- **🔑 Access Keys:** No additional cost
- **📊 CloudTrail:** May incur costs for API logging
- **🔍 Access Analyzer:** Free for first 1000 checks per month

### **💡 Cost Optimization Tips**
- **🏷️ Use tags** to track IAM usage by project
- **📊 Monitor CloudTrail** for unusual IAM activity
- **🔄 Regular cleanup** of unused users and policies
- **📝 Document policies** to avoid duplicate creation

---

## 🔗 **Integration with Other Services**

### **🛡️ GuardDuty**
- **Monitor IAM activity** for suspicious behavior
- **Detect privilege escalation** attempts
- **Alert on unusual access patterns**

### **📊 CloudTrail**
- **Log all IAM API calls** for audit purposes
- **Track permission changes** over time
- **Monitor access patterns** for security analysis

### **🔐 AWS Config**
- **Track IAM configuration** changes
- **Ensure compliance** with security policies
- **Automated remediation** of policy violations

---

<div align="center">
  <p><em>🔐 Your IAM security is now configured! 🛡️</em></p>
</div>
