# Setup Instructor Access - P2W12 Quantum Shield Lab
# PowerShell script to deploy IAM roles and generate access credentials

param(
    [string]$InstructorName = "Demo-Instructor",
    [int]$AccessHours = 2
)

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "P2W12 Quantum Shield - Instructor Access Setup" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Check if AWS CLI is installed
try {
    $awsVersion = aws --version 2>$null
    if ($awsVersion) {
        Write-Host "✅ AWS CLI found: $awsVersion" -ForegroundColor Green
    } else {
        Write-Host "❌ AWS CLI not found. Please install AWS CLI first." -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ AWS CLI not found. Please install AWS CLI first." -ForegroundColor Red
    exit 1
}

# Check if Terraform is installed
try {
    $terraformVersion = terraform --version 2>$null
    if ($terraformVersion) {
        Write-Host "✅ Terraform found: $terraformVersion" -ForegroundColor Green
    } else {
        Write-Host "❌ Terraform not found. Please install Terraform first." -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Terraform not found. Please install Terraform first." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🔧 Setting up instructor access for: $InstructorName" -ForegroundColor Yellow
Write-Host "⏰ Access duration: $AccessHours hours (demo session)" -ForegroundColor Yellow
Write-Host ""

# Navigate to terraform directory
Set-Location "terraform"

# Initialize Terraform if needed
if (-not (Test-Path ".terraform")) {
    Write-Host "🚀 Initializing Terraform..." -ForegroundColor Blue
    terraform init
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Terraform initialization failed" -ForegroundColor Red
        exit 1
    }
}

# Deploy instructor access resources
Write-Host "🚀 Deploying instructor access resources..." -ForegroundColor Blue
terraform apply -var="instructor_name=$InstructorName" -var="access_hours=$AccessHours" -auto-approve

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Deployment failed" -ForegroundColor Red
    exit 1
}

# Get outputs
Write-Host "📋 Retrieving access information..." -ForegroundColor Blue
$instructorInfo = terraform output -json instructor_access_info
$assumeRoleCommand = terraform output -raw instructor_assume_role_command

# Parse JSON output
$accessInfo = $instructorInfo | ConvertFrom-Json

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "✅ INSTRUCTOR ACCESS SETUP COMPLETE" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""

Write-Host "👤 Instructor: $InstructorName" -ForegroundColor White
Write-Host "🔑 IAM User: $($accessInfo.iam_user_name)" -ForegroundColor White
Write-Host "🎭 IAM Role: $($accessInfo.iam_role_name)" -ForegroundColor White
Write-Host "⏰ Expires: $($accessInfo.access_expires)" -ForegroundColor White
Write-Host "🌐 Console: $($accessInfo.console_url)" -ForegroundColor White

Write-Host ""
Write-Host "==========================================" -ForegroundColor Yellow
Write-Host "🔐 ACCESS CREDENTIALS" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Yellow
Write-Host ""

# Generate temporary password
$tempPassword = -join ((33..126) | Get-Random -Count 16 | ForEach-Object {[char]$_})
Write-Host "🔑 Username: $($accessInfo.iam_user_name)" -ForegroundColor Cyan
Write-Host "🔒 Temporary Password: $tempPassword" -ForegroundColor Cyan
Write-Host ""

Write-Host "==========================================" -ForegroundColor Yellow
Write-Host "📋 INSTRUCTOR ACCESS GUIDE" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Yellow
Write-Host ""

Write-Host "📖 Complete guide available in: INSTRUCTOR_ACCESS_GUIDE.md" -ForegroundColor White
Write-Host "🎯 Quick start:" -ForegroundColor White
Write-Host "   1. Go to: $($accessInfo.console_url)" -ForegroundColor White
Write-Host "   2. Login with credentials above" -ForegroundColor White
Write-Host "   3. Navigate to EC2, VPC, and CloudWatch dashboards" -ForegroundColor White
Write-Host ""

Write-Host "==========================================" -ForegroundColor Yellow
Write-Host "🔒 SECURITY NOTES" -ForegroundColor Yellow
Write-Host "==========================================" -ForegroundColor Yellow
Write-Host ""

Write-Host "⚠️  IMPORTANT SECURITY REMINDERS:" -ForegroundColor Red
Write-Host "   • Access expires automatically in $AccessHours hours (demo session)" -ForegroundColor White
Write-Host "   • Share credentials securely (not via email)" -ForegroundColor White
Write-Host "   • Monitor access logs for security" -ForegroundColor White
Write-Host "   • Revoke access immediately after demo" -ForegroundColor White
Write-Host ""

Write-Host "==========================================" -ForegroundColor Green
Write-Host "🎉 Setup Complete! Ready for Instructor Demo" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

# Save credentials to file (optional)
$credentialsFile = "instructor-credentials-$($accessInfo.iam_user_name).txt"
$credentialsContent = @"
P2W12 Quantum Shield - Instructor Access Credentials
==================================================
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss UTC")
Instructor: $InstructorName
Access Duration: $AccessHours hours

AWS CONSOLE ACCESS:
==================
Console URL: $($accessInfo.console_url)
Username: $($accessInfo.iam_user_name)
Temporary Password: $tempPassword
Expires: $($accessInfo.access_expires)

IAM ROLE ACCESS:
===============
Role ARN: $($accessInfo.iam_role_arn)
Assume Role Command: $assumeRoleCommand

SECURITY NOTES:
==============
- Access expires automatically
- Share credentials securely
- Monitor access logs
- Revoke access after demo

SUPPORT:
========
Lab Administrator: [Your Name]
Technical Lead: Fausto Rosado
Project Lead: Shannon Kelly
"@

$credentialsContent | Out-File -FilePath $credentialsFile -Encoding UTF8
Write-Host "💾 Credentials saved to: $credentialsFile" -ForegroundColor Green

# Return to original directory
Set-Location ".."

Write-Host ""
Write-Host "🎯 Next Steps:" -ForegroundColor Yellow
Write-Host "   1. Share credentials securely with instructor" -ForegroundColor White
Write-Host "   2. Provide INSTRUCTOR_ACCESS_GUIDE.md" -ForegroundColor White
Write-Host "   3. Monitor access during demo" -ForegroundColor White
Write-Host "   4. Revoke access after completion" -ForegroundColor White
