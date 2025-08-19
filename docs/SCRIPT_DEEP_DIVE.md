# Script Deep Dive - Understanding the Automation

This guide provides a comprehensive understanding of the PowerShell and shell scripts used in the AWS Security Lab.

## Overview

The AWS Security Lab includes several automation scripts that help you:
- Set up your environment quickly
- Deploy infrastructure automatically
- Monitor and manage your resources
- Clean up when finished

Understanding these scripts will help you customize them for your needs and troubleshoot any issues.

## Script Architecture

### Script Organization

```
scripts/
├── setup/           # Environment setup scripts
├── deployment/      # Infrastructure deployment scripts
├── monitoring/      # Resource monitoring scripts
├── cleanup/         # Resource cleanup scripts
└── utilities/       # Helper and utility scripts
```

### Script Types

1. **Setup Scripts** - Prepare your local environment
2. **Deployment Scripts** - Deploy AWS infrastructure
3. **Monitoring Scripts** - Monitor resource health and costs
4. **Cleanup Scripts** - Remove resources to avoid costs
5. **Utility Scripts** - Helper functions and tools

## Core Setup Scripts

### Environment Setup (`setup/environment-setup.ps1`)

**Purpose**: Configures your local environment for the lab.

**What it does**:
- Checks for required tools (AWS CLI, Terraform)
- Sets up environment variables
- Creates necessary directories
- Validates AWS credentials

**Key Functions**:
```powershell
function Test-RequiredTools {
    # Checks if AWS CLI and Terraform are installed
    # Returns success/failure status
}

function Set-EnvironmentVariables {
    # Loads environment variables from .env.lab file
    # Sets AWS configuration
}

function Test-AWSCredentials {
    # Validates AWS credentials work
    # Tests basic AWS API calls
}
```

**Usage**:
```powershell
# Run the setup script
.\scripts\setup\environment-setup.ps1

# Check setup status
Get-EnvironmentStatus
```

### AWS Credential Setup (`setup/aws-credentials.ps1`)

**Purpose**: Helps you configure AWS credentials securely.

**What it does**:
- Guides you through credential setup
- Creates AWS CLI configuration
- Tests credential validity
- Sets up named profiles

**Key Functions**:
```powershell
function New-AWSCredentialProfile {
    # Creates a new AWS CLI profile
    # Prompts for access key and secret key
}

function Test-CredentialProfile {
    # Tests if a credential profile works
    # Makes test API calls to verify access
}

function Set-DefaultProfile {
    # Sets the default AWS profile
    # Updates environment variables
}
```

**Usage**:
```powershell
# Interactive credential setup
.\scripts\setup\aws-credentials.ps1

# Setup specific profile
.\scripts\setup\aws-credentials.ps1 -ProfileName "lab-profile"
```

## Deployment Scripts

### Infrastructure Deploy (`deployment/deploy-infrastructure.ps1`)

**Purpose**: Deploys the complete lab infrastructure using Terraform.

**What it does**:
- Initializes Terraform
- Plans infrastructure changes
- Applies the configuration
- Monitors deployment progress
- Reports deployment status

**Key Functions**:
```powershell
function Initialize-Terraform {
    # Runs terraform init
    # Downloads providers and modules
}

function Plan-Infrastructure {
    # Runs terraform plan
    # Shows what will be created
}

function Deploy-Infrastructure {
    # Runs terraform apply
    # Creates AWS resources
}

function Monitor-Deployment {
    # Tracks resource creation
    # Reports progress and status
}
```

**Usage**:
```powershell
# Deploy everything
.\scripts\deployment\deploy-infrastructure.ps1

# Deploy specific modules
.\scripts\deployment\deploy-infrastructure.ps1 -Modules "vpc,security_groups"

# Dry run (plan only)
.\scripts\deployment\deploy-infrastructure.ps1 -PlanOnly
```

### Module Deployment (`deployment/deploy-module.ps1`)

**Purpose**: Deploys individual Terraform modules.

**What it does**:
- Deploys specific modules in dependency order
- Handles module dependencies automatically
- Reports module deployment status
- Validates module outputs

**Key Functions**:
```powershell
function Deploy-Module {
    # Deploys a specific module
    # Handles dependencies
}

function Get-ModuleDependencies {
    # Determines module deployment order
    # Checks for required outputs
}

function Validate-ModuleOutputs {
    # Verifies module outputs are correct
    # Tests module functionality
}
```

**Usage**:
```powershell
# Deploy VPC module
.\scripts\deployment\deploy-module.ps1 -ModuleName "vpc"

# Deploy with dependencies
.\scripts\deployment\deploy-module.ps1 -ModuleName "ec2" -IncludeDependencies
```

## Monitoring Scripts

### Resource Monitor (`monitoring/resource-monitor.ps1`)

**Purpose**: Monitors the health and status of your AWS resources.

**What it does**:
- Checks EC2 instance status
- Monitors security group configurations
- Tracks S3 bucket access
- Reports resource costs

**Key Functions**:
```powershell
function Get-ResourceStatus {
    # Gets current status of all resources
    # Reports health and issues
}

function Monitor-SecurityGroups {
    # Checks security group configurations
    # Identifies potential security issues
}

function Track-ResourceCosts {
    # Monitors AWS costs
    # Reports spending trends
}
```

**Usage**:
```powershell
# Monitor all resources
.\scripts\monitoring\resource-monitor.ps1

# Monitor specific resource types
.\scripts\monitoring\resource-monitor.ps1 -ResourceTypes "ec2,s3"

# Continuous monitoring
.\scripts\monitoring\resource-monitor.ps1 -Continuous -Interval 300
```

### Security Monitor (`monitoring/security-monitor.ps1`)

**Purpose**: Monitors security services and reports findings.

**What it does**:
- Checks GuardDuty findings
- Monitors Security Hub status
- Reports CloudTrail events
- Identifies security issues

**Key Functions**:
```powershell
function Get-GuardDutyFindings {
    # Retrieves GuardDuty security findings
    # Categorizes by severity
}

function Check-SecurityHubCompliance {
    # Checks Security Hub compliance status
    # Reports compliance issues
}

function Monitor-CloudTrailEvents {
    # Monitors API activity
    # Identifies suspicious behavior
}
```

**Usage**:
```powershell
# Check security status
.\scripts\monitoring\security-monitor.ps1

# Monitor specific services
.\scripts\monitoring\security-monitor.ps1 -Services "guardduty,securityhub"

# Generate security report
.\scripts\monitoring\security-monitor.ps1 -GenerateReport
```

## Cleanup Scripts

### Resource Cleanup (`cleanup/cleanup-resources.ps1`)

**Purpose**: Removes AWS resources to avoid unnecessary costs.

**What it does**:
- Destroys Terraform infrastructure
- Removes manually created resources
- Cleans up local files
- Reports cleanup status

**Key Functions**:
```powershell
function Remove-TerraformResources {
    # Runs terraform destroy
    # Removes all managed resources
}

function Remove-ManualResources {
    # Removes resources not managed by Terraform
    # Cleans up orphaned resources
}

function Clean-LocalFiles {
    # Removes temporary files
    # Cleans up local state
}
```

**Usage**:
```powershell
# Clean up everything
.\scripts\cleanup\cleanup-resources.ps1

# Clean up specific resources
.\scripts\cleanup\cleanup-resources.ps1 -ResourceTypes "ec2,s3"

# Dry run (show what will be removed)
.\scripts\cleanup\cleanup-resources.ps1 -WhatIf
```

### Cost Analysis (`cleanup/cost-analysis.ps1`)

**Purpose**: Analyzes AWS costs and identifies optimization opportunities.

**What it does**:
- Calculates current month costs
- Identifies high-cost resources
- Suggests cost optimizations
- Generates cost reports

**Key Functions**:
```powershell
function Get-CostBreakdown {
    # Gets cost breakdown by service
    # Shows spending trends
}

function Identify-CostDrivers {
    # Identifies resources driving costs
    # Suggests optimization strategies
}

function Generate-CostReport {
    # Creates detailed cost report
    # Exports to CSV or JSON
}
```

**Usage**:
```powershell
# Analyze current costs
.\scripts\cleanup\cost-analysis.ps1

# Generate detailed report
.\scripts\cleanup\cost-analysis.ps1 -GenerateReport -Format CSV

# Analyze specific time period
.\scripts\cleanup\cost-analysis.ps1 -StartDate "2024-01-01" -EndDate "2024-01-31"
```

## Utility Scripts

### AWS CLI Helper (`utilities/aws-helper.ps1`)

**Purpose**: Provides helper functions for common AWS operations.

**What it does**:
- Simplifies common AWS CLI commands
- Provides consistent error handling
- Offers interactive prompts
- Validates inputs

**Key Functions**:
```powershell
function Invoke-AWSCommand {
    # Executes AWS CLI commands
    # Handles errors and retries
}

function Get-AWSResource {
    # Retrieves AWS resources
    # Provides consistent output format
}

function Test-AWSConnectivity {
    # Tests AWS service connectivity
    # Reports connection issues
}
```

**Usage**:
```powershell
# Source the helper functions
. .\scripts\utilities\aws-helper.ps1

# Use helper functions
Get-AWSResource -Service "ec2" -ResourceType "instances"
Test-AWSConnectivity -Services "ec2,s3,iam"
```

### Terraform Helper (`utilities/terraform-helper.ps1`)

**Purpose**: Provides helper functions for Terraform operations.

**What it does**:
- Simplifies Terraform commands
- Provides status reporting
- Offers validation functions
- Handles common errors

**Key Functions**:
```powershell
function Invoke-TerraformCommand {
    # Executes Terraform commands
    # Provides consistent output
}

function Get-TerraformStatus {
    # Gets current Terraform status
    # Reports resource state
}

function Validate-TerraformConfig {
    # Validates Terraform configuration
    # Reports configuration issues
}
```

**Usage**:
```powershell
# Source the helper functions
. .\scripts\utilities\terraform-helper.ps1

# Use helper functions
Get-TerraformStatus
Validate-TerraformConfig -Path ".\terraform"
```

## Script Configuration

### Environment Variables

Scripts use environment variables for configuration:

```powershell
# Required environment variables
$env:AWS_ACCESS_KEY_ID = "your-access-key"
$env:AWS_SECRET_ACCESS_KEY = "your-secret-key"
$env:AWS_DEFAULT_REGION = "us-east-1"
$env:ENVIRONMENT = "lab"

# Optional environment variables
$env:LOG_LEVEL = "INFO"
$env:ENABLE_NOTIFICATIONS = "true"
$env:NOTIFICATION_EMAIL = "admin@example.com"
```

### Configuration Files

Scripts can use configuration files:

```json
// config.json
{
  "aws": {
    "region": "us-east-1",
    "profile": "lab-profile"
  },
  "terraform": {
    "working_directory": "./terraform",
    "backend_config": {
      "bucket": "my-terraform-state",
      "key": "lab/terraform.tfstate"
    }
  },
  "monitoring": {
    "enabled": true,
    "interval": 300,
    "services": ["ec2", "s3", "iam"]
  }
}
```

## Error Handling

### Error Types

Scripts handle different types of errors:

1. **AWS API Errors** - Network issues, permission problems
2. **Terraform Errors** - Configuration issues, state problems
3. **System Errors** - Missing tools, file system issues
4. **User Errors** - Invalid input, configuration mistakes

### Error Handling Strategies

```powershell
function Handle-Error {
    param(
        [string]$ErrorMessage,
        [string]$ErrorType,
        [int]$ExitCode
    )
    
    # Log the error
    Write-Log -Level "ERROR" -Message $ErrorMessage
    
    # Provide helpful suggestions
    switch ($ErrorType) {
        "AWS_API" { Write-Host "Check your AWS credentials and permissions" }
        "TERRAFORM" { Write-Host "Check your Terraform configuration" }
        "SYSTEM" { Write-Host "Check if required tools are installed" }
        "USER" { Write-Host "Check your input parameters" }
    }
    
    # Exit with appropriate code
    exit $ExitCode
}
```

## Logging and Output

### Logging Levels

Scripts use different logging levels:

```powershell
enum LogLevel {
    DEBUG = 0
    INFO = 1
    WARN = 2
    ERROR = 3
    FATAL = 4
}
```

### Logging Functions

```powershell
function Write-Log {
    param(
        [LogLevel]$Level,
        [string]$Message,
        [string]$Component = "Script"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] [$Component] $Message"
    
    switch ($Level) {
        "DEBUG" { Write-Debug $logMessage }
        "INFO" { Write-Host $logMessage -ForegroundColor Green }
        "WARN" { Write-Warning $logMessage }
        "ERROR" { Write-Error $logMessage }
        "FATAL" { Write-Error $logMessage; exit 1 }
    }
}
```

## Testing Scripts

### Unit Testing

Test individual script functions:

```powershell
# Test environment setup
Describe "Environment Setup" {
    It "Should check required tools" {
        Test-RequiredTools | Should -Be $true
    }
    
    It "Should validate AWS credentials" {
        Test-AWSCredentials | Should -Be $true
    }
}
```

### Integration Testing

Test script interactions:

```powershell
# Test complete workflow
Describe "Complete Workflow" {
    It "Should deploy infrastructure successfully" {
        $result = Deploy-Infrastructure
        $result.Success | Should -Be $true
    }
    
    It "Should monitor resources correctly" {
        $status = Get-ResourceStatus
        $status.Healthy | Should -Be $true
    }
}
```

## Customizing Scripts

### Adding New Functions

To add new functionality:

1. **Create Function** - Add new PowerShell function
2. **Add Parameters** - Define input parameters
3. **Add Validation** - Validate inputs and outputs
4. **Add Documentation** - Document function purpose and usage
5. **Add Tests** - Create tests for new functionality

### Example Custom Function

```powershell
function New-CustomResource {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ResourceName,
        
        [Parameter(Mandatory=$true)]
        [string]$ResourceType,
        
        [hashtable]$Tags = @{}
    )
    
    # Validate inputs
    if ([string]::IsNullOrEmpty($ResourceName)) {
        throw "Resource name cannot be empty"
    }
    
    # Create resource
    try {
        $result = aws resourcegroupstaggingapi tag-resources `
            --resource-arn-list "arn:aws:$ResourceType::*:$ResourceName" `
            --tags $Tags
        
        Write-Log -Level "INFO" -Message "Created custom resource: $ResourceName"
        return $result
    }
    catch {
        Handle-Error -ErrorMessage "Failed to create resource: $ResourceName" -ErrorType "AWS_API" -ExitCode 1
    }
}
```

## Troubleshooting Scripts

### Common Issues

1. **Permission Errors**
   - Check AWS credentials and permissions
   - Verify IAM user has required policies
   - Check if credentials have expired

2. **Tool Not Found**
   - Verify AWS CLI is installed and in PATH
   - Check Terraform installation
   - Restart terminal after installation

3. **Configuration Errors**
   - Check environment variables
   - Verify configuration files
   - Check file paths and permissions

### Debug Mode

Enable debug mode for troubleshooting:

```powershell
# Enable debug output
$env:LOG_LEVEL = "DEBUG"
$env:ENABLE_DEBUG = "true"

# Run script with debug
.\scripts\deployment\deploy-infrastructure.ps1 -Debug
```

### Getting Help

1. **Check Script Help** - Use `Get-Help` for function documentation
2. **Review Logs** - Check script output and error messages
3. **Check Dependencies** - Verify required tools and services
4. **Community Support** - Use GitHub issues and discussions

## Best Practices

### Script Development

1. **Error Handling** - Always handle errors gracefully
2. **Input Validation** - Validate all user inputs
3. **Logging** - Provide clear logging and output
4. **Documentation** - Document all functions and parameters
5. **Testing** - Test scripts thoroughly before use

### Security Considerations

1. **Credential Management** - Never hardcode credentials
2. **Permission Principle** - Use least privilege access
3. **Input Sanitization** - Sanitize all user inputs
4. **Audit Logging** - Log all important actions

### Performance Optimization

1. **Batch Operations** - Group operations when possible
2. **Async Operations** - Use async operations for long-running tasks
3. **Resource Cleanup** - Clean up resources promptly
4. **Monitoring** - Monitor script performance and resource usage

## Next Steps

After understanding the scripts:

1. **Customize for Your Needs** - Modify scripts to fit your requirements
2. **Add New Functionality** - Extend scripts with new features
3. **Create New Scripts** - Build additional automation tools
4. **Contribute Back** - Share improvements with the community

---

**Remember**: Scripts are tools to help you work more efficiently. Understanding how they work will help you use them effectively and customize them for your specific needs.
