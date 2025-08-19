# AWS Security Lab - EC2 Compromise & Remediation
# Main lab setup and management script

param(
    [string]$Action = "help"
)

# Function to display help
function Show-Help {
    Write-Host "AWS Security Lab - EC2 Compromise & Remediation" -ForegroundColor Green
    Write-Host "=================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Usage: .\setup_lab.ps1 [Action]"
    Write-Host ""
    Write-Host "Actions:"
    Write-Host "  check-aws      - Check AWS CLI configuration"
    Write-Host "  check-terraform - Check Terraform installation"
    Write-Host "  init           - Initialize Terraform"
    Write-Host "  plan           - Plan Terraform deployment"
    Write-Host "  deploy         - Deploy lab infrastructure"
    Write-Host "  destroy        - Destroy lab infrastructure"
    Write-Host "  simulate       - Run compromise simulation"
    Write-Host "  monitor        - Monitor security findings"
    Write-Host "  cleanup        - Clean up security findings"
    Write-Host "  help           - Show this help message"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\setup_lab.ps1 check-aws"
    Write-Host "  .\setup_lab.ps1 deploy"
    Write-Host "  .\setup_lab.ps1 simulate"
}

# Function to check AWS CLI configuration
function Check-AWS {
    Write-Host "Checking AWS CLI configuration..." -ForegroundColor Blue
    
    try {
        $callerIdentity = aws sts get-caller-identity 2>$null | ConvertFrom-Json
        
        if ($callerIdentity) {
            Write-Host "AWS CLI configured successfully!" -ForegroundColor Green
            Write-Host "  Account ID: $($callerIdentity.Account)" -ForegroundColor White
            Write-Host "  User ID: $($callerIdentity.UserId)" -ForegroundColor White
            Write-Host "  ARN: $($callerIdentity.Arn)" -ForegroundColor White
        } else {
            Write-Host "AWS CLI not configured or profile not found" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "Error checking AWS configuration: $_" -ForegroundColor Red
    }
}

# Function to check Terraform installation
function Check-Terraform {
    Write-Host "Checking Terraform installation..." -ForegroundColor Blue
    
    try {
        $terraformVersion = terraform version 2>$null
        if ($terraformVersion) {
            Write-Host "Terraform installed successfully!" -ForegroundColor Green
            Write-Host "  Version: $($terraformVersion[0])" -ForegroundColor White
        } else {
            Write-Host "Terraform not found in PATH" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "Error checking Terraform: $_" -ForegroundColor Red
    }
}

# Function to initialize Terraform
function Initialize-Terraform {
    Write-Host "Initializing Terraform..." -ForegroundColor Blue
    
    try {
        Set-Location terraform
        terraform init
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Terraform initialized successfully!" -ForegroundColor Green
        } else {
            Write-Host "Error initializing Terraform" -ForegroundColor Red
        }
        Set-Location ..
    }
    catch {
        Write-Host "Error initializing Terraform: $_" -ForegroundColor Red
    }
}

# Function to plan Terraform deployment
function Plan-Terraform {
    Write-Host "Planning Terraform deployment..." -ForegroundColor Blue
    
    try {
        Set-Location terraform
        terraform plan
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Terraform plan completed!" -ForegroundColor Green
        } else {
            Write-Host "Error planning Terraform deployment" -ForegroundColor Red
        }
        Set-Location ..
    }
    catch {
        Write-Host "Error planning Terraform deployment: $_" -ForegroundColor Red
    }
}

# Function to deploy infrastructure
function Deploy-Infrastructure {
    Write-Host "Deploying lab infrastructure..." -ForegroundColor Blue
    
    $confirm = Read-Host "This will create AWS resources that may incur costs. Continue? (y/n)"
    if ($confirm -eq "y" -or $confirm -eq "Y") {
        try {
            Set-Location terraform
            terraform apply -auto-approve
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Infrastructure deployed successfully!" -ForegroundColor Green
            } else {
                Write-Host "Error deploying infrastructure" -ForegroundColor Red
            }
            Set-Location ..
        }
        catch {
            Write-Host "Error deploying infrastructure: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Deployment cancelled by user" -ForegroundColor Yellow
    }
}

# Function to destroy infrastructure
function Destroy-Infrastructure {
    Write-Host "Destroying lab infrastructure..." -ForegroundColor Blue
    
    $confirm = Read-Host "This will destroy ALL lab resources. Continue? (y/n)"
    if ($confirm -eq "y" -or $confirm -eq "Y") {
        try {
            Set-Location terraform
            terraform destroy -auto-approve
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Infrastructure destroyed successfully!" -ForegroundColor Green
            } else {
                Write-Host "Error destroying infrastructure" -ForegroundColor Red
            }
            Set-Location ..
        }
        catch {
            Write-Host "Error destroying infrastructure: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Destruction cancelled by user" -ForegroundColor Yellow
    }
}

# Function to run compromise simulation
function Run-Simulation {
    Write-Host "Running compromise simulation..." -ForegroundColor Blue
    
    try {
        $webServerIP = terraform output -raw web_server_public_ip 2>$null
        if ($webServerIP) {
            Write-Host "Starting compromise simulation..." -ForegroundColor Green
            .\scripts\simulate_compromise.ps1 -WebServerIP $webServerIP
            Write-Host "Simulation completed! Check GuardDuty and Security Hub for findings." -ForegroundColor Green
        } else {
            Write-Host "Web server IP not found. Deploy infrastructure first." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Error running simulation: $_" -ForegroundColor Red
    }
}

# Function to monitor security findings
function Monitor-Findings {
    Write-Host "Monitoring security findings..." -ForegroundColor Blue
    
    try {
        # Check GuardDuty findings
        $guarddutyFindings = aws guardduty list-findings --detector-id $(terraform output -raw guardduty_detector_id) 2>$null
        if ($guarddutyFindings) {
            Write-Host "GuardDuty findings found." -ForegroundColor Green
        } else {
            Write-Host "No GuardDuty findings detected yet." -ForegroundColor Yellow
        }
        
        # Check Security Hub findings
        $securityHubFindings = aws securityhub get-findings 2>$null
        if ($securityHubFindings) {
            Write-Host "Security Hub findings found." -ForegroundColor Green
        } else {
            Write-Host "No Security Hub findings detected yet." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Error checking security findings: $_" -ForegroundColor Red
    }
}

# Function to clean up security findings
function Cleanup-Findings {
    Write-Host "Cleaning up security findings..." -ForegroundColor Blue
    
    try {
        # Archive findings to S3
        $bucketName = terraform output -raw s3_bucket_name 2>$null
        if ($bucketName) {
            Write-Host "Archiving findings to S3 bucket: $bucketName" -ForegroundColor Green
            # Add cleanup logic here
        } else {
            Write-Host "S3 bucket not found." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "Error cleaning up findings: $_" -ForegroundColor Red
    }
}

# Main script logic
switch ($Action.ToLower()) {
    "check-aws" {
        Check-AWS
    }
    "check-terraform" {
        Check-Terraform
    }
    "init" {
        Initialize-Terraform
    }
    "plan" {
        Plan-Terraform
    }
    "deploy" {
        Deploy-Infrastructure
    }
    "destroy" {
        Destroy-Infrastructure
    }
    "simulate" {
        Run-Simulation
    }
    "monitor" {
        Monitor-Findings
    }
    "cleanup" {
        Cleanup-Findings
    }
    "help" {
        Show-Help
    }
    default {
        Write-Host "Unknown action: $Action" -ForegroundColor Red
        Write-Host "Use '.\setup_lab.ps1 help' for usage information." -ForegroundColor Yellow
    }
}
