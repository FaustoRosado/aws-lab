# Project Structure & Organization Guide

This document explains the organization and structure of the AWS Security Lab repository, helping you understand why files are organized the way they are and how to navigate the project effectively.

## Root Directory Overview

```
aws-lab/
├── docs/                    # Comprehensive documentation
├── scripts/                 # PowerShell and automation scripts
├── terraform/               # Infrastructure as Code (Terraform)
├── README.md                # Main project overview
├── .gitignore              # Git ignore patterns
└── LICENSE                 # Project license
```

---

## Why This Structure?

### 1. **Separation of Concerns**
- **Documentation** is separate from **code** and **scripts**
- **Infrastructure** (Terraform) is isolated from **automation** (scripts)
- **Cross-platform** considerations for Windows and Mac users

### 2. **Beginner-Friendly Organization**
- Clear, logical grouping of related files
- Minimal cognitive load when navigating
- Consistent naming conventions throughout

### 3. **Professional Standards**
- Follows industry best practices for repository organization
- Easy to maintain and scale
- Clear for contributors and users

---

## Documentation Directory (`docs/`)

### Purpose
The `docs/` directory contains all project documentation, separated from code to ensure easy access and maintenance.

### Structure
```
docs/
├── README.md                    # Main project overview
├── SETUP_GUIDE.md              # Step-by-step setup instructions
├── AWS_CREDENTIALS_SETUP.md    # AWS authentication guide
├── PROJECT_STRUCTURE.md        # This file - structure explanation
├── MODULE_DOCUMENTATION.md     # Detailed Terraform module explanations
├── LAB_CHECKLIST.md            # Lab completion checklist
└── QUICK_START.md              # Fast deployment guide
```

### Why Separate Documentation?
- **Easy to find**: Users know exactly where to look for help
- **Maintainable**: Documentation can be updated without touching code
- **Version control**: Track documentation changes separately
- **Collaboration**: Multiple contributors can work on docs simultaneously

---

## Scripts Directory (`scripts/`)

### Purpose
The `scripts/` directory contains PowerShell and automation scripts that streamline lab operations.

### Structure
```
scripts/
├── setup_lab.ps1              # Main lab management script
└── simulate_compromise.ps1     # Attack simulation script
```

### Why PowerShell Scripts?
- **Windows Native**: PowerShell is built into Windows
- **Cross-Platform**: Can be adapted for Mac/Linux
- **AWS Integration**: Excellent AWS SDK support
- **Automation**: Reduces manual steps and errors

### Script Organization
- **Main Scripts**: Core functionality (setup, teardown, management)
- **Utility Scripts**: Specific tasks (simulation, monitoring)
- **Consistent Naming**: Clear purpose identification

---

## Terraform Directory (`terraform/`)

### Purpose
The `terraform/` directory contains all Infrastructure as Code (IaC) configurations for the AWS lab.

### Structure
```
terraform/
├── main.tf                    # Main configuration file
├── variables.tf               # Input variable definitions
├── outputs.tf                 # Output value definitions
├── versions.tf                # Provider and version constraints
└── modules/                   # Reusable Terraform modules
    ├── vpc/                   # VPC and networking
    ├── security_groups/       # Security group definitions
    ├── ec2/                   # EC2 instance configurations
    ├── s3/                    # S3 bucket configurations
    ├── guardduty/             # GuardDuty service setup
    ├── security_hub/          # Security Hub configuration
    ├── cloudwatch/            # CloudWatch monitoring
    └── iam/                   # IAM roles and policies
```

### Why Modular Structure?

#### 1. **Reusability**
- Each module can be used independently
- Easy to adapt for different environments
- Consistent patterns across projects

#### 2. **Maintainability**
- Changes to one service don't affect others
- Clear separation of responsibilities
- Easier debugging and troubleshooting

#### 3. **Scalability**
- Add new services without modifying existing code
- Version control individual modules
- Team collaboration on different components

#### 4. **Testing**
- Test individual modules in isolation
- Validate changes before applying to production
- Automated testing and validation

---

## Detailed Module Breakdown

### VPC Module (`modules/vpc/`)
```
modules/vpc/
├── main.tf                    # VPC, subnets, route tables
├── variables.tf               # Input parameters
├── outputs.tf                 # Exported values
└── README.md                  # Complete module documentation
```

**Why This Structure?**
- **Single Responsibility**: Only handles networking
- **Reusable**: Can be used in other projects
- **Configurable**: Variables for different environments

### EC2 Module (`modules/ec2/`)
```
modules/ec2/
├── main.tf                    # Instance definitions
├── variables.tf               # Configuration parameters
├── outputs.tf                 # Instance information
├── README.md                  # Complete module documentation
├── user_data/                 # Instance setup scripts
│   ├── README.md              # User data scripts documentation
│   ├── web_server.sh          # Web server configuration
│   └── database_server.sh     # Database setup
└── ssh/                       # SSH key management
    ├── lab-key                # Private SSH key
    └── lab-key.pub            # Public SSH key
```

**Why This Organization?**
- **User Data Scripts**: Separate from Terraform for clarity
- **SSH Keys**: Isolated for security
- **Platform Independence**: Shell scripts work on any Linux instance

### Security Groups Module (`modules/security_groups/`)
```
modules/security_groups/
├── main.tf                    # Security group definitions
├── variables.tf               # VPC and environment parameters
├── outputs.tf                 # Security group IDs
└── README.md                  # Complete module documentation
```

**Why Separate Security Groups?**
- **Network Security**: Critical for lab safety
- **Complex Rules**: Many ingress/egress rules
- **Reusability**: Can be applied to different instances

### GuardDuty Module (`modules/guardduty/`)
```
modules/guardduty/
├── main.tf                    # Threat detection configuration
├── variables.tf               # Environment and region parameters
├── outputs.tf                 # Detector and role information
└── README.md                  # Complete module documentation
```

**Why Separate GuardDuty?**
- **Threat Detection**: Core security monitoring service
- **Complex Configuration**: Multiple data sources and features
- **Integration**: Works with multiple AWS services

### IAM Module (`modules/iam/`)
```
modules/iam/
├── main.tf                    # User, group, and policy definitions
├── variables.tf               # User and permission parameters
├── outputs.tf                 # User and group information
└── README.md                  # Complete module documentation
```

**Why Separate IAM?**
- **Access Control**: Critical for security and compliance
- **Complex Permissions**: Multiple users, groups, and policies
- **Security**: Foundation for all other services

### S3 Module (`modules/s3/`)
```
modules/s3/
├── main.tf                    # Bucket and policy definitions
├── variables.tf               # Bucket and security parameters
├── outputs.tf                 # Bucket and security information
├── README.md                  # Complete module documentation
└── sample_data/               # Example files for testing
    ├── README.md              # Sample data documentation
    └── threats/               # Security threat examples
        └── malware_indicators.json # Sample malware data
```

**Why Separate S3?**
- **Data Storage**: Core storage service for the lab
- **Security Features**: Encryption, versioning, and access policies
- **Sample Data**: Provides testing materials for learning

### Security Hub Module (`modules/security_hub/`)
```
modules/security_hub/
├── main.tf                    # Security Hub configuration
├── variables.tf               # Standards and region parameters
├── outputs.tf                 # Security Hub information
└── README.md                  # Complete module documentation
```

**Why Separate Security Hub?**
- **Centralized Security**: Aggregates findings from all services
- **Compliance**: Enables security standards and frameworks
- **Integration**: Connects all security tools together

---

## File Naming Conventions

### 1. **Descriptive Names**
- `setup_lab.ps1` - Clearly indicates purpose
- `simulate_compromise.ps1` - Specific functionality
- `web_server.sh` - Instance role identification

### 2. **Consistent Extensions**
- `.tf` - Terraform configuration files
- `.ps1` - PowerShell scripts
- `.sh` - Bash/shell scripts
- `.md` - Markdown documentation

### 3. **Logical Grouping**
- Related files are grouped in directories
- Clear hierarchy from general to specific
- Easy to locate specific functionality

---

## Adding New Components

### Adding New Modules
1. **Create Directory**: `modules/new_service/`
2. **Standard Files**: `main.tf`, `variables.tf`, `outputs.tf`, `README.md`
3. **Update Main**: Add module call to `main.tf`
4. **Document**: Add to `MODULE_DOCUMENTATION.md`
5. **Update Index**: Add to `docs/INDEX.md`
6. **Update Structure**: Add to `docs/PROJECT_STRUCTURE.md`

### Adding New Scripts
1. **Create File**: Use descriptive name with appropriate extension
2. **Add Documentation**: Include usage instructions and examples
3. **Update Scripts README**: Document the new script
4. **Test**: Ensure it works across platforms

### Adding New Documentation
1. **Create File**: Use clear, descriptive filename
2. **Follow Format**: Use consistent markdown structure
3. **Update Index**: Add to `docs/INDEX.md`
4. **Cross-Reference**: Link to related documentation

---

## Best Practices

### 1. **Consistency**
- Use the same structure across all modules
- Follow established naming conventions
- Maintain consistent formatting

### 2. **Documentation**
- Every module should have a README
- Include examples and use cases
- Document all variables and outputs

### 3. **Organization**
- Group related functionality together
- Keep directories focused and purposeful
- Avoid deep nesting (max 3-4 levels)

### 4. **Maintenance**
- Regular cleanup of unused files
- Update documentation when code changes
- Version control everything

---

## Navigation Tips

### Finding Specific Files
1. **Start with docs/INDEX.md** - Overview of all documentation
2. **Use PROJECT_STRUCTURE.md** - Detailed file organization
3. **Check module READMEs** - Specific service documentation
4. **Search by filename** - Use your editor's search function

### Understanding Dependencies
1. **Check main.tf** - See how modules are connected
2. **Review variables.tf** - Understand configuration options
3. **Examine outputs.tf** - See what each module provides
4. **Read README files** - Get the complete picture

---

## Common Questions

### "Where do I start?"
Begin with `docs/INDEX.md` and follow the learning paths based on your experience level.

### "How do I add a new service?"
Follow the "Adding New Modules" section above and maintain consistency with existing modules.

### "Why are files organized this way?"
The structure prioritizes clarity, maintainability, and beginner-friendliness while following professional standards.

---

<div align="center">
  <p><em>Your project structure is now clear and organized!</em></p>
</div>
