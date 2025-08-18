# 🔐 AWS Security Lab - Credentials Setup Script
# This script helps you set up AWS credentials securely

param(
    [string]$Action = "help",
    [string]$Environment = "development"
)

Write-Host "🔐 AWS Security Lab - Credentials Setup" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green

function Show-Help {
    Write-Host ""
    Write-Host "Usage: .\setup_credentials.ps1 [Action] [Environment]" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Actions:" -ForegroundColor Cyan
    Write-Host "  setup     - Set up AWS credentials interactively" -ForegroundColor White
    Write-Host "  check     - Check if credentials are configured" -ForegroundColor White
    Write-Host "  validate  - Validate AWS credentials" -ForegroundColor White
    Write-Host "  help      - Show this help message" -ForegroundColor White
    Write-Host ""
    Write-Host "Environments:" -ForegroundColor Cyan
    Write-Host "  development - Development environment (default)" -ForegroundColor White
    Write-Host "  production  - Production environment" -ForegroundColor White
    Write-Host "  staging     - Staging environment" -ForegroundColor White
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Cyan
    Write-Host "  .\setup_credentials.ps1 setup" -ForegroundColor White
    Write-Host "  .\setup_credentials.ps1 check production" -ForegroundColor White
    Write-Host "  .\setup_credentials.ps1 validate" -ForegroundColor White
}

function Setup-Credentials {
    Write-Host ""
    Write-Host "🔑 Setting up AWS credentials for $Environment environment..." -ForegroundColor Yellow
    Write-Host ""
    
    # Check if template exists
    if (-not (Test-Path "env.template")) {
        Write-Host "❌ Template file 'env.template' not found!" -ForegroundColor Red
        Write-Host "Please ensure you're running this script from the project root directory." -ForegroundColor Yellow
        return
    }
    
    # Create environment file
    $envFile = ".env.$Environment"
    $envFileLocal = ".env.local"
    
    Write-Host "📝 Creating $envFileLocal from template..." -ForegroundColor Cyan
    
    try {
        Copy-Item "env.template" $envFileLocal -Force
        Write-Host "✅ Template copied successfully!" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to copy template: $($_.Exception.Message)" -ForegroundColor Red
        return
    }
    
    Write-Host ""
    Write-Host "🚨 IMPORTANT: You need to manually edit $envFileLocal with your real AWS credentials!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Steps:" -ForegroundColor Yellow
    Write-Host "1. Open $envFileLocal in your text editor" -ForegroundColor White
    Write-Host "2. Replace 'YOUR_ACCESS_KEY_ID_HERE' with your actual AWS Access Key ID" -ForegroundColor White
    Write-Host "3. Replace 'YOUR_SECRET_ACCESS_KEY_HERE' with your actual AWS Secret Access Key" -ForegroundColor White
    Write-Host "4. Update other values as needed" -ForegroundColor White
    Write-Host "5. Save the file" -ForegroundColor White
    Write-Host ""
    Write-Host "⚠️  NEVER commit $envFileLocal to git - it's already in .gitignore" -ForegroundColor Yellow
    Write-Host ""
    
    # Offer to open the file
    $openFile = Read-Host "Would you like to open $envFileLocal now? (y/n)"
    if ($openFile -eq "y" -or $openFile -eq "Y") {
        try {
            Start-Process notepad $envFileLocal
            Write-Host "✅ File opened in Notepad" -ForegroundColor Green
        } catch {
            Write-Host "⚠️  Could not open file automatically. Please open it manually." -ForegroundColor Yellow
        }
    }
    
    Write-Host ""
    Write-Host "🎯 After editing your credentials, run:" -ForegroundColor Cyan
    Write-Host "  .\setup_credentials.ps1 validate" -ForegroundColor White
    Write-Host ""
}

function Check-Credentials {
    Write-Host ""
    Write-Host "🔍 Checking AWS credentials configuration..." -ForegroundColor Yellow
    Write-Host ""
    
    # Check for environment files
    $envFiles = @(".env.local", ".env.development", ".env.production", ".env.staging")
    $foundFiles = @()
    
    foreach ($file in $envFiles) {
        if (Test-Path $file) {
            $foundFiles += $file
        }
    }
    
    if ($foundFiles.Count -eq 0) {
        Write-Host "❌ No environment files found!" -ForegroundColor Red
        Write-Host "Run '.\setup_credentials.ps1 setup' to create your credentials file." -ForegroundColor Yellow
        return
    }
    
    Write-Host "📁 Found environment files:" -ForegroundColor Green
    foreach ($file in $foundFiles) {
        Write-Host "  ✅ $file" -ForegroundColor Green
    }
    
    Write-Host ""
    
    # Check AWS CLI configuration
    Write-Host "🔧 Checking AWS CLI configuration..." -ForegroundColor Cyan
    
    $awsConfigPath = "$env:USERPROFILE\.aws\config"
    $awsCredentialsPath = "$env:USERPROFILE\.aws\credentials"
    
    if (Test-Path $awsConfigPath) {
        Write-Host "  ✅ AWS config found: $awsConfigPath" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  AWS config not found: $awsConfigPath" -ForegroundColor Yellow
    }
    
    if (Test-Path $awsCredentialsPath) {
        Write-Host "  ✅ AWS credentials found: $awsCredentialsPath" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  AWS credentials not found: $awsCredentialsPath" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "💡 Tip: You can use either environment files or AWS CLI configuration." -ForegroundColor Cyan
    Write-Host "   Environment files are easier for lab purposes." -ForegroundColor White
}

function Validate-Credentials {
    Write-Host ""
    Write-Host "🔍 Validating AWS credentials..." -ForegroundColor Yellow
    Write-Host ""
    
    # Check if AWS CLI is installed
    try {
        $awsVersion = aws --version 2>$null
        if ($awsVersion) {
            Write-Host "✅ AWS CLI found: $awsVersion" -ForegroundColor Green
        } else {
            Write-Host "❌ AWS CLI not found or not working!" -ForegroundColor Red
            Write-Host "Please install AWS CLI first." -ForegroundColor Yellow
            return
        }
    } catch {
        Write-Host "❌ AWS CLI not found or not working!" -ForegroundColor Red
        Write-Host "Please install AWS CLI first." -ForegroundColor Yellow
        return
    }
    
    # Try to get caller identity
    Write-Host "🔐 Testing AWS credentials..." -ForegroundColor Cyan
    
    try {
        $callerIdentity = aws sts get-caller-identity 2>$null | ConvertFrom-Json
        
        if ($callerIdentity) {
            Write-Host "✅ AWS credentials are valid!" -ForegroundColor Green
            Write-Host ""
            Write-Host "Account Information:" -ForegroundColor Cyan
            Write-Host "  Account ID: $($callerIdentity.Account)" -ForegroundColor White
            Write-Host "  User ID: $($callerIdentity.UserId)" -ForegroundColor White
            Write-Host "  ARN: $($callerIdentity.Arn)" -ForegroundColor White
            Write-Host ""
            Write-Host "🎉 You're ready to use the AWS Security Lab!" -ForegroundColor Green
        } else {
            Write-Host "❌ Failed to get caller identity" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ AWS credentials validation failed!" -ForegroundColor Red
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host ""
        Write-Host "🔧 Troubleshooting:" -ForegroundColor Yellow
        Write-Host "1. Check if your credentials are correct" -ForegroundColor White
        Write-Host "2. Verify your AWS account is active" -ForegroundColor White
        Write-Host "3. Check if your IAM user has the necessary permissions" -ForegroundColor White
        Write-Host "4. Ensure your access keys haven't expired" -ForegroundColor White
        Write-Host ""
        Write-Host "💡 Run '.\setup_credentials.ps1 setup' to reconfigure your credentials." -ForegroundColor Cyan
    }
}

function Show-Security-Warning {
    Write-Host ""
    Write-Host "🚨 SECURITY WARNING" -ForegroundColor Red
    Write-Host "==================" -ForegroundColor Red
    Write-Host ""
    Write-Host "⚠️  NEVER share your AWS credentials with anyone!" -ForegroundColor Yellow
    Write-Host "⚠️  NEVER commit credentials to GitHub!" -ForegroundColor Yellow
    Write-Host "⚠️  NEVER use the same credentials across multiple accounts!" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "🔒 Security Best Practices:" -ForegroundColor Cyan
    Write-Host "  • Use IAM users with minimal required permissions" -ForegroundColor White
    Write-Host "  • Rotate your access keys every 90 days" -ForegroundColor White
    Write-Host "  • Enable MFA on your AWS account" -ForegroundColor White
    Write-Host "  • Monitor your AWS usage regularly" -ForegroundColor White
    Write-Host "  • Use CloudTrail to audit API calls" -ForegroundColor White
    Write-Host ""
}

# Main script logic
switch ($Action.ToLower()) {
    "setup" {
        Show-Security-Warning
        Setup-Credentials
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
        Write-Host "❌ Unknown action: $Action" -ForegroundColor Red
        Write-Host ""
        Show-Help
    }
}

Write-Host ""
Write-Host "🔐 For more security information, see: docs/SECURITY_AND_CREDENTIALS.md" -ForegroundColor Cyan
Write-Host "📚 For complete setup guide, see: docs/SETUP_GUIDE.md" -ForegroundColor Cyan
