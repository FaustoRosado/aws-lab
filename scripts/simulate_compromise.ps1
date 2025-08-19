# AWS Security Lab - Compromise Simulation Script
# This script simulates various attack scenarios to trigger security alerts

param(
    [Parameter(Mandatory=$true)]
    [string]$WebServerIP
)

# Function to simulate port scanning
function Simulate-PortScan {
    Write-Host "Simulating port scan..." -ForegroundColor Yellow
    
    $commonPorts = @(22, 80, 443, 8080, 3306, 5432, 6379, 27017)
    
    foreach ($port in $commonPorts) {
        try {
            $tcpClient = New-Object System.Net.Sockets.TcpClient
            $tcpClient.ConnectAsync($WebServerIP, $port).Wait(1000)
            
            if ($tcpClient.Connected) {
                Write-Host "Port $port is OPEN" -ForegroundColor Green
                $tcpClient.Close()
            } else {
                Write-Host "Port $port connection failed" -ForegroundColor Red
            }
        }
        catch {
            Write-Host "Port $port connection failed" -ForegroundColor Red
        }
        finally {
            if ($tcpClient) {
                $tcpClient.Close()
            }
        }
    }
}

# Function to simulate brute force attack
function Simulate-BruteForce {
    Write-Host "Simulating brute force attack..." -ForegroundColor Yellow
    
    $commonUsernames = @("admin", "root", "user", "test", "guest")
    $commonPasswords = @("password", "123456", "admin", "root", "test")
    
    foreach ($username in $commonUsernames) {
        foreach ($password in $commonPasswords) {
            try {
                # Simulate SSH connection attempt
                $sshCommand = "ssh -o ConnectTimeout=5 -o BatchMode=yes $username@$WebServerIP"
                $result = Invoke-Expression $sshCommand 2>&1
                
                # This will fail, but that's expected for simulation
                Start-Sleep -Milliseconds 100
            }
            catch {
                # Expected to fail in simulation
                Start-Sleep -Milliseconds 100
            }
        }
    }
    
    Write-Host "Brute force simulation completed" -ForegroundColor Green
}

# Function to simulate SQL injection
function Simulate-SQLInjection {
    Write-Host "Simulating SQL injection..." -ForegroundColor Yellow
    
    $sqlPayloads = @(
        "' OR '1'='1",
        "'; DROP TABLE users; --",
        "' UNION SELECT * FROM users --",
        "admin'--",
        "1' OR '1' = '1' --"
    )
    
    foreach ($payload in $sqlPayloads) {
        try {
            # Simulate HTTP request with SQL injection payload
            $uri = "http://$WebServerIP/login"
            $body = "username=admin&password=$payload"
            
            $headers = @{
                "Content-Type" = "application/x-www-form-urlencoded"
                "User-Agent" = "Security-Test-Script"
            }
            
            try {
                $response = Invoke-RestMethod -Uri $uri -Method POST -Body $body -Headers $headers -TimeoutSec 5
            }
            catch {
                # Expected to fail in simulation
            }
            
            Start-Sleep -Milliseconds 200
        }
        catch {
            # Expected to fail in simulation
        }
    }
    
    Write-Host "SQL injection simulation completed" -ForegroundColor Green
}

# Function to simulate malicious file upload
function Simulate-MaliciousUpload {
    Write-Host "Simulating malicious file upload..." -ForegroundColor Yellow
    
    $maliciousFiles = @(
        "malware.exe",
        "shell.php",
        "backdoor.jsp",
        "trojan.py",
        "virus.bat"
    )
    
    foreach ($filename in $maliciousFiles) {
        try {
            # Create a dummy malicious file content
            $maliciousContent = "This is a simulated malicious file for security testing purposes only."
            
            # Simulate file upload attempt
            $uri = "http://$WebServerIP/upload"
            $boundary = [System.Guid]::NewGuid().ToString()
            
            $LF = "`r`n"
            $bodyLines = @(
                "--$boundary",
                "Content-Disposition: form-data; name=`"file`"; filename=`"$filename`"",
                "Content-Type: application/octet-stream",
                "",
                $maliciousContent,
                "--$boundary--"
            )
            
            $body = $bodyLines -join $LF
            
            $headers = @{
                "Content-Type" = "multipart/form-data; boundary=$boundary"
                "User-Agent" = "Security-Test-Script"
            }
            
            try {
                $response = Invoke-RestMethod -Uri $uri -Method POST -Body $body -Headers $headers -TimeoutSec 5
            }
            catch {
                # Expected to fail in simulation
            }
            
            Start-Sleep -Milliseconds 300
        }
        catch {
            # Expected to fail in simulation
        }
    }
    
    Write-Host "File upload simulation completed" -ForegroundColor Green
}

# Function to simulate network scanning
function Simulate-NetworkScan {
    Write-Host "Simulating network scanning..." -ForegroundColor Yellow
    
    $services = @(
        @{Name="SSH"; Port=22},
        @{Name="HTTP"; Port=80},
        @{Name="HTTPS"; Port=443},
        @{Name="MySQL"; Port=3306},
        @{Name="PostgreSQL"; Port=5432},
        @{Name="Redis"; Port=6379},
        @{Name="MongoDB"; Port=27017}
    )
    
    foreach ($service in $services) {
        try {
            $tcpClient = New-Object System.Net.Sockets.TcpClient
            $tcpClient.ConnectAsync($WebServerIP, $service.Port).Wait(1000)
            
            if ($tcpClient.Connected) {
                Write-Host "$($service.Name) service detected on port $($service.Port)" -ForegroundColor Green
                $tcpClient.Close()
            }
        }
        catch {
            Write-Host "Error testing $($service.Name): $_" -ForegroundColor Red
        }
        finally {
            if ($tcpClient) {
                $tcpClient.Close()
            }
        }
    }
    
    Write-Host "Network scanning simulation completed" -ForegroundColor Green
}

# Function to check for security findings
function Check-SecurityFindings {
    Write-Host "Checking for security findings..." -ForegroundColor Blue
    
    try {
        # Check GuardDuty findings
        $guarddutyFindings = aws guardduty list-findings --detector-id $(aws guardduty list-detectors --query 'DetectorIds[0]' --output text) 2>$null
        
        if ($guarddutyFindings) {
            $findings = $guarddutyFindings | ConvertFrom-Json
            if ($findings.Findings.Count -gt 0) {
                Write-Host "Found $($findings.Findings.Count) GuardDuty findings" -ForegroundColor Green
            } else {
                Write-Host "No GuardDuty findings detected yet" -ForegroundColor Blue
            }
        } else {
            Write-Host "No GuardDuty findings detected yet" -ForegroundColor Blue
        }
        
        # Check Security Hub findings
        $securityHubFindings = aws securityhub get-findings 2>$null
        
        if ($securityHubFindings) {
            $findings = $securityHubFindings | ConvertFrom-Json
            if ($findings.Findings.Count -gt 0) {
                Write-Host "Found $($findings.Findings.Count) Security Hub findings" -ForegroundColor Green
            } else {
                Write-Host "No Security Hub findings detected yet" -ForegroundColor Blue
            }
        } else {
            Write-Host "No Security Hub findings detected yet" -ForegroundColor Blue
        }
    }
    catch {
        Write-Host "Error checking security findings: $_" -ForegroundColor Red
    }
}

# Main execution
Write-Host "AWS Security Lab - Compromise Simulation" -ForegroundColor Red
Write-Host "=========================================" -ForegroundColor Red
Write-Host ""
Write-Host "This script simulates various attack scenarios to trigger security alerts."
Write-Host "This is for educational purposes only!"
Write-Host ""

$confirm = Read-Host "Do you want to continue with the simulation? (y/n)"
if ($confirm -eq "y" -or $confirm -eq "Y") {
    Write-Host "Starting compromise simulation..." -ForegroundColor Green
    
    # Run all simulations
    Simulate-PortScan
    Simulate-BruteForce
    Simulate-SQLInjection
    Simulate-MaliciousUpload
    Simulate-NetworkScan
    
    # Check for findings
    Check-SecurityFindings
    
    Write-Host "Compromise simulation completed!" -ForegroundColor Green
} else {
    Write-Host "Simulation cancelled by user" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Compromise simulation script completed!" -ForegroundColor Green
