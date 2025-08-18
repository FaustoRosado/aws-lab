# 🏗️ Project Structure & Organization Guide

This document explains the organization and structure of the AWS Security Lab repository, helping you understand why files are organized the way they are and how to navigate the project effectively.

## 📁 Root Directory Overview

```
aws-lab/
├── 📁 docs/                    # Comprehensive documentation
├── 📁 scripts/                 # PowerShell and automation scripts
├── 📁 terraform/               # Infrastructure as Code (Terraform)
├── 📄 README.md                # Main project overview
├── 📄 .gitignore              # Git ignore patterns
└── 📄 LICENSE                 # Project license
```

---

## 🎯 Why This Structure?

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

## 📚 Documentation Directory (`docs/`)

### Purpose
The `docs/` directory contains all project documentation, separated from code to ensure easy access and maintenance.

### Structure
```
docs/
├── 📄 README.md                    # Main project overview
├── 📄 SETUP_GUIDE.md              # Step-by-step setup instructions
├── 📄 AWS_CREDENTIALS_SETUP.md    # AWS authentication guide
├── 📄 PROJECT_STRUCTURE.md        # This file - structure explanation
├── 📄 MODULE_DOCUMENTATION.md     # Detailed Terraform module explanations
├── 📄 LAB_CHECKLIST.md            # Lab completion checklist
└── 📄 QUICK_START.md              # Fast deployment guide
```

### Why Separate Documentation?
- **Easy to find**: Users know exactly where to look for help
- **Maintainable**: Documentation can be updated without touching code
- **Version control**: Track documentation changes separately
- **Collaboration**: Multiple contributors can work on docs simultaneously

---

## 🔧 Scripts Directory (`scripts/`)

### Purpose
The `scripts/` directory contains PowerShell and automation scripts that streamline lab operations.

### Structure
```
scripts/
├── 📄 setup_lab.ps1              # Main lab management script
└── 📄 simulate_compromise.ps1     # Attack simulation script
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

## 🏗️ Terraform Directory (`terraform/`)

### Purpose
The `terraform/` directory contains all Infrastructure as Code (IaC) configurations for the AWS lab.

### Structure
```
terraform/
├── 📄 main.tf                    # Main configuration file
├── 📄 variables.tf               # Input variable definitions
├── 📄 outputs.tf                 # Output value definitions
├── 📄 versions.tf                # Provider and version constraints
└── 📁 modules/                   # Reusable Terraform modules
    ├── 📁 vpc/                   # VPC and networking
    ├── 📁 security_groups/       # Security group definitions
    ├── 📁 ec2/                   # EC2 instance configurations
    ├── 📁 s3/                    # S3 bucket configurations
    ├── 📁 guardduty/             # GuardDuty service setup
    ├── 📁 security_hub/          # Security Hub configuration
    ├── 📁 cloudwatch/            # CloudWatch monitoring
    └── 📁 iam/                   # IAM roles and policies
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

## 🔍 Detailed Module Breakdown

### VPC Module (`modules/vpc/`)
```
modules/vpc/
├── 📄 main.tf                    # VPC, subnets, route tables
├── 📄 variables.tf               # Input parameters
└── 📄 outputs.tf                 # Exported values
```

**Why This Structure?**
- **Single Responsibility**: Only handles networking
- **Reusable**: Can be used in other projects
- **Configurable**: Variables for different environments

### EC2 Module (`modules/ec2/`)
```
modules/ec2/
├── 📄 main.tf                    # Instance definitions
├── 📄 variables.tf               # Configuration parameters
├── 📄 outputs.tf                 # Instance information
├── 📁 user_data/                 # Instance setup scripts
│   ├── 📄 web_server.sh          # Web server configuration
│   └── 📄 database_server.sh     # Database setup
└── 📁 ssh/                       # SSH key management
    ├── 📄 lab-key                # Private SSH key
    └── 📄 lab-key.pub            # Public SSH key
```

**Why This Organization?**
- **User Data Scripts**: Separate from Terraform for clarity
- **SSH Keys**: Isolated for security
- **Platform Independence**: Shell scripts work on any Linux instance

### Security Groups Module (`modules/security_groups/`)
```
modules/security_groups/
├── 📄 main.tf                    # Security group definitions
├── 📄 variables.tf               # VPC and environment parameters
└── 📄 outputs.tf                 # Security group IDs
```

**Why Separate Security Groups?**
- **Network Security**: Critical for lab safety
- **Complex Rules**: Many ingress/egress rules
- **Reusability**: Can be applied to different instances

---

## 📋 File Naming Conventions

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

## 🔄 Workflow Integration

### How Files Work Together

```
1. User runs setup_lab.ps1
   ↓
2. Script checks prerequisites (AWS CLI, Terraform)
   ↓
3. Terraform initializes and reads main.tf
   ↓
4. Main.tf calls individual modules
   ↓
5. Modules create AWS resources
   ↓
6. Outputs provide connection information
   ↓
7. User can run simulation scripts
```

### File Dependencies
- **Main Scripts** → **Terraform** → **AWS Resources**
- **Documentation** → **User Guidance** → **Successful Execution**
- **Modules** → **Reusable Components** → **Consistent Infrastructure**

---

## 🌍 Cross-Platform Considerations

### Windows Users
- **PowerShell Scripts**: Native execution
- **Terraform**: Works identically
- **AWS CLI**: Same commands and syntax

### Mac Users
- **Scripts**: Can be adapted to Bash
- **Terraform**: Identical functionality
- **AWS CLI**: Same configuration and usage

### Why This Approach?
- **Consistency**: Same infrastructure regardless of OS
- **Learning**: Users learn platform-agnostic concepts
- **Flexibility**: Easy to adapt for different environments

---

## 📊 Benefits of This Structure

### 1. **For Beginners**
- **Clear Navigation**: Easy to find what you need
- **Logical Flow**: Follows natural learning progression
- **Comprehensive Coverage**: All aspects documented

### 2. **For Educators**
- **Modular Teaching**: Focus on specific concepts
- **Consistent Patterns**: Students learn best practices
- **Easy Customization**: Adapt for different skill levels

### 3. **For Professionals**
- **Production Ready**: Follows industry standards
- **Maintainable**: Easy to update and extend
- **Collaborative**: Multiple team members can contribute

---

## 🚀 How to Navigate This Project

### 1. **Start Here**
- Read `README.md` for project overview
- Follow `QUICK_START.md` for fast deployment
- Use `SETUP_GUIDE.md` for detailed setup

### 2. **Understand Infrastructure**
- Review `PROJECT_STRUCTURE.md` (this file)
- Study `MODULE_DOCUMENTATION.md` for technical details
- Examine Terraform files for implementation

### 3. **Execute the Lab**
- Use `scripts/setup_lab.ps1` for management
- Follow `LAB_CHECKLIST.md` for completion tracking
- Run simulation scripts for hands-on learning

### 4. **Customize and Extend**
- Modify Terraform modules for your needs
- Add new security scenarios
- Integrate with existing infrastructure

---

## 🔧 Customization Guidelines

### Adding New Modules
1. **Create Directory**: `modules/new_service/`
2. **Standard Files**: `main.tf`, `variables.tf`, `outputs.tf`
3. **Update Main**: Add module call to `main.tf`
4. **Document**: Add to `MODULE_DOCUMENTATION.md`

### Adding New Scripts
1. **Place in Scripts**: `scripts/new_script.ps1`
2. **Follow Naming**: Descriptive, clear purpose
3. **Document**: Update relevant documentation
4. **Test**: Verify functionality before committing

### Adding New Documentation
1. **Place in Docs**: `docs/new_guide.md`
2. **Consistent Format**: Follow existing markdown style
3. **Cross-Reference**: Link to related documents
4. **Update Index**: Add to main README if appropriate

---

## 📈 Scaling Considerations

### Small Labs
- Use existing modules as-is
- Minimal customization required
- Focus on learning concepts

### Medium Labs
- Modify module parameters
- Add custom security groups
- Extend monitoring and alerting

### Large Labs
- Create new modules
- Integrate with existing infrastructure
- Implement advanced security controls

---

## 🎓 Learning Path

### Phase 1: Understanding
1. Read project documentation
2. Examine Terraform configurations
3. Understand module relationships

### Phase 2: Execution
1. Set up AWS credentials
2. Deploy infrastructure
3. Run security scenarios

### Phase 3: Customization
1. Modify existing modules
2. Add new security controls
3. Integrate with your environment

### Phase 4: Extension
1. Create new modules
2. Develop additional scenarios
3. Share improvements with community

---

## 🔍 Troubleshooting Structure Issues

### Common Problems

#### 1. **File Not Found**
- **Check Path**: Ensure correct directory structure
- **Verify Names**: Confirm exact file names
- **Case Sensitivity**: Some systems are case-sensitive

#### 2. **Module Errors**
- **Check Dependencies**: Ensure required modules exist
- **Verify Variables**: Check input/output consistency
- **Review Syntax**: Validate Terraform syntax

#### 3. **Script Issues**
- **Permissions**: Ensure scripts are executable
- **Dependencies**: Check required tools are installed
- **Environment**: Verify correct working directory

### Getting Help
1. **Check Documentation**: Start with relevant guides
2. **Review Structure**: Understand file relationships
3. **Examine Logs**: Look for error messages
4. **Community Support**: Use repository issues

---

## 📝 Best Practices

### 1. **File Organization**
- Keep related files together
- Use descriptive names
- Maintain consistent structure

### 2. **Documentation**
- Document everything
- Keep it up to date
- Use clear, simple language

### 3. **Code Quality**
- Follow Terraform best practices
- Use consistent formatting
- Include helpful comments

### 4. **Version Control**
- Commit frequently
- Use descriptive commit messages
- Tag important releases

---

## 🎯 Summary

This project structure is designed to be:

- **🏗️ Logical**: Clear organization and relationships
- **📚 Educational**: Easy to learn and understand
- **🔧 Practical**: Ready for real-world use
- **🌍 Flexible**: Adaptable to different needs
- **📈 Scalable**: Easy to extend and customize

By following this structure, you'll have a solid foundation for:
- Learning AWS security concepts
- Building production-ready infrastructure
- Collaborating with team members
- Contributing to the community

Remember: **Good structure leads to good understanding, and good understanding leads to successful execution.**

Happy learning! 🚀🔒
