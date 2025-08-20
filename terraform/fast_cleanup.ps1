# Fast Cleanup Script for AWS Security Lab
# Use this if terraform destroy gets stuck or takes too long
# Designed for cybersecurity professionals who need speed!

Write-Host "🚀 FAST CLEANUP: AWS Security Lab" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

# Check if AWS CLI is configured
try {
    $caller = aws sts get-caller-identity --query 'Account' --output text 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ AWS CLI not configured. Run 'aws configure' first." -ForegroundColor Red
        exit 1
    }
    Write-Host "✅ AWS Account: $caller" -ForegroundColor Green
} catch {
    Write-Host "❌ AWS CLI not configured. Run 'aws configure' first." -ForegroundColor Red
    exit 1
}

Write-Host "`n🔍 Finding lab resources..." -ForegroundColor Yellow

# Find and terminate EC2 instances
Write-Host "`n🖥️  Terminating EC2 instances..." -ForegroundColor Cyan
$instances = aws ec2 describe-instances --filters "Name=tag:Project,Values=EC2-Compromise-Lab" --query 'Reservations[*].Instances[*].[InstanceId,State.Name]' --output text 2>$null

if ($instances) {
    $instanceIds = ($instances -split "`n" | Where-Object { $_ -match 'i-' } | ForEach-Object { ($_ -split '\s+')[0] })
    if ($instanceIds) {
        Write-Host "Found instances: $($instanceIds -join ', ')" -ForegroundColor Yellow
        aws ec2 terminate-instances --instance-ids $instanceIds
        Write-Host "✅ EC2 instances terminated" -ForegroundColor Green
    }
} else {
    Write-Host "No EC2 instances found" -ForegroundColor Gray
}

# Find and delete S3 bucket
Write-Host "`n🪣 Deleting S3 bucket..." -ForegroundColor Cyan
$bucketName = "ec2-compromise-lab-threat-intel"
try {
    # Force delete all objects and bucket
    aws s3 rm "s3://$bucketName" --recursive 2>$null
    aws s3 rb "s3://$bucketName" --force 2>$null
    Write-Host "✅ S3 bucket deleted" -ForegroundColor Green
} catch {
    Write-Host "S3 bucket already deleted or doesn't exist" -ForegroundColor Gray
}

# Find and delete VPC
Write-Host "`n🌐 Deleting VPC..." -ForegroundColor Cyan
$vpcs = aws ec2 describe-vpcs --filters "Name=tag:Project,Values=EC2-Compromise-Lab" --query 'Vpcs[*].[VpcId]' --output text 2>$null

if ($vpcs) {
    $vpcId = $vpcs.Trim()
    Write-Host "Found VPC: $vpcId" -ForegroundColor Yellow
    
    # Delete VPC endpoints, subnets, route tables, internet gateway
    aws ec2 delete-vpc --vpc-id $vpcId --force 2>$null
    Write-Host "✅ VPC deleted" -ForegroundColor Green
} else {
    Write-Host "No VPC found" -ForegroundColor Gray
}

# Clean up IAM roles
Write-Host "`n🔐 Cleaning up IAM roles..." -ForegroundColor Cyan
$roles = @("lab-ec2-role", "lab-lambda-role")
foreach ($role in $roles) {
    try {
        # Detach policies and delete role
        $policies = aws iam list-attached-role-policies --role-name $role --query 'AttachedPolicies[*].PolicyArn' --output text 2>$null
        if ($policies) {
            foreach ($policy in ($policies -split "`t")) {
                aws iam detach-role-policy --role-name $role --policy-arn $policy 2>$null
            }
        }
        aws iam delete-role --role-name $role 2>$null
        Write-Host "✅ IAM role $role deleted" -ForegroundColor Green
    } catch {
        Write-Host "IAM role $role already deleted or doesn't exist" -ForegroundColor Gray
    }
}

# Clean up CloudWatch resources
Write-Host "`n📊 Cleaning up CloudWatch resources..." -ForegroundColor Cyan
try {
    aws cloudwatch delete-dashboard --dashboard-name "lab-security-dashboard" 2>$null
    Write-Host "✅ CloudWatch dashboard deleted" -ForegroundColor Green
} catch {
    Write-Host "CloudWatch dashboard already deleted or doesn't exist" -ForegroundColor Gray
}

Write-Host "`n🎯 FAST CLEANUP COMPLETE!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host "All lab resources have been cleaned up." -ForegroundColor Green
Write-Host "You can now run 'terraform apply' again for a fresh deployment." -ForegroundColor Green
Write-Host "`n💡 Pro tip: Use 'terraform destroy -auto-approve' for future cleanups!" -ForegroundColor Cyan
