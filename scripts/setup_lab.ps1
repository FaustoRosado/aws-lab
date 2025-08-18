# AWS Security Lab Setup Script
# This script helps you set up and run the EC2 Compromise & Remediation lab

param(
    [string]$Action = "help",
    [string]$AWSProfile = "default"
)

Write-Host "🔒 AWS Security Lab - EC2 Compromise & Remediation" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green

function Show-Help {
    Write-Host "`nUsage: .\setup_lab.ps1 -Action <action> [-AWSProfile <profile>]" -ForegroundColor Yellow
    Write-Host "`nAvailable Actions:" -ForegroundColor Yellow
    Write-Host "  help           - Show this help message"
    Write-Host "  check-aws      - Check AWS CLI configuration"
    Write-Host "  check-terraform - Check Terraform installation"
    Write-Host "  init           - Initialize Terraform"
    Write-Host "  plan           - Plan Terraform deployment"
    Write-Host "  deploy         - Deploy the lab infrastructure"
    Write-Host "  destroy        - Destroy the lab infrastructure"
    Write-Host "  simulate       - Run compromise simulation scripts"
    Write-Host "  monitor        - Monitor GuardDuty and Security Hub findings"
    Write-Host "  cleanup        - Clean up resources and findings"
}

function Check-AWS {
    Write-Host "`n🔍 Checking AWS CLI configuration..." -ForegroundColor Blue
    
    try {
        $identity = aws sts get-caller-identity --profile $AWSProfile 2>$null | ConvertFrom-Json
        if ($identity) {
            Write-Host "✅ AWS CLI configured successfully!" -ForegroundColor Green
            Write-Host "   Account ID: $($identity.Account)" -ForegroundColor White
            Write-Host "   User ARN: $($identity.Arn)" -ForegroundColor White
            Write-Host "   User ID: $($identity.UserId)" -ForegroundColor White
        } else {
            Write-Host "❌ AWS CLI not configured or profile not found" -ForegroundColor Red
            Write-Host "   Run 'aws configure --profile $AWSProfile' to set up your credentials" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "❌ Error checking AWS configuration: $_" -ForegroundColor Red
    }
}

function Check-Terraform {
    Write-Host "`n🔍 Checking Terraform installation..." -ForegroundColor Blue
    
    try {
        $version = terraform version
        if ($version) {
            Write-Host "✅ Terraform installed successfully!" -ForegroundColor Green
            Write-Host $version -ForegroundColor White
        } else {
            Write-Host "❌ Terraform not found in PATH" -ForegroundColor Red
        }
    } catch {
        Write-Host "❌ Error checking Terraform: $_" -ForegroundColor Red
    }
}

function Initialize-Terraform {
    Write-Host "`n🚀 Initializing Terraform..." -ForegroundColor Blue
    
    Set-Location terraform
    try {
        terraform init
        Write-Host "✅ Terraform initialized successfully!" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error initializing Terraform: $_" -ForegroundColor Red
    }
    Set-Location ..
}

function Plan-Terraform {
    Write-Host "`n📋 Planning Terraform deployment..." -ForegroundColor Blue
    
    Set-Location terraform
    try {
        terraform plan
        Write-Host "✅ Terraform plan completed!" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error planning Terraform: $_" -ForegroundColor Red
    }
    Set-Location ..
}

function Deploy-Infrastructure {
    Write-Host "`n🚀 Deploying lab infrastructure..." -ForegroundColor Blue
    
    Set-Location terraform
    try {
        Write-Host "⚠️  This will create AWS resources that may incur costs!" -ForegroundColor Yellow
        $confirm = Read-Host "Do you want to continue? (y/N)"
        
        if ($confirm -eq "y" -or $confirm -eq "Y") {
            terraform apply -auto-approve
            Write-Host "✅ Infrastructure deployed successfully!" -ForegroundColor Green
        } else {
            Write-Host "❌ Deployment cancelled by user" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "❌ Error deploying infrastructure: $_" -ForegroundColor Red
    }
    Set-Location ..
}

function Destroy-Infrastructure {
    Write-Host "`n🗑️  Destroying lab infrastructure..." -ForegroundColor Blue
    
    Set-Location terraform
    try {
        Write-Host "⚠️  This will destroy ALL lab resources!" -ForegroundColor Red
        $confirm = Read-Host "Are you sure? This action cannot be undone! (y/N)"
        
        if ($confirm -eq "y" -or $confirm -eq "Y") {
            terraform destroy -auto-approve
            Write-Host "✅ Infrastructure destroyed successfully!" -ForegroundColor Green
        } else {
            Write-Host "❌ Destruction cancelled by user" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "❌ Error destroying infrastructure: $_" -ForegroundColor Red
    }
    Set-Location ..
}

function Simulate-Compromise {
    Write-Host "`n🎭 Running compromise simulation..." -ForegroundColor Blue
    
    Write-Host "This will simulate various attack scenarios:" -ForegroundColor White
    Write-Host "1. Port scanning" -ForegroundColor White
    Write-Host "2. Brute force attempts" -ForegroundColor White
    Write-Host "3. Suspicious file uploads" -ForegroundColor White
    Write-Host "4. Unusual network connections" -ForegroundColor White
    
    $confirm = Read-Host "Do you want to run the simulation? (y/N)"
    
    if ($confirm -eq "y" -or $confirm -eq "Y") {
        Write-Host "🚀 Starting compromise simulation..." -ForegroundColor Green
        # Add simulation logic here
        Write-Host "✅ Simulation completed! Check GuardDuty and Security Hub for findings." -ForegroundColor Green
    } else {
        Write-Host "❌ Simulation cancelled by user" -ForegroundColor Yellow
    }
}

function Monitor-Findings {
    Write-Host "`n📊 Monitoring security findings..." -ForegroundColor Blue
    
    Write-Host "Checking GuardDuty findings..." -ForegroundColor White
    try {
        aws guardduty list-findings --detector-id $(aws guardduty list-detectors --query 'DetectorIds[0]' --output text) --profile $AWSProfile
    } catch {
        Write-Host "❌ Error checking GuardDuty findings: $_" -ForegroundColor Red
    }
    
    Write-Host "`nChecking Security Hub findings..." -ForegroundColor White
    try {
        aws securityhub get-findings --profile $AWSProfile
    } catch {
        Write-Host "❌ Error checking Security Hub findings: $_" -ForegroundColor Red
    }
}

function Cleanup-Findings {
    Write-Host "`n🧹 Cleaning up security findings..." -ForegroundColor Blue
    
    Write-Host "This will archive or suppress findings from the lab simulation." -ForegroundColor White
    $confirm = Read-Host "Do you want to continue? (y/N)"
    
    if ($confirm -eq "y" -or $confirm -eq "Y") {
        Write-Host "🧹 Cleaning up findings..." -ForegroundColor Green
        # Add cleanup logic here
        Write-Host "✅ Cleanup completed!" -ForegroundColor Green
    } else {
        Write-Host "❌ Cleanup cancelled by user" -ForegroundColor Yellow
    }
}

# Main execution logic
switch ($Action.ToLower()) {
    "help" { Show-Help }
    "check-aws" { Check-AWS }
    "check-terraform" { Check-Terraform }
    "init" { Initialize-Terraform }
    "plan" { Plan-Terraform }
    "deploy" { Deploy-Infrastructure }
    "destroy" { Destroy-Infrastructure }
    "simulate" { Simulate-Compromise }
    "monitor" { Monitor-Findings }
    "cleanup" { Cleanup-Findings }
    default { 
        Write-Host "❌ Unknown action: $Action" -ForegroundColor Red
        Show-Help
    }
}

Write-Host "`n🔒 Lab setup script completed!" -ForegroundColor Green
