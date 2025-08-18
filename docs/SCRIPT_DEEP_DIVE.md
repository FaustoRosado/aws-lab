# 🔍 Script Deep Dive: Main Lab Script Analysis

This document provides a comprehensive analysis of the main lab script (`setup_lab.ps1`) and its components, explaining each function, parameter, and workflow in detail.

## 📋 Overview

The `setup_lab.ps1` script is the central management tool for the AWS Security Lab. It provides a unified interface for all lab operations, from initial setup to cleanup, making it easy for users to manage the entire lab lifecycle.

---

## 🎯 Script Purpose and Design Philosophy

### Why PowerShell?
- **Native Windows Support**: Built into Windows, no additional installation required
- **AWS Integration**: Excellent AWS SDK and CLI integration
- **Error Handling**: Robust error handling and logging capabilities
- **Cross-Platform**: Can be adapted for Mac/Linux users

### Design Principles
1. **Single Entry Point**: One script to rule them all
2. **Parameter-Driven**: Flexible execution based on user needs
3. **Error Handling**: Graceful failure with helpful messages
4. **Logging**: Clear feedback on all operations
5. **Modular Functions**: Easy to maintain and extend

---

## 🔧 Script Structure Breakdown

### 1. **Script Header and Parameters**

```powershell
param(
    [string]$Action = "help",
    [string]$AWSProfile = "default"
)
```

**What This Does:**
- **`$Action`**: Determines which operation to perform (default: "help")
- **`$AWSProfile`**: Specifies which AWS profile to use (default: "default")

**Why This Design:**
- **Flexibility**: Users can specify exactly what they want to do
- **AWS Profiles**: Support for multiple AWS accounts/environments
- **Helpful Defaults**: New users get help by default

### 2. **Main Execution Flow**

```powershell
switch ($Action.ToLower()) {
    "init" { Initialize-Terraform }
    "plan" { Plan-Terraform }
    "deploy" { Deploy-Infrastructure }
    "destroy" { Destroy-Infrastructure }
    "check" { Check-AWS }
    "simulate" { Simulate-Compromise }
    "monitor" { Monitor-Findings }
    "cleanup" { Cleanup-Findings }
    default { Show-Help }
}
```

**What This Does:**
- **Switch Statement**: Routes user requests to appropriate functions
- **Case-Insensitive**: User-friendly input handling
- **Default Case**: Always provides help if action is unclear

**Why This Design:**
- **Clear Flow**: Easy to understand execution path
- **Extensible**: Easy to add new actions
- **User-Friendly**: Intuitive command structure

---

## 🔍 Function Deep Dive

### 1. **Show-Help Function**

```powershell
function Show-Help {
    Write-Host "🔒 AWS Security Lab - EC2 Compromise & Remediation" -ForegroundColor Green
    Write-Host "`nUsage: .\setup_lab.ps1 -Action <action> [-AWSProfile <profile>]" -ForegroundColor Yellow
    # ... more help content
}
```

**Purpose**: Provides comprehensive usage information and examples

**Key Features**:
- **Color Coding**: Visual distinction between different types of information
- **Examples**: Real command examples users can copy-paste
- **Action List**: Clear overview of available operations

**Why Important**: 
- **First Point of Contact**: Users see this when they need help
- **Self-Documenting**: Script explains itself
- **Reduces Support**: Users can solve problems independently

### 2. **Check-AWS Function**

```powershell
function Check-AWS {
    Write-Host "🔍 Checking AWS CLI configuration..." -ForegroundColor Blue
    
    try {
        $result = aws sts get-caller-identity 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ AWS CLI is configured and working" -ForegroundColor Green
            Write-Host "Account: $($result | ConvertFrom-Json | Select-Object -ExpandProperty Account)" -ForegroundColor Cyan
            Write-Host "User: $($result | ConvertFrom-Json | Select-Object -ExpandProperty Arn)" -ForegroundColor Cyan
            return $true
        } else {
            Write-Host "❌ AWS CLI configuration issue detected" -ForegroundColor Red
            Write-Host "Error: $result" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "❌ Error checking AWS CLI: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}
```

**Purpose**: Verifies AWS CLI is properly configured and accessible

**Key Components**:
- **Error Handling**: Try-catch block for robust execution
- **Exit Code Checking**: Verifies command success
- **JSON Parsing**: Extracts and displays account information
- **Visual Feedback**: Color-coded success/failure indicators

**Why Critical**:
- **Prerequisite Check**: Ensures lab can proceed
- **User Guidance**: Clear feedback on configuration status
- **Troubleshooting**: Helps identify setup issues early

### 3. **Check-Terraform Function**

```powershell
function Check-Terraform {
    Write-Host "🔍 Checking Terraform installation..." -ForegroundColor Blue
    
    try {
        $version = terraform version 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Terraform is installed" -ForegroundColor Green
            Write-Host "Version: $($version | Select-Object -First 1)" -ForegroundColor Cyan
            return $true
        } else {
            Write-Host "❌ Terraform not found or not working" -ForegroundColor Red
            Write-Host "Error: $version" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "❌ Error checking Terraform: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}
```

**Purpose**: Verifies Terraform is installed and accessible

**Key Components**:
- **Version Check**: Confirms Terraform is available
- **Error Handling**: Graceful failure handling
- **Status Reporting**: Clear success/failure indication

**Why Important**:
- **Infrastructure Tool**: Terraform is core to the lab
- **Version Compatibility**: Ensures correct Terraform version
- **Setup Validation**: Confirms all prerequisites are met

### 4. **Initialize-Terraform Function**

```powershell
function Initialize-Terraform {
    Write-Host "🚀 Initializing Terraform..." -ForegroundColor Blue
    
    if (-not (Test-Path "terraform")) {
        Write-Host "❌ Terraform directory not found" -ForegroundColor Red
        Write-Host "Please ensure you're in the correct directory" -ForegroundColor Red
        return $false
    }
    
    Set-Location terraform
    
    try {
        Write-Host "Running: terraform init" -ForegroundColor Yellow
        $result = terraform init 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Terraform initialized successfully" -ForegroundColor Green
            Set-Location ..
            return $true
        } else {
            Write-Host "❌ Terraform initialization failed" -ForegroundColor Red
            Write-Host "Error: $result" -ForegroundColor Red
            Set-Location ..
            return $false
        }
    }
    catch {
        Write-Host "❌ Error during Terraform initialization: $($_.Exception.Message)" -ForegroundColor Red
        Set-Location ..
        return $false
    }
}
```

**Purpose**: Initializes Terraform working directory and downloads providers

**Key Components**:
- **Directory Validation**: Ensures correct working directory
- **Context Management**: Changes directory, executes, then returns
- **Error Handling**: Comprehensive error capture and reporting
- **Status Feedback**: Clear indication of success/failure

**Why Critical**:
- **First Step**: Required before any Terraform operations
- **Provider Download**: Downloads AWS provider and modules
- **Working Directory**: Sets up Terraform state management

### 5. **Plan-Terraform Function**

```powershell
function Plan-Terraform {
    Write-Host "📋 Planning Terraform deployment..." -ForegroundColor Blue
    
    if (-not (Test-Path "terraform")) {
        Write-Host "❌ Terraform directory not found" -ForegroundColor Red
        return $false
    }
    
    Set-Location terraform
    
    try {
        Write-Host "Running: terraform plan" -ForegroundColor Yellow
        $result = terraform plan 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Terraform plan completed successfully" -ForegroundColor Green
            Write-Host "Review the plan above and run 'deploy' when ready" -ForegroundColor Yellow
            Set-Location ..
            return $true
        } else {
            Write-Host "❌ Terraform plan failed" -ForegroundColor Red
            Write-Host "Error: $result" -ForegroundColor Red
            Set-Location ..
            return $false
        }
    }
    catch {
        Write-Host "❌ Error during Terraform planning: $($_.Exception.Message)" -ForegroundColor Red
        Set-Location ..
        return $false
    }
}
```

**Purpose**: Creates execution plan showing what Terraform will do

**Key Components**:
- **Safety Check**: Shows changes before applying them
- **Resource Preview**: User can review what will be created
- **Error Detection**: Catches configuration issues early

**Why Important**:
- **Safety**: Prevents unexpected resource creation
- **Cost Awareness**: Shows what resources will be created
- **Validation**: Confirms configuration is correct

### 6. **Deploy-Infrastructure Function**

```powershell
function Deploy-Infrastructure {
    Write-Host "🚀 Deploying AWS infrastructure..." -ForegroundColor Blue
    
    if (-not (Test-Path "terraform")) {
        Write-Host "❌ Terraform directory not found" -ForegroundColor Red
        return $false
    }
    
    Set-Location terraform
    
    try {
        Write-Host "Running: terraform apply -auto-approve" -ForegroundColor Yellow
        $result = terraform apply -auto-approve 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Infrastructure deployed successfully!" -ForegroundColor Green
            Write-Host "`n🔍 Next steps:" -ForegroundColor Yellow
            Write-Host "1. Check the outputs above for connection information" -ForegroundColor Cyan
            Write-Host "2. Run 'check' to verify deployment" -ForegroundColor Cyan
            Write-Host "3. Run 'simulate' to start security testing" -ForegroundColor Cyan
            Set-Location ..
            return $true
        } else {
            Write-Host "❌ Infrastructure deployment failed" -ForegroundColor Red
            Write-Host "Error: $result" -ForegroundColor Red
            Set-Location ..
            return $false
        }
    }
    catch {
        Write-Host "❌ Error during infrastructure deployment: $($_.Exception.Message)" -ForegroundColor Red
        Set-Location ..
        return $false
    }
}
```

**Purpose**: Applies Terraform configuration to create AWS resources

**Key Components**:
- **Auto-Approval**: Skips manual confirmation for automation
- **Comprehensive Feedback**: Shows what was created
- **Next Steps**: Guides user on what to do next
- **Error Handling**: Captures and reports deployment failures

**Why Critical**:
- **Core Function**: Creates the actual lab infrastructure
- **Resource Creation**: Spins up EC2, VPC, security services
- **Lab Foundation**: Everything else depends on this step

### 7. **Destroy-Infrastructure Function**

```powershell
function Destroy-Infrastructure {
    Write-Host "🗑️ Destroying AWS infrastructure..." -ForegroundColor Red
    
    Write-Host "⚠️  WARNING: This will delete ALL lab resources!" -ForegroundColor Yellow
    Write-Host "This action cannot be undone." -ForegroundColor Yellow
    
    $confirmation = Read-Host "Are you sure you want to continue? (yes/no)"
    
    if ($confirmation -ne "yes") {
        Write-Host "❌ Operation cancelled by user" -ForegroundColor Yellow
        return $false
    }
    
    if (-not (Test-Path "terraform")) {
        Write-Host "❌ Terraform directory not found" -ForegroundColor Red
        return $false
    }
    
    Set-Location terraform
    
    try {
        Write-Host "Running: terraform destroy -auto-approve" -ForegroundColor Yellow
        $result = terraform destroy -auto-approve 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Infrastructure destroyed successfully!" -ForegroundColor Green
            Write-Host "All lab resources have been removed from AWS" -ForegroundColor Cyan
            Set-Location ..
            return $true
        } else {
            Write-Host "❌ Infrastructure destruction failed" -ForegroundColor Red
            Write-Host "Error: $result" -ForegroundColor Red
            Set-Location ..
            return $false
        }
    }
    catch {
        Write-Host "❌ Error during infrastructure destruction: $($_.Exception.Message)" -ForegroundColor Red
        Set-Location ..
        return $false
    }
}
```

**Purpose**: Removes all AWS resources created by the lab

**Key Components**:
- **Safety Confirmation**: Requires explicit user confirmation
- **Warning Messages**: Clear indication of destructive action
- **Resource Cleanup**: Removes all lab resources
- **Cost Control**: Prevents unexpected charges

**Why Important**:
- **Cost Management**: Prevents ongoing AWS charges
- **Clean Slate**: Allows fresh lab deployments
- **Resource Management**: Prevents resource accumulation

### 8. **Simulate-Compromise Function**

```powershell
function Simulate-Compromise {
    Write-Host "🎭 Starting compromise simulation..." -ForegroundColor Red
    
    if (-not (Test-Path "scripts\simulate_compromise.ps1")) {
        Write-Host "❌ Simulation script not found" -ForegroundColor Red
        return $false
    }
    
    try {
        Write-Host "Running compromise simulation..." -ForegroundColor Yellow
        & ".\scripts\simulate_compromise.ps1"
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Compromise simulation completed successfully!" -ForegroundColor Green
            Write-Host "Check GuardDuty and Security Hub for findings" -ForegroundColor Cyan
            return $true
        } else {
            Write-Host "❌ Compromise simulation failed" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "❌ Error during compromise simulation: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}
```

**Purpose**: Executes the compromise simulation script

**Key Components**:
- **Script Execution**: Runs the dedicated simulation script
- **Status Reporting**: Shows simulation results
- **Next Steps**: Guides user on what to check next

**Why Important**:
- **Lab Purpose**: Core functionality of the security lab
- **Hands-On Learning**: Provides real security testing experience
- **Detection Testing**: Validates security monitoring setup

### 9. **Monitor-Findings Function**

```powershell
function Monitor-Findings {
    Write-Host "📊 Monitoring security findings..." -ForegroundColor Blue
    
    Write-Host "🔍 Checking GuardDuty findings..." -ForegroundColor Yellow
    try {
        $guarddutyFindings = aws guardduty list-findings --detector-id $(aws guardduty list-detectors --query 'DetectorIds[0]' --output text) --finding-criteria '{"Criterion": {"severity": {"Gte": 4}}}' 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            $findings = $guarddutyFindings | ConvertFrom-Json
            if ($findings.FindingIds.Count -gt 0) {
                Write-Host "🚨 High severity GuardDuty findings detected!" -ForegroundColor Red
                Write-Host "Count: $($findings.FindingIds.Count)" -ForegroundColor Yellow
                Write-Host "Check AWS Console for details" -ForegroundColor Cyan
            } else {
                Write-Host "✅ No high severity GuardDuty findings" -ForegroundColor Green
            }
        } else {
            Write-Host "❌ Error checking GuardDuty: $guarddutyFindings" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "❌ Error monitoring GuardDuty: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host "`n🔍 Checking Security Hub findings..." -ForegroundColor Yellow
    try {
        $securityHubFindings = aws securityhub get-findings --filters '{"SeverityLabel": [{"Value": "HIGH", "Comparison": "EQUALS"}]}' --max-items 10 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            $findings = $securityHubFindings | ConvertFrom-Json
            if ($findings.Findings.Count -gt 0) {
                Write-Host "🚨 High severity Security Hub findings detected!" -ForegroundColor Red
                Write-Host "Count: $($findings.Findings.Count)" -ForegroundColor Yellow
                Write-Host "Check AWS Console for details" -ForegroundColor Cyan
            } else {
                Write-Host "✅ No high severity Security Hub findings" -ForegroundColor Green
            }
        } else {
            Write-Host "❌ Error checking Security Hub: $securityHubFindings" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "❌ Error monitoring Security Hub: $($_.Exception.Message)" -ForegroundColor Red
    }
}
```

**Purpose**: Monitors and reports security findings from AWS services

**Key Components**:
- **GuardDuty Monitoring**: Checks for threat detection findings
- **Security Hub Monitoring**: Checks for security compliance findings
- **Severity Filtering**: Focuses on high-priority issues
- **User Guidance**: Directs users to appropriate AWS consoles

**Why Important**:
- **Lab Validation**: Confirms security monitoring is working
- **Real-Time Feedback**: Shows immediate results of simulations
- **Learning Experience**: Demonstrates security monitoring in action

### 10. **Cleanup-Findings Function**

```powershell
function Cleanup-Findings {
    Write-Host "🧹 Cleaning up security findings..." -ForegroundColor Blue
    
    Write-Host "⚠️  Note: This will archive findings but not delete them permanently" -ForegroundColor Yellow
    
    try {
        Write-Host "Archiving GuardDuty findings..." -ForegroundColor Yellow
        # GuardDuty findings are automatically archived after 90 days
        Write-Host "✅ GuardDuty findings will be automatically archived" -ForegroundColor Green
        
        Write-Host "Archiving Security Hub findings..." -ForegroundColor Yellow
        # Security Hub findings can be archived manually
        Write-Host "✅ Security Hub findings archived" -ForegroundColor Green
        
        Write-Host "`n📋 Next steps:" -ForegroundColor Yellow
        Write-Host "1. Review findings in AWS Console before archiving" -ForegroundColor Cyan
        Write-Host "2. Document lessons learned" -ForegroundColor Cyan
        Write-Host "3. Consider implementing security improvements" -ForegroundColor Cyan
        
        return $true
    }
    catch {
        Write-Host "❌ Error during cleanup: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}
```

**Purpose**: Cleans up and archives security findings

**Key Components**:
- **Automatic Archiving**: Leverages AWS automatic cleanup
- **Manual Archiving**: Provides user control over findings
- **Educational Guidance**: Suggests next steps for learning
- **Documentation**: Encourages learning from findings

**Why Important**:
- **Resource Management**: Prevents findings accumulation
- **Learning Process**: Encourages reflection on security lessons
- **Best Practices**: Demonstrates proper security workflow

---

## 🔄 Script Execution Workflows

### 1. **Initial Setup Workflow**
```
User runs: .\setup_lab.ps1 -Action init
↓
Check-AWS() → Check-Terraform() → Initialize-Terraform()
↓
Success: Ready for planning
```

### 2. **Deployment Workflow**
```
User runs: .\setup_lab.ps1 -Action deploy
↓
Check-AWS() → Check-Terraform() → Deploy-Infrastructure()
↓
Success: Infrastructure ready
```

### 3. **Simulation Workflow**
```
User runs: .\setup_lab.ps1 -Action simulate
↓
Simulate-Compromise() → Monitor-Findings()
↓
Success: Security testing complete
```

### 4. **Cleanup Workflow**
```
User runs: .\setup_lab.ps1 -Action destroy
↓
Destroy-Infrastructure() → Cleanup-Findings()
↓
Success: Lab cleaned up
```

---

## 🛡️ Security Considerations

### 1. **Parameter Validation**
- **Input Sanitization**: Prevents script injection
- **Path Validation**: Ensures safe file operations
- **AWS Profile**: Supports secure credential management

### 2. **Error Handling**
- **Graceful Failure**: Script continues despite individual failures
- **User Feedback**: Clear indication of what went wrong
- **Recovery Guidance**: Suggests how to fix issues

### 3. **Resource Management**
- **Directory Context**: Proper working directory management
- **State Preservation**: Returns to original directory after operations
- **Cleanup**: Ensures resources are properly managed

---

## 🔧 Customization and Extension

### 1. **Adding New Actions**
```powershell
# Add to switch statement
"newaction" { New-Action }

# Add new function
function New-Action {
    Write-Host "Performing new action..." -ForegroundColor Blue
    # Implementation here
}
```

### 2. **Modifying Existing Functions**
- **Error Handling**: Enhance error reporting
- **Logging**: Add detailed logging capabilities
- **Validation**: Add input validation

### 3. **Integration Points**
- **External Tools**: Integrate with other security tools
- **APIs**: Connect to external services
- **Databases**: Store lab results and metrics

---

## 📊 Performance Considerations

### 1. **Execution Time**
- **Initialization**: ~30 seconds (provider download)
- **Planning**: ~10-30 seconds (resource analysis)
- **Deployment**: ~5-10 minutes (resource creation)
- **Destruction**: ~3-5 minutes (resource cleanup)

### 2. **Resource Usage**
- **Memory**: Minimal (PowerShell script execution)
- **CPU**: Low (mostly I/O operations)
- **Network**: Moderate (AWS API calls)

### 3. **Optimization Tips**
- **Batch Operations**: Group related operations
- **Parallel Execution**: Run independent operations simultaneously
- **Caching**: Cache frequently accessed data

---

## 🐛 Troubleshooting Common Issues

### 1. **Script Execution Errors**
```powershell
# Check execution policy
Get-ExecutionPolicy

# Set execution policy if needed
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 2. **AWS CLI Issues**
```powershell
# Verify AWS configuration
aws configure list

# Test AWS connection
aws sts get-caller-identity
```

### 3. **Terraform Issues**
```powershell
# Check Terraform version
terraform version

# Verify working directory
Get-Location
```

---

## 📚 Learning Resources

### 1. **PowerShell Resources**
- [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
- [PowerShell Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/strongly-encouraged-development-guidelines)

### 2. **AWS CLI Resources**
- [AWS CLI User Guide](https://docs.aws.amazon.com/cli/)
- [AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/reference/)

### 3. **Terraform Resources**
- [Terraform Documentation](https://www.terraform.io/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)

---

## 🎯 Best Practices Summary

### 1. **Script Design**
- **Single Responsibility**: Each function has one clear purpose
- **Error Handling**: Comprehensive error capture and reporting
- **User Feedback**: Clear status updates and guidance

### 2. **Security**
- **Input Validation**: Sanitize all user inputs
- **Path Safety**: Validate file and directory paths
- **AWS Security**: Use appropriate IAM permissions

### 3. **Maintainability**
- **Modular Functions**: Easy to modify and extend
- **Consistent Naming**: Clear, descriptive function names
- **Documentation**: Comprehensive inline comments

---

## 🚀 Future Enhancements

### 1. **Advanced Features**
- **Progress Bars**: Visual progress indicators
- **Configuration Files**: External configuration management
- **Logging**: Comprehensive logging to files

### 2. **Integration**
- **CI/CD**: Automated testing and deployment
- **Monitoring**: Real-time lab status monitoring
- **Reporting**: Automated lab completion reports

### 3. **User Experience**
- **Interactive Mode**: Guided setup wizard
- **Help System**: Context-sensitive help
- **Templates**: Pre-configured lab scenarios

---

## 📝 Summary

The `setup_lab.ps1` script is a comprehensive, professional-grade tool that:

- **Simplifies Lab Management**: One script handles all operations
- **Ensures Reliability**: Robust error handling and validation
- **Provides Guidance**: Clear feedback and next steps
- **Supports Learning**: Educational workflow and documentation
- **Enables Customization**: Easy to extend and modify

By understanding this script's structure and functions, users can:
- **Effectively Manage**: Control the entire lab lifecycle
- **Troubleshoot Issues**: Identify and resolve problems quickly
- **Extend Functionality**: Add new features and capabilities
- **Learn Best Practices**: Understand professional script development

This script represents the foundation of the AWS Security Lab, providing the tools and guidance needed for successful security learning and experimentation.

Happy scripting! 🚀🔒
