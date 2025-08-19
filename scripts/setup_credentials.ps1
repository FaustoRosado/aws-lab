# AWS Security Lab - Credentials Setup Script
# This script helps you set up AWS credentials securely for the lab

param(
    [string]$Action = "help",
    [string]$Environment = "lab"
)

# Function to display help
function Show-Help {
    Write-Host "AWS Security Lab - Credentials Setup" -ForegroundColor Green
    Write-Host ""
    Write-Host "Usage: .\setup_credentials.ps1 [Action] [Environment]"
    Write-Host ""
    Write-Host "Actions:"
    Write-Host "  setup     - Set up credentials for the specified environment"
    Write-Host "  check     - Check current credential configuration"
    Write-Host "  validate  - Validate AWS credentials"
    Write-Host "  help      - Show this help message"
    Write-Host ""
    Write-Host "Environments:"
    Write-Host "  lab       - Lab environment (default)"
    Write-Host "  dev       - Development environment"
    Write-Host "  test      - Testing environment"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\setup_credentials.ps1 setup lab"
    Write-Host "  .\setup_credentials.ps1 check"
    Write-Host "  .\setup_credentials.ps1 validate"
}

# Function to set up credentials
function Setup-Credentials {
    param([string]$Environment)
    
    Write-Host "Setting up AWS credentials for $Environment environment..." -ForegroundColor Yellow
    
    # Check if template exists
    $templateFile = "env.template"
    if (-not (Test-Path $templateFile)) {
        Write-Host "Template file 'env.template' not found!" -ForegroundColor Red
        Write-Host "Please ensure you're running this script from the project root directory." -ForegroundColor Yellow
        return
    }
    
    # Create environment-specific file
    $envFileLocal = ".env.$Environment"
    
    try {
        Write-Host "Creating $envFileLocal from template..." -ForegroundColor Cyan
        Copy-Item $templateFile $envFileLocal
        Write-Host "Template copied successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to copy template: $($_.Exception.Message)" -ForegroundColor Red
        return
    }
    
    # Open file for editing
    Write-Host "IMPORTANT: You need to manually edit $envFileLocal with your real AWS credentials!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Steps:"
    Write-Host "1. Replace 'your_access_key_id_here' with your actual AWS Access Key ID"
    Write-Host "2. Replace 'your_secret_access_key_here' with your actual AWS Secret Access Key"
    Write-Host "3. Update other settings as needed"
    Write-Host "4. Save the file"
    Write-Host ""
    
    # Try to open file in default editor
    try {
        Write-Host "Opening $envFileLocal in Notepad..." -ForegroundColor Cyan
        Start-Process notepad $envFileLocal
        Write-Host "File opened in Notepad" -ForegroundColor Green
    }
    catch {
        Write-Host "Could not open file automatically. Please open it manually." -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "After editing your credentials, run:" -ForegroundColor Cyan
    Write-Host "  .\setup_credentials.ps1 check" -ForegroundColor White
    Write-Host "  .\setup_credentials.ps1 validate" -ForegroundColor White
}

# Function to check credential configuration
function Check-Credentials {
    Write-Host "Checking AWS credentials configuration..." -ForegroundColor Yellow
    
    # Check for environment files
    $envFiles = Get-ChildItem -Name ".env*" | Where-Object { $_ -ne "env.template" }
    
    if ($envFiles.Count -eq 0) {
        Write-Host "No environment files found!" -ForegroundColor Red
        Write-Host "Run '.\setup_credentials.ps1 setup' to create your credential file." -ForegroundColor Yellow
        return
    }
    
    Write-Host "Environment files found:" -ForegroundColor Green
    foreach ($file in $envFiles) {
        Write-Host "  $file" -ForegroundColor Green
    }
    
    # Check AWS CLI configuration
    Write-Host "Checking AWS CLI configuration..." -ForegroundColor Cyan
    
    $awsConfigPath = "$env:USERPROFILE\.aws\config"
    $awsCredentialsPath = "$env:USERPROFILE\.aws\credentials"
    
    if (Test-Path $awsConfigPath) {
        Write-Host "  AWS config found: $awsConfigPath" -ForegroundColor Green
    } else {
        Write-Host "  AWS config not found: $awsConfigPath" -ForegroundColor Yellow
    }
    
    if (Test-Path $awsCredentialsPath) {
        Write-Host "  AWS credentials found: $awsCredentialsPath" -ForegroundColor Green
    } else {
        Write-Host "  AWS credentials not found: $awsCredentialsPath" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "Tip: You can use either environment files or AWS CLI configuration." -ForegroundColor Cyan
}

# Function to validate AWS credentials
function Validate-Credentials {
    Write-Host "Validating AWS credentials..." -ForegroundColor Yellow
    
    # Check if AWS CLI is installed
    try {
        $awsVersion = aws --version 2>$null
        if ($awsVersion) {
            Write-Host "AWS CLI found: $awsVersion" -ForegroundColor Green
        } else {
            Write-Host "AWS CLI not found or not working!" -ForegroundColor Red
            return
        }
    }
    catch {
        Write-Host "AWS CLI not found or not working!" -ForegroundColor Red
        return
    }
    
    # Test AWS credentials
    Write-Host "Testing AWS credentials..." -ForegroundColor Cyan
    
    try {
        $callerIdentity = aws sts get-caller-identity 2>$null | ConvertFrom-Json
        
        if ($callerIdentity) {
            Write-Host "AWS credentials are valid!" -ForegroundColor Green
            Write-Host "  Account ID: $($callerIdentity.Account)" -ForegroundColor White
            Write-Host "  User ID: $($callerIdentity.UserId)" -ForegroundColor White
            Write-Host "  ARN: $($callerIdentity.Arn)" -ForegroundColor White
        } else {
            throw "No response from AWS"
        }
    }
    catch {
        Write-Host "Failed to get caller identity" -ForegroundColor Red
        Write-Host "AWS credentials validation failed!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Troubleshooting:" -ForegroundColor Yellow
        Write-Host "1. Check your AWS credentials are correct" -ForegroundColor White
        Write-Host "2. Verify your AWS account has the required permissions" -ForegroundColor White
        Write-Host "3. Check your internet connection" -ForegroundColor White
        Write-Host "4. Verify your AWS region setting" -ForegroundColor White
        Write-Host ""
        Write-Host "Run '.\setup_credentials.ps1 setup' to reconfigure your credentials." -ForegroundColor Cyan
    }
}

# Function to show security warning
function Show-SecurityWarning {
    Write-Host "SECURITY WARNING" -ForegroundColor Red
    Write-Host "=================" -ForegroundColor Red
    Write-Host ""
    Write-Host "NEVER share your AWS credentials with anyone!" -ForegroundColor Yellow
    Write-Host "NEVER commit credentials to GitHub!" -ForegroundColor Yellow
    Write-Host "NEVER use the same credentials across multiple accounts!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Security Best Practices:" -ForegroundColor Cyan
    Write-Host "1. Use IAM users with minimal required permissions" -ForegroundColor White
    Write-Host "2. Rotate your access keys every 90 days" -ForegroundColor White
    Write-Host "3. Enable MFA on your AWS account" -ForegroundColor White
    Write-Host "4. Monitor your AWS usage regularly" -ForegroundColor White
    Write-Host "5. Use environment variables or AWS CLI configuration" -ForegroundColor White
    Write-Host "6. Never hardcode credentials in scripts" -ForegroundColor White
    Write-Host "7. Use IAM roles when possible" -ForegroundColor White
    Write-Host "8. Regularly review and audit permissions" -ForegroundColor White
}

# Main script logic
switch ($Action.ToLower()) {
    "setup" {
        Setup-Credentials -Environment $Environment
        Show-SecurityWarning
    }
    "check" {
        Check-Credentials
    }
    "validate" {
        Validate-Credentials
    }
    "help" {
        Show-Help
    }
    default {
        Write-Host "Unknown action: $Action" -ForegroundColor Red
        Write-Host "Use '.\setup_credentials.ps1 help' for usage information." -ForegroundColor Yellow
    }
}

# Show additional resources
Write-Host ""
Write-Host "For more security information, see: docs/SECURITY_AND_CREDENTIALS.md" -ForegroundColor Cyan
Write-Host "For complete setup guide, see: docs/SETUP_GUIDE.md" -ForegroundColor Cyan
