# IAM Module - Identity and Access Management

## What is IAM?

**IAM (Identity and Access Management)** is AWS's **permission and user management service**. Think of it as the **security system** for your AWS account that controls who can access what resources and what they can do with them.

### Real-World Analogy

- **IAM** = The security system for your building
- **Users** = People who need access to your building
- **Groups** = Departments or teams with similar access needs
- **Roles** = Temporary access passes for specific tasks
- **Policies** = Rules that define what each person can do
- **Access Keys** = Digital keys that let applications access AWS

---

## What This Module Creates

This module sets up **comprehensive access control** for your AWS environment:

- **IAM Users** - Individual accounts for team members
- **IAM Groups** - Collections of users with similar permissions
- **IAM Policies** - Rules that define what users can do
- **Access Keys** - Programmatic access for applications and scripts
- **User Management** - Organized structure for access control

---

## Module Structure

```
iam/
├── main.tf      # Creates IAM users, groups, and policies
├── variables.tf # What the module needs as input
├── outputs.tf   # What the module provides to others
└── README.md    # This file!
```

---

## Input Variables Explained

### User Configuration

```hcl
variable "users" {
  description = "List of IAM users to create"
  type = list(object({
    name = string
    groups = list(string)
    access_keys = list(string)
  }))
  default = [
    {
      name = "admin-user"
      groups = ["administrators"]
      access_keys = ["admin-key"]
    },
    {
      name = "developer-user"
      groups = ["developers"]
      access_keys = ["developer-key"]
    }
  ]
}
```

**What this means:** Defines which users to create, which groups they belong to, and what access keys they need

### Group Configuration

```hcl
variable "groups" {
  description = "List of IAM groups to create"
  type = list(object({
    name = string
    policies = list(string)
  }))
  default = [
    {
      name = "administrators"
      policies = ["AdministratorAccess"]
    },
    {
      name = "developers"
      policies = ["PowerUserAccess"]
    }
  ]
}
```

**What this means:** Defines which groups to create and what permissions each group has

### Environment Configuration

```hcl
variable "environment" {
  description = "Environment name for tagging and naming"
  type        = string
  default     = "lab"
}
```

**What this means:** All IAM resources get tagged with your environment (dev, staging, prod)

---

## How It Works (Step by Step)

### Step 1: Create IAM Groups

```hcl
resource "aws_iam_group" "main" {
  count = length(var.groups)
  name  = var.groups[count.index].name
  
  tags = {
    Name        = "${var.environment}-${var.groups[count.index].name}"
    Environment = var.environment
    Type        = "IAM Group"
  }
}
```

**What this does:** Creates IAM groups that will contain users with similar access needs

### Step 2: Attach Policies to Groups

```hcl
resource "aws_iam_group_policy_attachment" "main" {
  count      = length(var.groups)
  group      = aws_iam_group.main[count.index].name
  policy_arn = "arn:aws:iam::aws:policy/${var.groups[count.index].policies[0]}"
}
```

**What this does:** Gives each group the permissions they need to do their jobs

### Step 3: Create IAM Users

```hcl
resource "aws_iam_user" "main" {
  count = length(var.users)
  name  = var.users[count.index].name
  
  tags = {
    Name        = "${var.environment}-${var.users[count.index].name}"
    Environment = var.environment
    Type        = "IAM User"
  }
}
```

**What this does:** Creates individual user accounts for team members

### Step 4: Add Users to Groups

```hcl
resource "aws_iam_user_group_membership" "main" {
  count  = length(var.users)
  user   = aws_iam_user.main[count.index].name
  groups = var.users[count.index].groups
}
```

**What this does:** Puts each user in the appropriate groups to get the right permissions

### Step 5: Create Access Keys

```hcl
resource "aws_iam_access_key" "main" {
  count = length(var.users)
  user  = aws_iam_user.main[count.index].name
  
  tags = {
    Name        = "${var.environment}-${var.users[count.index].name}-key"
    Environment = var.environment
    Type        = "Access Key"
  }
}
```

**What this does:** Creates access keys that let users and applications access AWS programmatically

---

## IAM Security Concepts

### Users vs Groups vs Roles

- **Users:** Individual people who need access
- **Groups:** Collections of users with similar permissions
- **Roles:** Temporary access for specific tasks or services

### Policy Types

- **Managed Policies:** Pre-built policies from AWS (e.g., AdministratorAccess)
- **Inline Policies:** Custom policies you create for specific needs
- **Service-Linked Roles:** Special roles for AWS services

### Access Control Principles

- **Least Privilege:** Give users only the permissions they need
- **Separation of Duties:** Split critical permissions across multiple users
- **Regular Review:** Periodically review and update permissions

---

## What the Module Provides (Outputs)

### User Information

```hcl
output "user_names" {
  description = "Names of created IAM users"
  value       = aws_iam_user.main[*].name
}

output "user_arns" {
  description = "ARNs of created IAM users"
  value       = aws_iam_user.main[*].arn
}
```

**Used by:** Other modules that need to reference specific users

### Group Information

```hcl
output "group_names" {
  description = "Names of created IAM groups"
  value       = aws_iam_group.main[*].name
}

output "group_arns" {
  description = "ARNs of created IAM groups"
  value       = aws_iam_group.main[*].arn
}
```

**Used by:** Other modules that need to reference specific groups

### Access Key Information

```hcl
output "access_key_ids" {
  description = "Access key IDs for created users"
  value       = aws_iam_access_key.main[*].id
}

output "secret_access_keys" {
  description = "Secret access keys for created users"
  value       = aws_iam_access_key.main[*].secret
  sensitive   = true
}
```

**Used by:** Applications and scripts that need programmatic access to AWS

---

## Customizing Your IAM Setup

### Add More Users

```hcl
variable "users" {
  description = "List of IAM users to create"
  type = list(object({
    name = string
    groups = list(string)
    access_keys = list(string)
  }))
  default = [
    {
      name = "admin-user"
      groups = ["administrators"]
      access_keys = ["admin-key"]
    },
    {
      name = "developer-user"
      groups = ["developers"]
      access_keys = ["developer-key"]
    },
    {
      name = "analyst-user"
      groups = ["analysts"]
      access_keys = ["analyst-key"]
    }
  ]
}
```

### Create Custom Groups

```hcl
variable "groups" {
  description = "List of IAM groups to create"
  type = list(object({
    name = string
    policies = list(string)
  }))
  default = [
    {
      name = "administrators"
      policies = ["AdministratorAccess"]
    },
    {
      name = "developers"
      policies = ["PowerUserAccess"]
    },
    {
      name = "readonly-users"
      policies = ["ReadOnlyAccess"]
    }
  ]
}
```

### Add Custom Policies

```hcl
# Create a custom policy for S3 access
resource "aws_iam_policy" "s3_access" {
  name        = "${var.environment}-s3-access-policy"
  description = "Custom policy for S3 bucket access"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::${var.environment}-bucket/*"
      }
    ]
  })
}
```

---

## Common Questions

### "What's the difference between AdministratorAccess and PowerUserAccess?"

- **AdministratorAccess:** Full access to all AWS services and resources
- **PowerUserAccess:** Access to most services but can't manage users or billing
- **ReadOnlyAccess:** Can view resources but can't make changes

### "How do I give a user access to only specific S3 buckets?"

**Create a custom policy:**
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "arn:aws:s3:::my-bucket/*"
    }
  ]
}
```

### "Can I change a user's permissions after creation?"

**Yes!** You can:
- **Add/remove users** from groups
- **Attach/detach policies** from users or groups
- **Create new policies** and apply them
- **Modify existing policies** (be careful with this)

### "What happens if I delete an IAM user?"

- **User account** is permanently deleted
- **Access keys** are immediately invalidated
- **User's resources** remain (but they can't access them)
- **Consider transferring** resources to another user first

---

## Troubleshooting

### Error: "Policy not found"
**Solution:** Check that the policy name exists in AWS or create a custom policy

### Error: "User already exists"
**Solution:** Use a unique username or reference an existing user

### Error: "Insufficient permissions"
**Solution:** Ensure your AWS user has IAM permissions to create users and groups

### Error: "Access key limit exceeded"
**Solution:** Each user can only have 2 access keys. Delete old ones first.

---

## Next Steps

1. **Look at the main.tf** to see how IAM resources are created
2. **Modify variables** to customize your user and group setup
3. **Deploy the module** to create your IAM structure
4. **Test access** by logging in with different users
5. **Set up additional policies** for specific access needs

---

## Security Best Practices

### Do's
- Use groups to manage permissions, not individual users
- Follow the principle of least privilege
- Regularly rotate access keys
- Use strong passwords and MFA
- Tag all IAM resources for organization

### Don'ts
- Don't give users more permissions than they need
- Don't share access keys between users
- Don't use root account for daily operations
- Don't forget to review permissions regularly
- Don't ignore IAM access logs

---

## Cost Considerations

### IAM Costs
- **Users:** FREE
- **Groups:** FREE
- **Policies:** FREE
- **Access Keys:** FREE

### Related Costs
- **AWS CloudTrail:** $2.00 per 100,000 events (for IAM activity logging)
- **AWS Config:** $0.003 per configuration item recorded
- **IAM Access Analyzer:** FREE

### Cost Optimization Tips
- Use groups instead of individual user policies
- Regularly review and remove unused users
- Monitor IAM activity with CloudTrail
- Use service-linked roles when possible

---

## Integration with Other Services

### AWS CloudTrail
- Logs all IAM API calls and user activity
- Provides audit trail for compliance
- Enables security monitoring and alerting

### AWS Config
- Tracks IAM configuration changes
- Monitors compliance with security policies
- Provides configuration history

### AWS Organizations
- Manages multiple AWS accounts
- Centralizes IAM user management
- Enables cross-account access

### Third-Party Tools
- Identity providers (SAML, OIDC)
- Privileged access management tools
- Security information and event management (SIEM)

---

<div align="center">
  <p><em>Your access control is now properly configured!</em></p>
</div>
