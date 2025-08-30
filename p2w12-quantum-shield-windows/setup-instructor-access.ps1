# setup-instructor-access.ps1
# Advanced Cyber Range - Instructor Access Setup (Windows PowerShell Optimized)

param(
    [string]$Region = "us-east-1"
)

# Set error action preference
$ErrorActionPreference = "Stop"

Write-Host "Advanced Cyber Range - Instructor Access Setup (Windows PowerShell)" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Warning "Consider running PowerShell as Administrator for best results"
}

# Check if Chocolatey is available (Windows package manager)
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "Chocolatey package manager detected" -ForegroundColor Yellow
} else {
    Write-Host "Chocolatey not found. Consider installing from https://chocolatey.org/" -ForegroundColor Yellow
    Write-Host "This will ensure all required tools are available." -ForegroundColor Yellow
}

# Check if Terraform is available
try {
    $terraformVersion = terraform version
    Write-Host "Terraform found: $($terraformVersion[0])" -ForegroundColor Green
} catch {
    Write-Error "Terraform is not installed or not in PATH"
    Write-Host "Install with: choco install terraform" -ForegroundColor Yellow
    Write-Host "Or download from: https://terraform.io/downloads.html" -ForegroundColor Yellow
    exit 1
}

# Check if AWS CLI is available
try {
    $awsVersion = aws --version
    Write-Host "AWS CLI found: $awsVersion" -ForegroundColor Green
} catch {
    Write-Error "AWS CLI is not installed or not in PATH"
    Write-Host "Install with: choco install awscli" -ForegroundColor Yellow
    Write-Host "Or download from: https://aws.amazon.com/cli/" -ForegroundColor Yellow
    exit 1
}

# Check if jq is available
try {
    $jqVersion = jq --version
    Write-Host "jq found: $jqVersion" -ForegroundColor Green
} catch {
    Write-Error "jq is not installed. Installing with Chocolatey..."
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        choco install jq -y
        RefreshEnvironment
    } else {
        Write-Error "Please install jq manually or install Chocolatey first"
        Write-Host "Download from: https://jqlang.github.io/jq/download/" -ForegroundColor Yellow
        exit 1
    }
}

# Navigate to terraform directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$terraformDir = Join-Path $scriptDir "terraform"

if (-not (Test-Path $terraformDir)) {
    Write-Error "Could not find terraform directory at: $terraformDir"
    exit 1
}

Set-Location $terraformDir
Write-Host "Changed to directory: $(Get-Location)" -ForegroundColor Yellow

# Check if terraform is initialized
if (-not (Test-Path ".terraform")) {
    Write-Error "Terraform not initialized. Please run 'terraform init' first."
    exit 1
}

# Get the role ARN from Terraform output
Write-Host "Retrieving instructor role ARN..." -ForegroundColor Yellow
try {
    $roleArn = terraform output -raw instructor_role_arn
    Write-Host "Role ARN: $roleArn" -ForegroundColor Green
} catch {
    Write-Error "Could not retrieve instructor_role_arn from Terraform output"
    Write-Host "Please ensure the infrastructure is deployed and the role exists." -ForegroundColor Yellow
    exit 1
}

# Create .aws directory if it doesn't exist (Windows standard location)
$awsDir = Join-Path $env:USERPROFILE ".aws"
if (-not (Test-Path $awsDir)) {
    New-Item -ItemType Directory -Path $awsDir -Force | Out-Null
    Write-Host "Created AWS directory: $awsDir" -ForegroundColor Yellow
}

# Assume the role and get temporary credentials
Write-Host "Requesting temporary credentials..." -ForegroundColor Yellow
$credsFile = Join-Path $awsDir "instructor-creds.json"

$sessionName = "InstructorDemo-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
aws sts assume-role --role-arn $roleArn --role-session-name $sessionName --duration-seconds 86400 --output json | Out-File -FilePath $credsFile -Encoding UTF8

# Extract credentials using PowerShell
$credsJson = Get-Content $credsFile | ConvertFrom-Json
$env:AWS_ACCESS_KEY_ID = $credsJson.Credentials.AccessKeyId
$env:AWS_SECRET_ACCESS_KEY = $credsJson.Credentials.SecretAccessKey
$env:AWS_SESSION_TOKEN = $credsJson.Credentials.SessionToken

# Store in AWS CLI profile
Write-Host "Configuring AWS CLI profile..." -ForegroundColor Yellow
aws configure set aws_access_key_id $env:AWS_ACCESS_KEY_ID --profile instructor-temp
aws configure set aws_secret_access_key $env:AWS_SECRET_ACCESS_KEY --profile instructor-temp
aws configure set aws_session_token $env:AWS_SESSION_TOKEN --profile instructor-temp

# Set expiration time (24 hours from now) - Windows PowerShell date command
$expiration = (Get-Date).AddHours(24).ToString("yyyy-MM-ddTHH:mm:ssZ")
aws configure set expiration $expiration --profile instructor-temp

# Set region
aws configure set region $Region --profile instructor-temp

Write-Host ""
Write-Host "Temporary credentials configured successfully!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host "Profile: instructor-temp" -ForegroundColor White
Write-Host "Region: $Region" -ForegroundColor White
Write-Host "Expires: $expiration" -ForegroundColor White
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Use AWS CLI with profile: aws ec2 describe-instances --profile instructor-temp" -ForegroundColor White
Write-Host "2. Access AWS Console with credentials from $credsFile" -ForegroundColor White
Write-Host "3. Credentials will automatically expire in 24 hours" -ForegroundColor White
Write-Host ""
Write-Host "To check available profiles: aws configure list-profiles" -ForegroundColor White
Write-Host "To view credentials: Get-Content $credsFile" -ForegroundColor White
Write-Host ""
Write-Host "Windows-specific Notes:" -ForegroundColor Yellow
Write-Host "- Credentials stored in $awsDir (standard Windows location)" -ForegroundColor White
Write-Host "- Use PowerShell or Windows Terminal for best experience" -ForegroundColor White
Write-Host "- Consider adding to your PowerShell profile: `$env:AWS_PROFILE='instructor-temp'" -ForegroundColor White
Write-Host "- Run this script with: .\setup-instructor-access.ps1" -ForegroundColor White
